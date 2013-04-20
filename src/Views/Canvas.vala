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

namespace Draw
{
	/**
	 * Canvas containre for Draw
	 */
	public class CanvasContainer : Gtk.ScrolledWindow
	{
		public Draw.Window Window { get; set; }
		public Gtk.DrawingArea Canvas { get; set; }
	
		public CanvasContainer(Draw.Window window)
		{
			Window = window;
		
			// Create canvas and content area
			Canvas = new Gtk.DrawingArea();
			Canvas.get_style_context().add_class("canvas");
			Canvas.valign = Gtk.Align.CENTER;
			Canvas.halign = Gtk.Align.CENTER;
			Canvas.width_request = 640;
			Canvas.height_request = 480;
		
			var frame = new Gtk.Frame(null);
			frame.get_style_context().add_class("canvas-frame");
			frame.valign = Gtk.Align.CENTER;
			frame.halign = Gtk.Align.CENTER;
			frame.add(Canvas);
		
			var viewport = new Gtk.Viewport(null, null);
			viewport.get_style_context().add_class("canvas-container");
			viewport.hexpand = true;
			viewport.vexpand = true;
			viewport.add(frame);
		
			// Add all of the elements
			add(viewport);
			expand = true;
		}
	}
}