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
using Gee;
using Granite.Drawing;

namespace Draw
{
	public class ColorTools : Gtk.Box
	{
		private ArrayList<Palette> palettes = new ArrayList<Palette>();
		public Palette activePalette;
	
		public ColorTools()
		{
			palettes = Palette.load_palettes();
			activePalette = palettes[0];
			
			Draw.Tools palette = new Draw.Tools("color-palette", 3, 12, 0);
			
			// Load our colors from the palette in
			for (var i = 0; i < 3; i++)
			{
				for (var ii = 0; ii < 16; ii++)
				{
					var color = activePalette.Colors[(i * 16) + ii];
					palette.add_button(new Gtk.ToolButton (new ColorIcon(color, 12, 12), null), i, true);
				}
			}
			
			valign = Gtk.Align.CENTER;
			add(palette);
		}
	}
}
