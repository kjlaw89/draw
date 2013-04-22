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

namespace Draw
{
	/**
	 * Toolbar that has 3 individual sections
	 * It supports adding widgets at the left, center and right.
	 *
	 * Toolbar structure:
	 *	<apptoolbar>
	 *		<toolitem>
	 *			<box name="left_box"></box>
	 *		</toolitem>
	 *		<toolitem>
	 *			<box name="center_box" expand="true"></box>
	 *		</toolitem>
	 *		<toolitem>
	 *			<box name="right_box"></box>
	 *		</toolitem>
	 *	</apptoolbar>
	 */
	public class Toolbar : Gtk.Toolbar 
	{
		private int item_spacing = 3;
		private Gtk.Box left_box;
		private Gtk.Box center_box;
		private Gtk.Box right_box;

		/**
		 * Creates a new Toolbar.
		 * @param css_class Style to apply to toolbar
		 * @param size Size to apply to icons
		 * @param spacing Spacing to put between each button
		 */ 
		public Toolbar(string css_class, bool remove_default_style = true, int? size = null, int? spacing = null)
		{
			icon_size = (size != null) ? (!) size : 16;
		
			if (spacing != null)
				item_spacing = (!) spacing;
		
			get_style_context().add_class(css_class);
		
		    // Get rid of the "toolbar" class to avoid inheriting its style.
		    // We want the widget to look more like a normal statusbar.
		    if (remove_default_style)
				get_style_context().remove_class (Gtk.STYLE_CLASS_TOOLBAR);
		    

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
		 * Adds a widget to a given portion of the toolbar
		 * 
		 * @param widget widget to add
		 * @param position where to add the widget
		 */ 
		public new void add(Gtk.Widget widget, ToolbarPosition position = ToolbarPosition.LEFT) 
		{
			switch (position)
			{
				case ToolbarPosition.LEFT:
					left_box.pack_start(widget, false, false, item_spacing);
					break;
				case ToolbarPosition.CENTER:
					center_box.pack_start(widget, false, false, item_spacing);
					break;
				case ToolbarPosition.RIGHT:
					right_box.pack_start(widget, false, false, item_spacing);
					break;
			}
		}
		
		/**
		 * Adds a widget to the left portion of the toolbar
		 * @param widget Widget to add
		 */
		public void add_left(Gtk.Widget widget) { add(widget, ToolbarPosition.LEFT); }
		
		/**
		 * Adds a widget to the center portion of the toolbar
		 * @param widget Widget to add
		 */
		public void add_center(Gtk.Widget widget) { add(widget, ToolbarPosition.CENTER); }
		
		/**
		 * Adds a widget to the right portion of the toolbar
		 * @param widget Widget to add
		 */
		public void add_right(Gtk.Widget widget) { add(widget, ToolbarPosition.RIGHT); }
		
		/**
		 * Creates a nice separator Toolbar item to separate various content
		 * @return Toolitem
		 */
		public Gtk.ToolItem create_separator(int height)
		{
			var sep = new Gtk.ToolItem();
	        sep.height_request = height;
	        sep.width_request = 1;
	        sep.draw.connect ((cr) => 
	        {
                cr.move_to (0, 0);
                cr.line_to (0, 60);
                cr.set_line_width (1);
                var grad = new Cairo.Pattern.linear (0, 0, 0, height);
                grad.add_color_stop_rgba (0, 0.3, 0.3, 0.3, 0.4);
                grad.add_color_stop_rgba (0.8, 0, 0, 0, 0);
                cr.set_source (grad);
                cr.stroke ();
                return true;
	        });
	        
	        sep.get_style_context().add_class("sep");
	        return sep;
		}
		
		/**
		 * Removes a widget from the toolbar (in any place that it appears)
		 * @param widget Widget to remove
		 */
		public new void remove(Gtk.Widget widget)
		{
			left_box.remove(widget);
			center_box.remove(widget);
			right_box.remove(widget);
		}
	}
	
	public enum ToolbarPosition { LEFT, CENTER, RIGHT }
}
