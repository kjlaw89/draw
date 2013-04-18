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
    Original Author: Victor Eduardo <victoreduardm@gmail.com>
***/

/**
 * A status bar with a centered label.
 *
 * It supports adding widgets at its left and right sides.
 */
namespace Draw
{
	public class AppToolbar : Gtk.Toolbar {
	
		private int item_spacing = 3;

		/**
		 * Gtk box on the left
		 */ 
		private Gtk.Box left_box;
		
		/**
		 * Gtk box in the center of status bar
		 */ 
		private Gtk.Box center_box;
		
		/**
		 * Gtk box on the right
		 */ 
		private Gtk.Box right_box;

		/**
		 * Creates a new Toolbar.
		 */ 
		public AppToolbar (string css_class, int? spacing) {
			if (spacing != null)
				item_spacing = (!) spacing;
		
		    // Get rid of the "toolbar" class to avoid inheriting its style.
		    // We want the widget to look more like a normal statusbar.
		    get_style_context().remove_class (Gtk.STYLE_CLASS_TOOLBAR);
		    get_style_context().add_class(css_class);

			center_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		    left_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		    right_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

		    var left_item = new Gtk.ToolItem();
		    
		    var center_item = new Gtk.ToolItem();
		    center_item.set_expand(true);
		    
		    var right_item = new Gtk.ToolItem();

		    left_item.add(left_box);
		    center_item.add(center_box);
		    right_item.add(right_box);
		    
		    left_item.valign = right_item.valign = center_item.valign = Gtk.Align.CENTER;

		    insert(left_item, 0);
		    insert(center_item, 1);
		    insert(right_item, 2);
		    vexpand = false;
		}

		/**
		 * Inserts widget in status bar
		 * 
		 * @param widget widget to insert
		 * @param use_left_side whether or not to use left_side
		 */ 
		public void insert_widget (Gtk.Widget widget, ToolbarPosition position) 
		{
			switch (position)
			{
				case ToolbarPosition.LEFT:
					left_box.pack_start (widget, false, false, item_spacing);
					break;
				case ToolbarPosition.CENTER:
					center_box.pack_start (widget, false, false, item_spacing);
					break;
				case ToolbarPosition.RIGHT:
					right_box.pack_start (widget, false, false, item_spacing);
					break;
			}
		}
	}
	
	public enum ToolbarPosition { LEFT, CENTER, RIGHT }
}
