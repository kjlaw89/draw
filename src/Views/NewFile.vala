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
	public class NewFile : Granite.Widgets.Welcome
	{
		private Draw.Window Window;
		private Gtk.DrawingArea imageCanvas;
		private int width;
		private int height;
	
		public NewFile(Draw.Window window)
		{
			base("New Image", "Customize your image!");
		    Window = window;
		    width = 640;
		    height = 480;
		    
		    // Create a nice new image form
		    var container = new Gtk.Grid();
		    container.row_homogeneous = false;
		    container.row_spacing = 2;
		    
		    // Create a simple nice little image size representation picture
		    imageCanvas = new Gtk.DrawingArea();
		    imageCanvas.width_request = 200;
		    imageCanvas.height_request = 200;
		    imageCanvas.draw.connect((context) =>
		    {
		    	context.set_line_width(1);
		    	context.set_source_rgb(0, 0, 0);
		    	context.rectangle(40, 8, 64, 48);
		    	context.stroke();
		    	return false;
		    });
		    
		    // Create the form here
		    var widthText = new Granite.Widgets.HintedEntry("Width");
		    widthText.width_request = 200;
		    widthText.text = "640";
		    
		    var heightText = new Granite.Widgets.HintedEntry("Height");
		    heightText.width_request = 200;
		    heightText.text = "480";
		    		    
		    container.attach(imageCanvas, 1, 0, 1, 10);
		    container.attach(widthText, 0, 0, 1, 1);
		    container.attach(heightText, 0, 1, 1, 1);
		    options.add(container);
		    show_all();
		}
	}
}
