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
		public Draw.Window Window { get; private set; }
	
		public DrawTools(Draw.Window window)
		{
			base("drawtools", 1, 19);
			Window = window;
			
			var pointerTool = new Gtk.ToolButton (new Gtk.Image.from_file ("./images/mouse.png"), "Pointer");
			pointerTool.clicked.connect(() =>
			{
				var contents = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
				contents.expand = true;
			
				var thicknessSpinner = new Gtk.SpinButton.with_range(1, 100, 1);
				contents.add(new Gtk.Label("Thickness: "));
				contents.add(thicknessSpinner);
				contents.show_all();
				
				Window.Workspace.set_content(contents);
			});
		
			add_button(pointerTool, 0, true);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/select.png"), "Select"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/magic_select.png"), "Magic Select"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/dropper.png"), "Dropper"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/eraser.png"), "Eraser"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/clone_stamp.png"), "Clone Stamp"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/bucket.png"), "Bucket"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/pencil.png"), "Pencil"), 0);
			add_button(new Draw.BrushTool(), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/shapes.png"), "Shapes"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/lines.png"), "Lines"), 0);
			add_button(new Gtk.ToolButton (new Gtk.Image.from_file ("./images/text.png"), "Text"), 0);
		}
	}
}
