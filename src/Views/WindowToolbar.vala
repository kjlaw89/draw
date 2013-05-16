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
	public class WindowToolbar : Draw.Toolbar
	{
		public Draw.Window Window { get; set; }

		Gtk.Label titleLabel;
		public new string Title
		{
			get { return titleLabel.label; }
	        set
	        {
	        	// ToDO: Limit the value to a certain amount of characters
	        	// Preferrably truncating from the beginning (so the loaded
	        	// file is viewable in the title)
	        	if (value != null && value != "Draw")
	        		titleLabel.label = "Draw - " + value;
	        	else
	        		titleLabel.label = "Draw";
	        }
		}

		const int HEIGHT = 48;

		/**
		 * Intializes the main window's toolbar and
		 * establishes all of the events for the buttons
		 * @param window Main Application Window
		 */
		public WindowToolbar(Draw.Window window)
		{
			base("app-toolbar", false, Gtk.IconSize.LARGE_TOOLBAR, 3);
			Window = window;
			
			set_events(Gdk.EventMask.ALL_EVENTS_MASK);
			event.connect(toolbar_clicked);

	        var close = new Gtk.ToolButton (new Gtk.Image.from_file ("/usr/share/themes/elementary/metacity-1/close.svg"), "Close");
	        close.height_request = HEIGHT;
	        close.width_request = HEIGHT;
	        close.clicked.connect (() => Window.destroy());

	        var maximize = new Gtk.ToolButton (new Gtk.Image.from_file ("/usr/share/themes/elementary/metacity-1/maximize.svg"), "Close");
	        maximize.height_request = HEIGHT;
	        maximize.width_request = HEIGHT;
	        maximize.clicked.connect (() =>
	        {
	        	if (!Window.Maximized)
	        	{
	        		Window.maximize();
	        		Window.Maximized = true;
	        	}
	        	else
	    		{
	    			Window.unmaximize();
	    			Window.Maximized = false;
	    		}
	        });

	        // Build up the title label
	        titleLabel = new Gtk.Label ("");
	        titleLabel.get_style_context().add_class("app-title");
	        titleLabel.override_font(Pango.FontDescription.from_string ("bold"));

	        var titleContainer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
	        titleContainer.hexpand = true;
	        titleContainer.vexpand = true;
	        titleContainer.halign = Gtk.Align.CENTER;
	        titleContainer.add(titleLabel);

	        var newButton = new Gtk.ToolButton.from_stock (Gtk.Stock.NEW);
	        newButton.clicked.connect(handle_new);
	        newButton.add_accelerator("clicked", Window.AccelGroup, Gdk.Key.N, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);

	        // Create the open button and assign it it's primary method
	        var openButton = new Gtk.ToolButton.from_stock (Gtk.Stock.OPEN);
	        openButton.clicked.connect(handle_open);
	        openButton.add_accelerator("clicked", Window.AccelGroup, Gdk.Key.O, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
	        
	        var saveButton = new Gtk.ToolButton.from_stock (Gtk.Stock.SAVE);
	        saveButton.clicked.connect(handle_save);
	        saveButton.add_accelerator("clicked", Window.AccelGroup, Gdk.Key.S, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);
	        
	        var saveAsButton = new Gtk.ToolButton.from_stock (Gtk.Stock.SAVE_AS);
	        saveAsButton.clicked.connect(handle_save_as);
	        saveAsButton.add_accelerator("clicked", Window.AccelGroup, Gdk.Key.A, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);

	        var imagesButton = new Gtk.ToolButton.from_stock(Gtk.Stock.ORIENTATION_LANDSCAPE);
	        imagesButton.clicked.connect(handle_images);
	        imagesButton.add_accelerator("clicked", Window.AccelGroup, Gdk.Key.I, Gdk.ModifierType.CONTROL_MASK, Gtk.AccelFlags.VISIBLE);

			add_left(close);
			add_left(create_separator(HEIGHT));
			add_left(newButton);
			add_left(openButton);
			add_left(saveButton);
			add_left(create_separator(HEIGHT));
			add_left(saveAsButton);
			add_left(create_separator(HEIGHT));
			add_center(titleContainer);
			add_right(create_separator(HEIGHT));
			add_right(imagesButton);
			add_right(create_separator(HEIGHT));
			add_right(new Gtk.ToolButton (new Gtk.Image.from_icon_name ("document-export", Gtk.IconSize.LARGE_TOOLBAR), ""));
			add_right(new Gtk.ToolButton.from_stock (Gtk.Stock.PRINT));
			add_right(create_appmenu());
			add_right(create_separator(HEIGHT));
			add_right(maximize);
		}

		/**
		 * Updates the opened images icon with a count badge
		 * @param count Count of images opened
		 */
		public void update_open_count(int count)
		{
		}

		private Gtk.ToolItem create_appmenu()
		{
			// App Menu (this gives access to the About dialog)
        	Gtk.Menu settings = new Gtk.Menu ();
        	Gtk.MenuItem aboutItem = new Gtk.MenuItem.with_label("About");
        	aboutItem.activate.connect(() => { Window.Application.show_about(Window); });
        	
        	// Add our settings items to our menu
        	settings.add(aboutItem);
        	var menuButton = new Granite.Widgets.ToolButtonWithMenu (new Gtk.Image.from_icon_name ("application-menu", Gtk.IconSize.LARGE_TOOLBAR), "", settings);       	
        	return menuButton;
		}
		
		private bool toolbar_clicked(Gtk.Widget widget, Gdk.Event event)
		{
			if (event.type == Gdk.EventType.2BUTTON_PRESS && event.button.button == 1)
			{
				if (!Window.Maximized)
	        	{
	        		Window.maximize();
	        		Window.Maximized = true;
	        	}
	        	else
	    		{
	    			Window.unmaximize();
	    			Window.Maximized = false;
	    		}
			}
			
			return false;
		}
		
		private void handle_new(Gtk.ToolButton button)
		{
			Window.show_new();
		}

		private void handle_open(Gtk.ToolButton button)
		{
			Image.load_images_dialog(Window);
		}
		
		private void handle_save(Gtk.ToolButton button)
		{
			Window.save_image();
		}
		
		private void handle_save_as(Gtk.ToolButton button)
		{
			Window.save_image_as();
		}

		/**
		 * Shows a popover containing all images
		 */
		private void handle_images(Gtk.ToolButton button)
		{
			var popover = new Granite.Widgets.PopOver();
			var popcontent = popover.get_content_area() as Gtk.Container;
			var grid = new Gtk.Grid();
			popcontent.add(grid);

			int row = 0;
			int col = 0;
			for (int i = 0; i < Window.Images.size; i++)
			{
				var image = Window.Images[i];
				var imageButton = new Gtk.Button();
				imageButton.width_request = 65;
				imageButton.height_request = 65;
				imageButton.set_image(image.Thumbnail);
				imageButton.clicked.connect(() => { Window.ActiveImage = image; });

				// Handle creating new rows
				if (i > 0 && i % 5 == 0) 
				{
					row++;
					col = 0;
				}
				
				// Attach the image to the grid and bump up our current 
				grid.attach(imageButton, col, row, 1, 1);
				col++;
			}
			
			popover.move_to_widget(button);
			popover.show_all();
			popover.present();
			popover.run();
			popover.destroy();
		}
	}
}
