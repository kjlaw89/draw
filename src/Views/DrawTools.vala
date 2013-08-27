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
			
			var pointerBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/mouse.png", GLib.ResourceLookupFlags.NONE));
			var pointerTool = new Gtk.ToolButton (new Gtk.Image.from_pixbuf(pointerBuf), "Pointer");
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
			
			var selectBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/select.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(selectBuf), "Select"), 0);
			
			var magicBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/magic_select.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(magicBuf), "Magic Select"), 0);
			
			var dropperBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/dropper.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(dropperBuf), "Dropper"), 0);
			
			var eraserBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/eraser.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(eraserBuf), "Eraser"), 0);
			
			var cloneBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/clone_stamp.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(cloneBuf), "Clone Stamp"), 0);
			
			var bucketBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/bucket.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(bucketBuf), "Bucket"), 0);
			
			var pencilBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/pencil.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(pencilBuf), "Pencil"), 0);
			
			add_button(new Draw.BrushTool(), 0);
			
			var shapesBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/shapes.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(shapesBuf), "Shapes"), 0);
			
			var linesBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/lines.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(linesBuf), "Lines"), 0);
			
			var textBuf = new Pixbuf.from_stream(Draw.Window.Resources.open_stream("/draw/images/text.png", GLib.ResourceLookupFlags.NONE));
			add_button(new Gtk.ToolButton (new Gtk.Image.from_pixbuf(textBuf), "Text"), 0);
		}
	}
}
