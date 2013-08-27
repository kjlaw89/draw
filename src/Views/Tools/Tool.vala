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
	public class Tool : Gtk.EventBox
	{
		protected Gtk.ToolButton button;
		protected Gtk.Container contents;
		
		public Gdk.Pixbuf Pixbuf { get; private set; }
		public string Label { get; set; }
		
		public Tool(string imagePath, string label)
		{
			Pixbuf = new Gdk.Pixbuf.from_stream(Draw.Window.Resources.open_stream(imagePath, GLib.ResourceLookupFlags.NONE));
			Label = label;
			
			// Build our interface
			//build_ui();
		}
		
		//protected abstract void build_ui();
	}
}
