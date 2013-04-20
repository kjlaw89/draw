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
	        set { titleLabel.label = value; }
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
	        
	        var close = new Gtk.ToolButton (new Gtk.Image.from_file ("/usr/share/themes/elementary/metacity-1/close.svg"), "Close");
	        close.height_request = HEIGHT;
	        close.width_request = HEIGHT;
	        close.clicked.connect (() => Window.destroy());

	        var maximize = new Gtk.ToolButton (new Gtk.Image.from_file ("/usr/share/themes/elementary/metacity-1/maximize.svg"), "Close");
	        maximize.height_request = HEIGHT;
	        maximize.width_request = HEIGHT;
	        maximize.clicked.connect (() => 
	        { 
	        	if (!Window.maximized)
	        	{
	        		Window.get_window().maximize();
	        		Window.maximized = true;
	        	}
	        	else
	    		{
	    			Window.get_window().unmaximize();
	    			Window.maximized = false;
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

			add_left(close);
			add_left(create_separator(HEIGHT));
			add_left(new Gtk.ToolButton.from_stock (Gtk.Stock.NEW));
			add_left(new Gtk.ToolButton.from_stock (Gtk.Stock.OPEN));
			add_left(new Gtk.ToolButton.from_stock (Gtk.Stock.SAVE));
			add_left(create_separator(HEIGHT));
			add_center(titleContainer);
			add_right(create_separator(HEIGHT));
			add_right(new Gtk.ToolButton (new Gtk.Image.from_icon_name ("document-export", Gtk.IconSize.LARGE_TOOLBAR), ""));
			add_right(new Gtk.ToolButton.from_stock (Gtk.Stock.PRINT));
			add_right(create_appmenu());
			add_right(create_separator(HEIGHT));
			add_right(maximize);
		}
		
		public Gtk.ToolItem create_appmenu()
		{
			// App Menu (this gives access to the About dialog)
        	Gtk.Menu settings = new Gtk.Menu ();
        	Gtk.MenuItem about_item = new Gtk.MenuItem.with_label("About");
        	about_item.activate.connect(() => { Window.Application.show_about(Window); });
        	
        	// Add our settings items to our menu
        	settings.add(about_item);
        	return new Granite.Widgets.ToolButtonWithMenu (new Gtk.Image.from_icon_name ("application-menu", Gtk.IconSize.LARGE_TOOLBAR), "", settings);
		}
	}
}
