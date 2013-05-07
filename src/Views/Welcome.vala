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
	public class Welcome : Granite.Widgets.Welcome
	{
		private Draw.Window Window;
	
		public Welcome(Draw.Window window)
		{
			base("Welcome to Draw", "Create or load an image and get drawing!");

			Window = window;
			var quick_image = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.DIALOG);
			var new_image = new Gtk.Image.from_icon_name ("document-new", Gtk.IconSize.DIALOG);
			var load_image = new Gtk.Image.from_icon_name ("document-open", Gtk.IconSize.DIALOG);

		    // Adding elements. Use the most convenient method to add an icon
		    append_with_image(quick_image, "Quick Start", "Jump right into drawing with a 640x480 canvas!");
		    append_with_image(new_image, "New", "Create a new image.");
		    append_with_image(load_image, "Load", "Load an image in to modify.");
		    
		    activated.connect((index) =>
		    {
		    	switch (index)
		    	{
		    		case 0:
		    			Window.add_image(new Draw.Image(640, 480), true);
		    			Window.show_content();
		    			break;
		    		case 1:
		    			Window.show_new();
		    			break;
		    		case 2:
		    			if (Image.load_images_dialog(Window))
		    				Window.show_content();
		    				
		    			break;
		    	}
		    });
		}
	}
}
