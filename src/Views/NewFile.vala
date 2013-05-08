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
		
		const string spacing = " GtkSpinButton { margin-left: 4px; margin-right: 50px; } ";
	
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
		    imageCanvas.width_request = 100;
		    imageCanvas.height_request = 100;
		    imageCanvas.draw.connect((context) =>
		    {
		    	context.set_line_width(1);
		    	context.set_source_rgb(0, 0, 0);
		    	context.rectangle(0, 8, 64, 48);
		    	context.stroke();
		    	return false;
		    });
		    
		    // Create pixels form here
		    var widthText = new Gtk.SpinButton.with_range(1, 60000, 1);
		    //widthText.get_style_context().add_class("form-field");
		    Granite.Widgets.Utils.set_theming(widthText, spacing, null, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
		    widthText.width_request = 120;
		    widthText.value = 640;
		    
		    var heightText = new Gtk.SpinButton.with_range(1, 60000, 1);
		    heightText.get_style_context().add_class("form-field");
		    heightText.width_request = 120;
		    heightText.value = 480;
		    
		    var widthLabel = new Gtk.Label("Width:");
		    widthLabel.justify = Gtk.Justification.RIGHT;
		    
		    var heightLabel = new Gtk.Label("Height:");
		    heightLabel.justify = Gtk.Justification.RIGHT;
		    
		    // ToDO: Figure out CSS to add margins rather than adding whitespace to the text
		    container.attach(imageCanvas, 0, 0, 1, 10);
		    container.attach(new Gtk.Label("Pixel Size"), 1, 0, 1, 1);
		    
		    container.attach(widthLabel, 1, 1, 1, 1);
		    container.attach(widthText, 2, 1, 1, 1);
		    container.attach(new Gtk.Label(" pixels"), 3, 1, 1, 1);
		    
		    container.attach(heightLabel, 1, 2, 1, 1);
		    container.attach(heightText, 2, 2, 1, 1);
		    container.attach(new Gtk.Label(" pixels"), 3, 2, 1, 1);
		    
		    
		    // Create print form here
		    var printWidthText = new Gtk.SpinButton.with_range(0.1, 625.0, 0.5);
		    printWidthText.get_style_context().add_class("form-field");				
		    printWidthText.width_request = 120;
		    printWidthText.value = 6.67;		    
		    
		    var printHeightText = new Gtk.SpinButton.with_range(0.1, 625.0, 0.5);
		    printHeightText.get_style_context().add_class("form-field");
		    printHeightText.width_request = 120;
		    printHeightText.value = 5.00;
		    
		    var printResolutionText = new Gtk.SpinButton.with_range(1, 1000, 1);
		    printResolutionText.get_style_context().add_class("form-field");
		    printResolutionText.width_request = 120;
		    printResolutionText.value = 96;
		    
		    var printWidthLabel = new Gtk.Label("Width:");
		    printWidthLabel.justify = Gtk.Justification.RIGHT;
		    
		    var printHeightLabel = new Gtk.Label("Height:");
		    printHeightLabel.justify = Gtk.Justification.RIGHT;
		    
		    var printResolutionLabel = new Gtk.Label("Resolution: \t");
		    printResolutionLabel.justify = Gtk.Justification.RIGHT;
		    
		    var printWidthTypeLabel = new Gtk.Label(" inches");
		    var printHeightTypeLabel = new Gtk.Label(" inches");
		    var printResolutionTypeLabel = new Gtk.Label(" inches");
		    
		    // ToDO: Figure out CSS to add margins rather than adding whitespace to the text
		    container.attach(new Gtk.Label(" "), 1, 3, 1, 1);
		    container.attach(new Gtk.Label("Print Size"), 1, 4, 1, 1);
		    
		    container.attach(printWidthLabel, 1, 5, 1, 1);
		    container.attach(printWidthText, 2, 5, 1, 1);
		    container.attach(printWidthTypeLabel, 3, 5, 1, 1);
		    
		    container.attach(printHeightLabel, 1, 6, 1, 1);
		    container.attach(printHeightText, 2, 6, 1, 1);
		    container.attach(printHeightTypeLabel, 3, 6, 1, 1);
		    
		    container.attach(printResolutionLabel, 1, 7, 1, 1);
		    container.attach(printResolutionText, 2, 7, 1, 1);
		    container.attach(printResolutionTypeLabel, 3, 7, 1, 1);
		    
		    
		    // Make sure to show everything
		    options.add(container);
		    show_all();
		}
	}
}
