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
		private int buttonSize = 20;
		private ArrayList<Gtk.Box> rows = new ArrayList<Gtk.Box>();
		private ArrayList<Gtk.ToolButton> buttons = new ArrayList<Gtk.ToolButton>();

		/**
		 * Buttons associated with Tools
		 */
		public ArrayList<Gtk.ToolButton> Buttons { get { return buttons; } }

		/**
		 * Creates a new Tools
		 * @param style CSS Style to apply to Tools
		 * @param rowsAmount Amount of Rows to make
		 * @param size Size of icons
		 * @param spacing Space between each button
		 * @param hideRowsAfter Amount of rows to show before the rest are in a hidden popup
		 */
		public Tools(string? style, int rowsAmount= 2, int size = 16, int spacing = 1, int hideRowsAfter = 0)
		{
			buttonSize = size;
			cellSpacing = spacing;

			// Add styles if given
			if (style != null)
				get_style_context().add_class((!) style);

			// Create our buttons layout
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
		 * Adds the given button to a row
		 * @param button button to add
		 * @param row Row to add button to
		 * @param focus Defaults focus to new button
		 */
		public void add_button(Gtk.ToolButton button, int row, bool focus = false)
		{
			if (row > rows.size - 1)
				return;

			button.show();
	        button.height_request = buttonSize;
	        button.width_request = buttonSize;

			Gtk.Box selectedRow = rows[row];
			selectedRow.add(button);
			buttons.add(button);

			if (focus)
				focus_button(button);

			button.clicked.connect(button_clicked);
		}
		
		public void button_clicked(Gtk.ToolButton button)
		{
			stdout.printf("button focused\n");
			focus_button(button);
		}

		/**
		 * Removes button from toolbar
		 * @param button button to remove
		 */
		public void remove_button(Gtk.ToolButton button)
		{
			buttons.remove(button);

			foreach(Gtk.Box b in rows)
				b.remove(button);
		}

		/**
		 * Gives focus to the selected button
		 * @param button button to give focus to
		 * @return True if button exists
		 */
		public bool focus_button(Gtk.ToolButton button)
		{
			if (!buttons.contains(button))
				return false;

			foreach(Gtk.ToolButton b in buttons)
				b.get_style_context().remove_class("tool-selected");

			var context = button.get_style_context();
			context.add_class("tool-selected");
			context.reset_widgets(context.screen);		// ToDO: Find a better way to reset the styles so the classes (would prefer not to redraw the window)
			return true;
		}

		/**
		 * Gives focus to the selected button (by index)
		 * @param int button's position to give focus to
		 * @return True if button exists
		 */
		public bool focus_button_by_index(int index)
		{
			if (index > buttons.size - 1)
				return false;

			return (focus_button(buttons.get(index)));
		}
	}
}
