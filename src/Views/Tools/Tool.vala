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

namespace Draw
{
	public abstract class Tool : Gtk.EventBox
	{
		protected Gtk.ToolButton button;
		protected Gtk.Container contents;
		
		/** Tracks whether this tool is selected **/
		public bool Active { get; set; }
		
		public Tool(string image_path, string label)
		{		
			// Create our button and associate it with our event handler
			button = new Gtk.ToolButton(new Gtk.Image.from_file(image_path), label);
			button.clicked.connect(click);
			add(button);
			
			// Associate the hover event with our button
			add_events(Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);
			enter_notify_event.connect((event) =>
			{
				if (!Active)
					return false;
					
				click(button);
				return true;
			});
			
			// Build our interface
			build_ui();
		}
		
		protected abstract void build_ui();
		protected abstract void click(Gtk.ToolButton button);
	}
}