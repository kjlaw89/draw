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
	 *
	 * ToDO: Separate the Canvas from the Container so
	 * switching out images does not require recreating a new container
	 */
	public class CanvasContainer : Gtk.ScrolledWindow
	{
		public Draw.Window Window { get; set; }
		public Gtk.DrawingArea Canvas { get; set; }
		
		public int Width
		{
			get { return Canvas.width_request; }
			set { Canvas.width_request = value; }
		}
		
		public int Height
		{
			get { return Canvas.height_request; }
			set { Canvas.height_request = value; }
		}
		
		public int DefaultWidth { get; private set; }
		public int DefaultHeight { get; private set; }
	
		public CanvasContainer(Draw.Window window)
		{
			Window = window;
			
			DefaultWidth = 640;
			DefaultHeight = 480;
		
			// Create canvas and content area
			Canvas = new Gtk.DrawingArea();
			Canvas.get_style_context().add_class("canvas");
			Canvas.valign = Gtk.Align.CENTER;
			Canvas.halign = Gtk.Align.CENTER;
			Width = DefaultWidth;
			Height = DefaultHeight;
		
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
		
		public void canvas_zoom(int width, int height)
		{
			Width = width;
		    Height = height;
		    
		    // ToDO: Perform some image resizing function since we'll be zooming in or out
		    
		    // Extra logging (should be able to be removed eventually
		    stdout.printf("Canvas Resized to (%s, %s)\n", width.to_string(), height.to_string());
		}
		
		/**
		 * Stub method for future use, affects both
		 * Width/Height properties and Default Width/Height
		 * properties
		 */
		public void canvas_resize(int width, int height, ResizeDirection direction)
		{
		}
		
		public enum ResizeDirection
		{
			TOP_LEFT,
			TOP_CENTER,
			TOP_RIGHT,
			MIDDLE_LEFT,
			MIDDLE_CENTER,
			MIDDLE_RIGHT,
			BOTTOM_LEFT,
			BOTTOM_CENTER,
			BOTTOM_RIGHT
		}
	}
}
