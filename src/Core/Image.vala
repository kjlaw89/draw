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
		
		public string ImageName { get; private set; }
		public string ImageType { get; private set; }
		public string FilePath { get; private set; }
		public string FullPath { get; private set; }
		public bool Modified { get { return Canvas.Modified; } } 
		public Draw.Canvas Canvas { get; private set; }
		public int Width { get { return width; } }
		public int Height { get { return height; } }
		
		public Image() { }
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
				FullPath = path.substring(7);								// drops File:///
				FilePath = file.get_path();
				ImageName = file.get_basename();
			
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
	}
}