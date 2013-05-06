/***
    Copyright (C) 2013-2014 Draw Developers

    This program or library is free software; you can redistribute it
    and/or modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General
    Public License along with this library; if not, write to the
    Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA 02110-1301 USA.

    Authored by: KJ Lawrence <kjtehprogrammer@gmail.com>
***/

using Granite;
using Granite.Widgets;
using GLib;

namespace Draw
{
	public errordomain ImageError
	{
		NotFound,
		InvalidFormat
	}

	/**
	 * Canvas for drawing
	 */
	public class Image
	{
		private File file;
		private int width;
		private int height;
		
		public string Name { get; private set; }
		public string Type { get; private set; }
		public string FilePath { get; private set; }
		public string FullPath { get; private set; }
		public Draw.Canvas Canvas { get; private set; }
		public int Width { get { return width; } }
		public int Height { get { return height; } }
		public Gtk.Image Thumbnail { get { return Canvas.get_thumbnail(); } }
		
		public bool Modified 
		{ 
			get { return Canvas.Modified; }
			private set { Canvas.Modified = value; } 
		} 
		
		/**
		 * Generates a new image and canvas
		 * @param int Default Width
		 * @param int Default Height
		 */
		public Image(int width, int height, bool transparent = false) 
		{
			this.width = width;
			this.height = height;
			
			Canvas = new Draw.Canvas(width, height, transparent);
			Canvas.show();
		}
		
		public Image.from_path(string path) throws ImageError
		{
			load_image(path);
		}
		
		/**
		 * Loads an image from the given file path
		 * @param path Path of image
		 */
		public void load_image(string path) throws ImageError
		{
			try
			{
				file = File.new_for_path(path);	
			
				// Parse out and load our file
				FullPath = path.substring(7);								// drops 'File:///'
				FilePath = file.get_path();
				Name = file.get_basename();
			
				// Load our pixel buffer and get some general stats
				var buffer = new Gdk.Pixbuf.from_file(FullPath);
				width = buffer.width;
				height = buffer.height;
			
				// Generate and show our canvas
				Canvas = new Canvas.load_from_pixbuf(buffer);
				Canvas.show();
			}
			catch (IOError error)
			{
				throw new ImageError.NotFound(error.message);
			}
			catch (Error error)
			{
				throw new ImageError.InvalidFormat(error.message);
			}
		}
		
		public bool save()
		{
			try
			{
				var imageBuffer = Canvas.get_buffer();
				imageBuffer.save(FullPath, "jpeg");
			}
			catch (Error error)
			{
				stdout.printf("Unable to save image, error: " + error.message);
				return false;
			}
			
			return true;
		}
		
		public bool save_as()
		{
			return true;
		}
		
		/**
		 * Handles the click event for the Open Button
		 * This function kicks off loading a new image file
		 * for the application and setting up canvii
		 */
		public static bool load_images_dialog(Draw.Window Window)
		{
			var imageChooser = new Gtk.FileChooserDialog("Select an image to load...", Window,
				Gtk.FileChooserAction.OPEN,
				Gtk.Stock.CANCEL,
				Gtk.ResponseType.CANCEL,
				Gtk.Stock.OPEN,
				Gtk.ResponseType.ACCEPT);

			imageChooser.select_multiple = true;

			// Set the images we are allowed to open here
			var filter = new Gtk.FileFilter();
			imageChooser.set_filter(filter);

			// Add filters
			filter.add_mime_type("image/bmp");
			filter.add_mime_type("image/jpeg");
			filter.add_mime_type("image/gif");
			filter.add_mime_type("image/png");
			filter.add_mime_type("image/tiff");
			filter.add_mime_type("image/tga");

			// Add preview area
			var previewArea = new Gtk.Image();
			previewArea.width_request = 150;
			previewArea.height_request = 150;
			imageChooser.set_preview_widget(previewArea);
			imageChooser.update_preview.connect(() =>
			{
				string uri = imageChooser.get_preview_uri();

				// We only display local files:
				if (uri.has_prefix ("file://") == true)
				{
					try
					{
						var pixbuf = new Gdk.Pixbuf.from_file(uri.substring (7));

						// If our width/height is greater than 150, scale down
						if (pixbuf.width > 150 || pixbuf.height > 150)
							pixbuf = pixbuf.scale_simple(150, 150, Gdk.InterpType.BILINEAR);

						// Add frame to preview area
						previewArea.set_from_pixbuf(pixbuf);
						previewArea.show();
					}
					catch (Error e)
					{
						previewArea.hide ();
					}
				}

				else
				{
					previewArea.hide ();
				}
			});

			// Handle selections
			if (imageChooser.run() == Gtk.ResponseType.ACCEPT)
			{
				SList<string> uris = imageChooser.get_uris();
				foreach(unowned string uri in uris)
				{
					try
					{
						var image = new Draw.Image.from_path(uri);

						// Add the canvas to the container
						Window.add_image(image, true);
						Window.Title = image.Name;
					}
					catch (Draw.ImageError error)
					{
						stdout.printf("Failed to load image, error: " + error.message);
					}
				}
				
				// Close the chooser and return true
				imageChooser.close();
				return true;
			}

			// Close the chooser and return false (no image selected)
			imageChooser.close();
			return false;
		}
	}
}
