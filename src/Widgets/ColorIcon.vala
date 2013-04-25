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

using Gtk;
using Granite.Drawing;

namespace Draw
{
	public class ColorIcon : Gtk.DrawingArea
	{
		public int Width { get { return width_request; } }
		public int Height { get { return height_request; } }
		
		private Color activeColor;
		public Color Color 
		{ 
			get { return activeColor; }
			set
			{
				activeColor = value;
				queue_draw();
			}
		}
	
		/**
		 * Creates a simple solid color icon for use in various widgets
		 * @param color Color to use for the widgets
		 * @param width Width for the icon
		 * @param height Height for the icon
		 */
		public ColorIcon(Color color, int? width, int? height)
			requires ((width == null || width > 0) && (height == null || height > 0))
		{
			Color = color;
		
			if (width != null)
				width_request = (!) width;
				
			if (height != null)
				height_request = (!) height;
				
			draw.connect((context) =>
			{
				context.set_source_rgba(Color.R, Color.G, Color.B, Color.A);
				context.rectangle(0, 0, Width, Height);
				context.fill();
				return false;
			});
		}
	}
}
