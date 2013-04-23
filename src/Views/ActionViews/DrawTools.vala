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
	public class DrawTools : Draw.Tools
	{
		public DrawTools()
		{
			base("drawtools", 2, 19);
		
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/mouse.png"), "Pointer"), 0, true);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/select.png"), "Select"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/magic_select.png"), "Magic Select"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/dropper.png"), "Dropper"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/eraser.png"), "Eraser"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/clone_stamp.png"), "Clone Stamp"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/bucket.png"), "Bucket"), 1);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/pencil.png"), "Pencil"), 1);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/brush.png"), "Brush"), 1);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/shapes.png"), "Shapes"), 1);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/lines.png"), "Lines"), 1);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/text.png"), "Text"), 1);
		}
	}
}
