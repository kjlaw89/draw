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
		private double width;
		private double height;
		private double resolution;
		private string type;
		
		// Spinner buttons
		private Gtk.SpinButton widthSpinner;
		private Gtk.SpinButton heightSpinner;
		private Gtk.SpinButton printWidthSpinner;
		private Gtk.SpinButton printHeightSpinner;
		private Gtk.SpinButton printResolutionSpinner;
		private Gtk.Label printWidthTypeLabel;
		private Gtk.Label printHeightTypeLabel;
	
		public NewFile(Draw.Window window)
		{
			base("New Image", "Customize your image!");
		    Window = window;
		    width = 640;
		    height = 480;
		    resolution = 96;
		    type = "inches";
		    
		    // Create a nice new image form
		    var container = new Gtk.Grid();
		    container.row_homogeneous = false;
		    container.row_spacing = 2;
		    container.column_spacing = 2;
		    
		    // Create a simple nice little image size representation picture
		    imageCanvas = new Gtk.DrawingArea();
		    imageCanvas.width_request = 100;
		    imageCanvas.height_request = 100;
		    imageCanvas.draw.connect(image_preview);
		    
		    // Create pixels form here
		    widthSpinner = new Gtk.SpinButton.with_range(1, 60000, 1);
		    widthSpinner.width_request = 120;
		    widthSpinner.value = 640;
		    widthSpinner.value_changed.connect(size_changed);
		    
		    heightSpinner = new Gtk.SpinButton.with_range(1, 60000, 1);
		    heightSpinner.width_request = 120;
		    heightSpinner.value = 480;
		    heightSpinner.value_changed.connect(size_changed);
		    
		    var widthLabel = new Gtk.Label("Width:");
		    widthLabel.halign = Gtk.Align.END;
		    
		    var widthTypeLabel = new Gtk.Label("pixels");
		    widthTypeLabel.halign = Gtk.Align.START;
		    
		    var heightLabel = new Gtk.Label("Height:");
		    heightLabel.halign = Gtk.Align.END;
		    
		    var heightTypeLabel = new Gtk.Label("pixels");
		    heightTypeLabel.halign = Gtk.Align.START;
		    
		    
		    // Create print form here
		    printWidthSpinner = new Gtk.SpinButton.with_range(0.05, 625.0, 0.05);			
		    printWidthSpinner.width_request = 120;
		    printWidthSpinner.value = 6.67;		    
		    printWidthSpinner.value_changed.connect(size_changed);
		    
		    printHeightSpinner = new Gtk.SpinButton.with_range(0.05, 625.0, 0.05);
		    printHeightSpinner.width_request = 120;
		    printHeightSpinner.value = 5.00;
		    printHeightSpinner.value_changed.connect(size_changed);
		    
		    printResolutionSpinner = new Gtk.SpinButton.with_range(0.01, 10000, 0.01);
		    printResolutionSpinner.width_request = 120;
		    printResolutionSpinner.value = 96;
		    printResolutionSpinner.value_changed.connect(() =>
		    {
		    	resolution = printResolutionSpinner.get_value();
		    	change_sizes();
		    });
		    
		    var printWidthLabel = new Gtk.Label("Width:");
		    printWidthLabel.halign = Gtk.Align.END;
		    
		    var printHeightLabel = new Gtk.Label("Height:");
		    printHeightLabel.halign = Gtk.Align.END;
		    
		    var printResolutionLabel = new Gtk.Label("Resolution:");
		    printResolutionLabel.halign = Gtk.Align.END;
		    
		    printWidthTypeLabel = new Gtk.Label("inches");
		    printWidthTypeLabel.halign = Gtk.Align.START;
		    
		    printHeightTypeLabel = new Gtk.Label("inches");
		    printHeightTypeLabel.halign = Gtk.Align.START;
		    
		    var printResolutionTypeLabel = new Gtk.Label("inches");
		    printResolutionTypeLabel.halign = Gtk.Align.START;
		    
            var printResolutionTypeCombo = new Gtk.ComboBoxText();
            printResolutionTypeCombo.append("inches", "pixels/inch");
            printResolutionTypeCombo.append("cm", "pixels/cm");
            //printResolutionTypeCombo.append("mm", "pixels/mm");
            printResolutionTypeCombo.active_id = "inches";
            printResolutionTypeCombo.halign = Gtk.Align.START;
            printResolutionTypeCombo.changed.connect(resolution_changed);

		    
		    // Attach everything to the Gtk.Grid container
		    container.attach(imageCanvas, 0, 0, 1, 10);
		    container.attach(new Gtk.Label("Pixel Size"), 1, 0, 1, 1);
		    
		    container.attach(widthLabel, 1, 1, 1, 1);
		    container.attach(widthSpinner, 2, 1, 1, 1);
		    container.attach(widthTypeLabel, 3, 1, 1, 1);
		    
		    container.attach(heightLabel, 1, 2, 1, 1);
		    container.attach(heightSpinner, 2, 2, 1, 1);
		    container.attach(heightTypeLabel, 3, 2, 1, 1);
		    
		    container.attach(new Gtk.Label(" "), 1, 3, 1, 1);
		    container.attach(new Gtk.Label("Print Size"), 1, 4, 1, 1);
		    
		    container.attach(printResolutionLabel, 1, 5, 1, 1);
		    container.attach(printResolutionSpinner, 2, 5, 1, 1);
		    container.attach(printResolutionTypeCombo, 3, 5, 1, 1);
		    
		    container.attach(printWidthLabel, 1, 6, 1, 1);
		    container.attach(printWidthSpinner, 2, 6, 1, 1);
		    container.attach(printWidthTypeLabel, 3, 6, 1, 1);
		    
		    container.attach(printHeightLabel, 1, 7, 1, 1);
		    container.attach(printHeightSpinner, 2, 7, 1, 1);
		    container.attach(printHeightTypeLabel, 3, 7, 1, 1);
		    
		    // Make sure to show everything
		    options.add(container);
		    show_all();
		}
		
		private void resolution_changed(Gtk.ComboBox combo)
		{
			if (combo.active_id == type)
				return;
		
			// Change resolution values
			resolution = Image.convert_resolution(type, combo.active_id, resolution);
			printResolutionSpinner.value = resolution;
			change_sizes();
		
			// Change resolution labels
			switch(combo.active_id)
			{
				case "inches":
					type = "inches";
					printWidthTypeLabel.label = "inches";
					printHeightTypeLabel.label = "inches";
					break;
				case "cm":
					type = "cm";
					printWidthTypeLabel.label = "centimeters";
					printHeightTypeLabel.label = "centimeters";
					break;
				case "mm":
					type = "mm";
					printWidthTypeLabel.label = "millimeters";
					printHeightTypeLabel.label = "millimeters";
					break;
			}
		}
		
		private void size_changed(Gtk.SpinButton spinner)
		{
			if (spinner == printWidthSpinner || spinner == printHeightSpinner)
				change_sizes(true);
			else
				change_sizes();
		}
	
		private void change_sizes(bool printField = false)
		{
			if (printField)
			{
				var newWidth = printWidthSpinner.value;
				var newHeight = printHeightSpinner.value;
				
				width = newWidth * resolution;
				height = newHeight * resolution;
				
				// Have to remove the signal from the spinners before you change their value
				widthSpinner.value_changed.disconnect(size_changed);
				heightSpinner.value_changed.disconnect(size_changed);
				widthSpinner.value = width;
				heightSpinner.value = height;
				widthSpinner.value_changed.connect(size_changed);
				heightSpinner.value_changed.connect(size_changed);
			}
			else
			{
				width = widthSpinner.value;
				height = heightSpinner.value;
				
				// Have to remove the signal from the spinners before you change their value
				printWidthSpinner.value_changed.disconnect(size_changed);
				printHeightSpinner.value_changed.disconnect(size_changed);
				printWidthSpinner.value = width / resolution;
				printHeightSpinner.value = height / resolution;
				printWidthSpinner.value_changed.connect(size_changed);
				printHeightSpinner.value_changed.connect(size_changed);
			}
			
			imageCanvas.queue_draw();
		}
		
		private bool image_preview(Gtk.Widget canvas, Cairo.Context context)
		{
			maxWidth = 200;
			maxHeight = 200;
			drawWidth = (maxWidth / width) * width;
			drawHeight = (maxHeight / height ) * height;
		
	    	context.set_line_width(1);
	    	context.set_source_rgb(0, 0, 0);
	    	context.rectangle(0, 8, 64, 48);
	    	context.stroke();
	    	return false;
		}
	}
}
