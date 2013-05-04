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

	        // Create the open button and assign it it's primary method
	        var openButton = new Gtk.ToolButton.from_stock (Gtk.Stock.OPEN);
	        openButton.clicked.connect(handle_open);

	        var imagesButton = new Gtk.ToolButton.from_stock(Gtk.Stock.ORIENTATION_LANDSCAPE);
	        imagesButton.clicked.connect(handle_images);

			add_left(close);
			add_left(create_separator(HEIGHT));
			add_left(newButton);
			add_left(openButton);
			add_left(new Gtk.ToolButton.from_stock (Gtk.Stock.SAVE));
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
        	Gtk.MenuItem about_item = new Gtk.MenuItem.with_label("About");
        	about_item.activate.connect(() => { Window.Application.show_about(Window); });

        	// Add our settings items to our menu
        	settings.add(about_item);
        	return new Granite.Widgets.ToolButtonWithMenu (new Gtk.Image.from_icon_name ("application-menu", Gtk.IconSize.LARGE_TOOLBAR), "", settings);
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

		/**
		 * Handles the click event for the Open Button
		 * This function kicks off loading a new image file
		 * for the application and setting up canvii
		 */
		private void handle_open(Gtk.ToolButton button)
		{
			var imageChooser = new Gtk.FileChooserDialog("Select an image to load...", Window,
				Gtk.FileChooserAction.OPEN,
				Gtk.Stock.CANCEL,
				Gtk.ResponseType.CANCEL,
				Gtk.Stock.OPEN,
				Gtk.ResponseType.ACCEPT);

			imageChooser.select_multiple = true;

			// Set the images we are allowed to open here
			var filter = new Gtk.FileFilter();
			imageChooser.set_filter(filter);

			// Add filters
			filter.add_mime_type("image/bmp");
			filter.add_mime_type("image/jpeg");
			filter.add_mime_type("image/gif");
			filter.add_mime_type("image/png");
			filter.add_mime_type("image/tiff");
			filter.add_mime_type("image/tga");

			// Add preview area
			var previewArea = new Gtk.Image();
			previewArea.width_request = 150;
			previewArea.height_request = 150;
			imageChooser.set_preview_widget(previewArea);
			imageChooser.update_preview.connect(() =>
			{
				string uri = imageChooser.get_preview_uri();

				// We only display local files:
				if (uri.has_prefix ("file://") == true)
				{
					try
					{
						var pixbuf = new Gdk.Pixbuf.from_file(uri.substring (7));

						// If our width/height is greater than 150, scale down
						if (pixbuf.width > 150 || pixbuf.height > 150)
							pixbuf = pixbuf.scale_simple(150, 150, Gdk.InterpType.BILINEAR);

						// Add frame to preview area
						previewArea.set_from_pixbuf(pixbuf);
						previewArea.show();
					}
					catch (Error e)
					{
						previewArea.hide ();
					}
				}

				else
				{
					previewArea.hide ();
				}
			});

			// Handle selections
			if (imageChooser.run() == Gtk.ResponseType.ACCEPT)
			{
				SList<string> uris = imageChooser.get_uris();
				foreach(unowned string uri in uris)
				{
					var pixbuf = new Gdk.Pixbuf.from_file(uri.substring (7));
					var Canvas = new Canvas.load_from_pixbuf(pixbuf);
					Canvas.show();

					// Add the canvas to the container
					Window.add_image(Canvas, true);
					Title = uri.substring(7);
				}
			}

			// Close the chooser
			imageChooser.close();
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
				imageButton.set_image(image.get_thumbnail());

				imageButton.clicked.connect(() =>
				{
					Window.CanvasContainer.Canvas = image;
				});

				if (i > 0 && i % 3 == 0) 
				{
					row++;
					col = 0;
				}
				
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
