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
	public class Workspace : Gtk.ScrolledWindow
	{
		// Public signals that any widget can use to gather details about the currently active image
		public signal void motion_occurred(double x, double y);
		public signal void button_pressed(Gdk.EventButton event);
		public signal void button_released(Gdk.EventButton event);
		public signal void selected_region_updated(double x, double y);
	
		protected Draw.Window Window { get; set; }
		private Gtk.Frame CanvasFrame { get; set; }
		
		private Draw.Canvas activeCanvas;
		public Draw.Canvas Canvas 
		{ 
			get { return activeCanvas; }
			set 
			{
				// Remove the old canvas and disconnect the events if we had one
				if (activeCanvas != null)
				{
					CanvasFrame.remove(activeCanvas);
					
					// Disconnect events
					activeCanvas.motion_notify_event.disconnect(motion_event);
					activeCanvas.leave_notify_event.disconnect(leave_event);
				}
					
				activeCanvas = value;
				Window.Canvas = value;
				
				// Attach all of our events
				activeCanvas.motion_notify_event.connect(motion_event);
				activeCanvas.leave_notify_event.connect(leave_event);
				
				// Add the new canvas
				CanvasFrame.add(activeCanvas);
			}
		}	
	
		public Workspace(Draw.Window window)
		{
			Window = window;
		
			CanvasFrame = new Gtk.Frame(null);
			CanvasFrame.get_style_context().add_class("canvas-frame");
			CanvasFrame.valign = Gtk.Align.CENTER;
			CanvasFrame.halign = Gtk.Align.CENTER;
			
			// Research resizing the canvas area by grabbing at the border
		
			var viewport = new Gtk.Viewport(null, null);
			viewport.get_style_context().add_class("canvas-container");
			viewport.hexpand = true;
			viewport.vexpand = true;
			viewport.add(CanvasFrame);
		
			// Add all of the elements
			add(viewport);
			expand = true;
		}
		
		/**
		 * Handles mouse motion events on the canvas area
		 * @param canvas Canvas
		 * @param event Motion event that occurred
		 */
		public bool motion_event(Gtk.Widget canvas, Gdk.EventMotion event)
		{
			motion_occurred(event.x, event.y);
			return false;
		}
		
		public bool leave_event(Gtk.Widget canvas, Gdk.EventCrossing event)
		{
			motion_occurred(-1, -1);
			return false;
		}
		
		public void zoom(double zoomAmount)
		{
			Canvas.zoom(zoomAmount);
		}
	}
}
