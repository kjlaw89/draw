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
		private Gdk.PixbufFormat info;
		private int width;
		private int height;
		
		public string Name { get; private set; }
		public string FolderPath { get; private set; }
		public string Type { get; private set; }
		public int Quality { get; private set; }
		public Draw.Canvas Canvas { get; private set; }
		public int Width { get { return width; } }
		public int Height { get { return height; } }
		public double Resolution { get; set; }
		public string PrintType { get; set; }
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
			this.Resolution = 96;
			this.PrintType = "inch";
			
			Canvas = new Draw.Canvas(width, height, transparent);
			Canvas.show();
		}
		
		public Image.with_resolution(int width, int height, double resolution, string printType, bool transparent = false)
		{
			this.width = width;
			this.height = height;
			this.Resolution = resolution;
			this.PrintType = printType;
			
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
				Name = file.get_basename();
				FolderPath = path.replace(Name, "");
			
				// Load our pixel buffer and get some general stats
				var buffer = new Gdk.Pixbuf.from_file(FolderPath + Name);
				
				// Image info
				info = Gdk.Pixbuf.get_file_info(FolderPath + Name, out width, out height);
				Type = info.get_name();
			
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
		
		/**
		 * Saves the image with the original filename and type
		 */
		public bool save(Draw.Window Window)
		{
			try
			{
				if (Name != null && FolderPath != null && Type != null)
				{
					var imageBuffer = Canvas.get_buffer();
					imageBuffer.save(FolderPath, Type);
				}
				else
					save_as(Window);
			}
			catch (Error error)
			{
				stdout.printf("Unable to save image, error: " + error.message);
				return false;
			}
			
			return true;
		}
		
		public bool save_as(Draw.Window Window)
		{
			var fileType = "png";
			var imageChooser = new Gtk.FileChooserDialog("Save As...", Window,
				Gtk.FileChooserAction.SAVE,
				Gtk.Stock.CANCEL,
				Gtk.ResponseType.CANCEL,
				Gtk.Stock.SAVE,
				Gtk.ResponseType.ACCEPT);
				
			// Check for overwrite
			imageChooser.do_overwrite_confirmation = true;
				
			// Set the images we are allowed to save to here
			var filter = new Gtk.FileFilter();
			imageChooser.set_filter(filter);

			// Add filters
			filter.add_mime_type("image/bmp");
			filter.add_mime_type("image/jpeg");
			filter.add_mime_type("image/gif");
			filter.add_mime_type("image/png");
			filter.add_mime_type("image/tiff");
			filter.add_mime_type("image/tga");
			
			// File type dropdown widget
			var formatsCombo = new Gtk.ComboBoxText();
			formatsCombo.append("bmp", "*.bmp");
			formatsCombo.append("jpeg", "*.jpg, *.jpeg, *.jpe, *.jiff");
			formatsCombo.append("png", "*.png");
			formatsCombo.append("tiff", "*.tif, *.tiff");
			formatsCombo.append("tga", "*.tga");
			formatsCombo.active_id = "png";
			formatsCombo.changed.connect(() =>
			{
				fileType = formatsCombo.active_id;
				var fileName = imageChooser.get_file().get_basename();
				string[] fileParts = fileName.split(".");
				
				// Reconstruct the file with the new filetype
				fileName = "";
				for (int i = 0; i < fileParts.length; i++)
				{
					if (i != fileParts.length - 1)
						fileName += fileParts[i] + ".";
					else
					{
						switch (fileType)
						{
							case "jpeg":
								fileName += "jpg";
								break;
							case "tiff":
								fileName += "tif";
								break;
							default:
								fileName += fileType;
								break;
						}
					}
						
				}
				
				imageChooser.set_current_name(fileName);
			});
			
			imageChooser.extra_widget = formatsCombo;
			
			// If we have an active file already, load in the details
			if (FolderPath != null && Name != null)
				imageChooser.set_filename(FolderPath + Name);

			// Handle saving the new image			
			if (imageChooser.run() == Gtk.ResponseType.ACCEPT)
			{
				// Backup the old details encase anything happens
				var oldFile = file;
				var oldName = Name;
				var oldPath = FolderPath;
				var oldType = Type;
					
				try
				{
					file = imageChooser.get_file();
					Name = file.get_basename();
					FolderPath = imageChooser.get_filename().replace(Name, "");
					Type = fileType;
					
					var imageBuffer = Canvas.get_buffer();
					imageBuffer.save(FolderPath + Name, Type);
					
					// Image info
					info = Gdk.Pixbuf.get_file_info(FolderPath + Name, out width, out height);
					Type = info.get_name();
					Window.Title = Name;
					
					// If the file types are the same, just reload 
					// and replace this image (incase of quality change)
					if (Type == oldType)
					{
						var newImage = new Image.from_path(FolderPath + Name);
						Window.replace_image(this, newImage);
					}
					
					// else open the new image as a separate file
					else
					{
						var newImage = new Image.from_path(FolderPath + Name);
						Window.add_image(newImage, true);
					}
				}
				catch (Error error)
				{
					stdout.printf("Error saving file: " + error.message);
					
					// Restore backup details
					file = oldFile;
					Name = oldName;
					FolderPath = oldPath;
					Type = oldType;
				}
			}
			
			imageChooser.close();
				
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
				SList<string> images = imageChooser.get_filenames();
				foreach(unowned string imagePath in images)
				{
					try
					{
						var image = new Draw.Image.from_path(imagePath);

						// Add the canvas to the container
						Window.add_image(image, true);
						Window.Title = image.Name;
						Window.show_content();
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
		
		/**
		 * Converts from one resolution to another
		 * @param from Current resolution (inches, cm, mm)
		 * @param to New resolution (inches, cm, mm)
		 * @return double New resolution
		 */
		public static double convert_resolution(string from, string to, double value)
		{
			if (from == to)
				return value;
				
			switch (from)
			{
				case "inches":
					if (to == "cm")
						return value / 2.54;
					else
						return value / 25.4;
				case "cm":
					if (to == "inches")
						return value * 2.54;
					else
						return value / 10;
			}
			
			return value;
		}
	}
}
