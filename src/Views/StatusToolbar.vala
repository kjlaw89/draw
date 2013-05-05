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

namespace Draw
{
	public class StatusToolbar : Draw.Toolbar
	{
		public Draw.Window Window { get; set; }
		public Draw.CanvasContainer Canvas { get; private set; }
		private Gtk.Scale zoomWidget;
		
		/**
		 * Intializes the main window's toolbar and
		 * establishes all of the events for the buttons
		 * @param window Main Application Window
		 */
		public StatusToolbar(Draw.Window window)
		{
			base("status-toolbar");
			Window = window;
			
			// Get our canvas for use in the toolbar
			Canvas = Window.CanvasContainer;
			
			zoomWidget = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 25, 800, 25);
		    zoomWidget.get_style_context().add_class("zoom-widget");
		    zoomWidget.tooltip_text = "Zoom";
		    zoomWidget.width_request = 150;
		    zoomWidget.value_pos = Gtk.PositionType.LEFT;
		    zoomWidget.set_value(100);
		    
		    // Hack way of getting the slider to lock to 25-increments
		    zoomWidget.value_changed.connect(() =>
		    {
		    	double zValue = zoomWidget.get_value();
		    	double newValue = Math.round((zValue / 25.0)) * 25.0;
		    	zoomWidget.set_value(newValue);
		    	
		    	// Get the canvas's current size and adjust it for the new zoom
		    	Canvas.canvas_zoom(newValue / 100.0);
		    });
		    
		    // Application Statusbar (used for image zooming, canvas size details, mouse position and general stats)
			add_right(zoomWidget);
		}
	}
}
