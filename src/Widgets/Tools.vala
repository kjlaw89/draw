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

using Gtk;
using Gee;

namespace Draw
{
	/**
	 * Structure:
	 *	<Box>
	 *		<Grid>
	 *			<Row>
	 *				<Box>
	 *					<modebutton />
	 *					<modebutton />
	 *				</Box>
	 *			</Row>
	 *			<Row>
	 *				<Box>
	 *					<modebutton />
	 *					<modebutton />
	 *				</Box>
	 *			</Row>
	 *			...
	 *		</Grid>
	 *	</Box>
	 *
	 * ToDO: Add the ability to hover over the Tools and show hidden rows dynamically
	 */
	public class Tools : Gtk.Box
	{
		private int cellSpacing = 0;
		private int widgetSize = 20;
		private ArrayList<Gtk.Box> rows = new ArrayList<Gtk.Box>();
		private ArrayList<Gtk.Widget> widgets = new ArrayList<Gtk.Widget>();
		
		/**
		 * Widgets associated with Tools
		 */
		public ArrayList<Gtk.Widget> Widgets { get { return widgets; } }
	
		/**
		 * Creates a new Tools 
		 * @param rows Amount of Rows to make
		 * @param spacing Space between each widget
		 * @param hideRowsAfter Amount of rows to show before the rest are in a hidden popup
		 */
		public Tools(int rowsAmount= 2, int size = 16, int spacing = 1, int hideRowsAfter = 0)
		{
			widgetSize = size;
			cellSpacing = spacing;
		
			// Create our widgets layout
			var grid = new Gtk.Grid();
			grid.row_spacing = spacing;
			base.add(grid);
			
			// Attach the individual boxes to each row
			for(int i = 0; i < rowsAmount; i++)
			{
				var row = new Gtk.Box(Gtk.Orientation.HORIZONTAL, spacing);
				rows.add(row);
				
				if (hideRowsAfter != 0 && i > hideRowsAfter)
					row.hide();
				
				grid.attach(row, 0, i, 1, 1);
			}
		}
		
		/**
		 * Adds the given widget to a row
		 * @param widget Widget to add
		 * @param row Row to add widget to
		 * @param focus Defaults focus to new widget
		 */
		public void add_widget(Gtk.Widget widget, int row, bool focus = false)
		{
			if (row > rows.size - 1)
				return;
			
			widget.show();
	        widget.height_request = widgetSize;
	        widget.width_request = widgetSize;
			
			Gtk.Box selectedRow = rows[row];
			selectedRow.add(widget);
			widgets.add(widget);
			focus_widget(widget);
		}
		
		/**
		 * Removes widget from toolbar
		 * @param widget Widget to remove
		 */
		public void remove_widget(Gtk.Widget widget)
		{
			widgets.remove(widget);
			
			foreach(Gtk.Box b in rows)
				b.remove(widget);
		}
		
		/**
		 * Gives focus to the selected widget
		 * @param widget Widget to give focus to
		 * @return True if widget exists
		 */
		public bool focus_widget(Gtk.Widget widget)
		{
			if (!widgets.contains(widget))
				return false;
				
			foreach(Gtk.Widget w in widgets)
				w.get_style_context().remove_class("tool-selected");
				
			widget.get_style_context().add_class("tool-selected");
			return true;
		}
		
		/**
		 * Gives focus to the selected widget (by index)
		 * @param int Widget's position to give focus to
		 * @return True if widget exists
		 */
		public bool focus_widget_by_index(int index)
		{
			if (index > widgets.size - 1)
				return false;
				
			return (focus_widget(widgets.get(index)));
		}
	}
}
