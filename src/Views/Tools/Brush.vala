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
	public class BrushTool : Draw.Tool
	{
		public BrushTool()
		{
			base("/write/images/brush.png", "Brush");
		}
		
		/*public override void build_ui()
		{
			// Bucket tools
			contents = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			contents.expand = true;
			
			var thicknessSpinner = new Gtk.SpinButton.with_range(1, 100, 1);
			contents.add(new Gtk.Label("Thickness: "));
			contents.add(thicknessSpinner);
		}
		
		public override void click(Gtk.ToolButton button)
		{
			Active = true;
		
			var popover = new Granite.Widgets.PopOver();			
			var popcontent = popover.get_content_area() as Gtk.Container;
			popcontent.add(contents);
			popover.move_to_widget(button);
			popover.show_all();
			popover.present();
			popover.run();
			popcontent.remove(contents);
			popover.destroy();
		}*/
	}
}
