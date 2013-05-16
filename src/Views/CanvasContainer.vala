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
using Gee;

namespace Draw
{
	/**
	 * Canvas containre for Draw
	 *
	 * ToDO: Separate the Canvas from the Container so
	 * switching out images does not require recreating a new container
	 */
	public class CanvasContainer : Gtk.ScrolledWindow
	{
		protected Draw.Window Window { get; set; }
		private Gtk.Frame CanvasFrame { get; set; }
		
		private Draw.Canvas activeCanvas;
		public Draw.Canvas Canvas 
		{ 
			get { return activeCanvas; }
			set 
			{
				// Remove the old canvas if we had one
				if (activeCanvas != null)
					CanvasFrame.remove(activeCanvas);
					
				activeCanvas = value;
				Window.Canvas = value;
				
				// Add the new canvas
				CanvasFrame.add(activeCanvas);
			}
		}	
	
		public CanvasContainer(Draw.Window window)
		{
			Window = window;
			//set_capture_button_press(true);  // ToDO: Research more - related to touch events
			//set_kinetic_scrolling(true);
		
			CanvasFrame = new Gtk.Frame(null);
			CanvasFrame.get_style_context().add_class("canvas-frame");
			CanvasFrame.valign = Gtk.Align.CENTER;
			CanvasFrame.halign = Gtk.Align.CENTER;
		
			var viewport = new Gtk.Viewport(null, null);
			viewport.get_style_context().add_class("canvas-container");
			viewport.hexpand = true;
			viewport.vexpand = true;
			viewport.add(CanvasFrame);
		
			// Add all of the elements
			add(viewport);
			expand = true;
		}
		
		public void canvas_zoom(double zoomAmount)
		{
			Canvas.canvas_zoom(zoomAmount);
		}
	}
}
