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
	 * New Image form based off of the Granite.Widgets.Welcome screen
	 *
	 * Structure:
	 *	<Gtk.Grid>
	 *		1		2		  3			4		5		  6
	 *	1	<Label>						<Label>
	 *	2	<Label>	<Spinner> <Label>	<Label>	<Spinner> <ComboBoxText>
	 *	3	<Label>	<Spinner> <Label>	<Label>	<Spinner> <Label>
	 *	4								<Label>	<Spinner> <Label>
	 *	5
	 *	6	<ComboBoxText>								  <Button>
	 *	</Gtk.Grid>
	 */
	public class NewImage : Granite.Widgets.Welcome
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
		private Gtk.ComboBoxText printResolutionTypeCombo;
		private Gtk.Label printWidthTypeLabel;
		private Gtk.Label printHeightTypeLabel;
	
		/**
		 * Class initializes a New Image form
		 * @param window Reference to the parent Draw window
		 */
		public NewImage(Draw.Window window)
		{
			base("New Image", "Customize your image!");
		    Window = window;
		    
		    var container = new Gtk.Grid();
		    container.row_homogeneous = false;
		    container.row_spacing = 2;
		    container.column_spacing = 2;
		    
		    // Create all active form elements (all elements that are filled in or otherwise modified)
		    widthSpinner = new Gtk.SpinButton.with_range(1, 60000, 1);
		    widthSpinner.width_request = 120;
		    
		    heightSpinner = new Gtk.SpinButton.with_range(1, 60000, 1);
		    heightSpinner.width_request = 120;
		    
		    printWidthSpinner = new Gtk.SpinButton.with_range(0.05, 625.0, 0.05);			
		    printWidthSpinner.width_request = 120;
		    
		    printHeightSpinner = new Gtk.SpinButton.with_range(0.05, 625.0, 0.05);
		    printHeightSpinner.width_request = 120;
		    
		    printWidthTypeLabel = new Gtk.Label("inches");
		    printWidthTypeLabel.halign = Gtk.Align.START;
		    
		    printHeightTypeLabel = new Gtk.Label("inches");
		    printHeightTypeLabel.halign = Gtk.Align.START;
		    
		    printResolutionSpinner = new Gtk.SpinButton.with_range(0.01, 10000, 0.01);
		    printResolutionSpinner.width_request = 120;
		    printResolutionSpinner.value_changed.connect(size_changed);
		    
		    printResolutionTypeCombo = new Gtk.ComboBoxText();
            printResolutionTypeCombo.append("inches", "pixels/inch");
            printResolutionTypeCombo.append("cm", "pixels/cm");
            printResolutionTypeCombo.active_id = "inches";
            printResolutionTypeCombo.halign = Gtk.Align.START;
            printResolutionTypeCombo.changed.connect(resolution_changed);
		    
            var createImageButton = new Gtk.Button.with_label("Create Image");
		    createImageButton.clicked.connect(create_image);
		    //createImageButton.get_style_context().add_class("blue-highlight");		// find out if there's a class for the eOS blue button
		    
		    // Create all inactive form elements (mostly labels that are unchanged)
		    var widthLabel = new Gtk.Label("Width:");
		    widthLabel.halign = Gtk.Align.END;
		    
		    var widthTypeLabel = new Gtk.Label("pixels");
		    widthTypeLabel.halign = Gtk.Align.START;
		    
		    var heightLabel = new Gtk.Label("Height:");
		    heightLabel.halign = Gtk.Align.END;
		    
		    var heightTypeLabel = new Gtk.Label("pixels");
		    heightTypeLabel.halign = Gtk.Align.START;
		    
		    var printWidthLabel = new Gtk.Label("Width:");
		    printWidthLabel.halign = Gtk.Align.END;
		    
		    var printHeightLabel = new Gtk.Label("Height:");
		    printHeightLabel.halign = Gtk.Align.END;
		    
		    var printResolutionLabel = new Gtk.Label("   Resolution:");
		    printResolutionLabel.halign = Gtk.Align.END;
		    
		    var printResolutionTypeLabel = new Gtk.Label("inches");
		    printResolutionTypeLabel.halign = Gtk.Align.START;

		    var pixelHeaderLabel = new Gtk.Label("<b>Pixel Size</b>");
		    pixelHeaderLabel.use_markup = true;
		    pixelHeaderLabel.halign = Gtk.Align.START;
		    
		    var printHeaderLabel = new Gtk.Label("   <b>Print Size</b>");
		    printHeaderLabel.use_markup = true;
		    printHeaderLabel.halign = Gtk.Align.START;
		    
		    
		    // Attach everything to the Gtk.Grid container
		    container.attach(pixelHeaderLabel, 1, 0, 3, 1);
		    container.attach(printHeaderLabel, 4, 0, 3, 1);
		    
		    // Width / Resolution Row
		    container.attach(widthLabel, 1, 1, 1, 1);
		    container.attach(widthSpinner, 2, 1, 1, 1);
		    container.attach(widthTypeLabel, 3, 1, 1, 1);
		    
		    container.attach(printResolutionLabel, 4, 1, 1, 1);
		    container.attach(printResolutionSpinner, 5, 1, 1, 1);
		    container.attach(printResolutionTypeCombo, 6, 1, 1, 1);
		    
		    // Height / Print Width Row
		    container.attach(heightLabel, 1, 2, 1, 1);
		    container.attach(heightSpinner, 2, 2, 1, 1);
		    container.attach(heightTypeLabel, 3, 2, 1, 1);
		    
		    container.attach(printWidthLabel, 4, 2, 1, 1);
		    container.attach(printWidthSpinner, 5, 2, 1, 1);
		    container.attach(printWidthTypeLabel, 6, 2, 1, 1);
		    
		    // Print Height row
		    container.attach(printHeightLabel, 4, 3, 1, 1);
		    container.attach(printHeightSpinner, 5, 3, 1, 1);
		    container.attach(printHeightTypeLabel, 6, 3, 1, 1);
		    
		    container.attach(new Gtk.Label(""), 6, 4, 1, 2);
		    container.attach(createImageButton, 6, 6, 1, 1);
		    
		    // Reset to default values and show everything
		    reset();
		    options.add(container);
		    show_all();
		}
		
		/**
		 * Resets the NewFile screen back to its default settings
		 */
		private void reset()
		{
			width = 640;
		    height = 480;
		    resolution = 96;
		    type = "inches";
		    printResolutionTypeCombo.active_id = "inches";
		    
		    // Remove all signals from each object to update their values
		    widthSpinner.value_changed.disconnect(size_changed);
		    heightSpinner.value_changed.disconnect(size_changed);
		    printWidthSpinner.value_changed.disconnect(size_changed);
		    printHeightSpinner.value_changed.disconnect(size_changed);
		    printResolutionSpinner.value_changed.disconnect(size_changed);
		    
		    // Update the spinner values
		    widthSpinner.value = width;
		    heightSpinner.value = height;
		    printResolutionSpinner.value = resolution;
		    
		    // Add all signals back for each object
		    widthSpinner.value_changed.connect(size_changed);
		    heightSpinner.value_changed.connect(size_changed);
		    printResolutionSpinner.value_changed.connect(size_changed);
		    printHeightSpinner.value_changed.connect(size_changed);
		    printResolutionSpinner.value_changed.connect(size_changed);
		    
		    // Kick off size changed for the pixel size so the print boxes will update
		    size_changed(widthSpinner);
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
			}
		}
		
		/**
		 * Used when the "value_changed" signal is actived on a spinner
		 * @param spinner Spinner the value was activated on
		 */
		private void size_changed(Gtk.SpinButton spinner)
		{
			if (spinner == printWidthSpinner || spinner == printHeightSpinner)
				change_sizes(true);
			else if (spinner == printResolutionSpinner)
			{
				resolution = printResolutionSpinner.get_value();
		    	change_sizes();
			}
			else
				change_sizes();
		}
	
		/**
		 * Handles changing the sizes in all of the various boxes
		 * @param printField If true then the print size fields were modified
		 */
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
		}
		
		/**
		 * Handles creating a new image with all of the given details (actived when Create Image button clicked)
		 * @param button Button that was clicked
		 */		
		private void create_image(Gtk.Button button)
		{
			Window.add_image(new Image.with_resolution((int)width, (int)height, resolution, type), true);
			Window.show_content();
			reset();
		}
	}
}
