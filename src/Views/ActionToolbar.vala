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
	public class ActionToolbar : Draw.Toolbar
	{
		public Draw.Window Window { get; set; }
		private Gtk.Menu effectsMenu { get; set; }
		private Gtk.Menu adjustmentsMenu { get; set; }
		
		/**
		 * Intializes the main window's toolbar and
		 * establishes all of the events for the buttons
		 * @param window Main Application Window
		 */
		public ActionToolbar(Draw.Window window)
		{
			base("action-toolbar");
			Window = window;
			
			var colorTools = new Draw.ColorTools(Window);
			
			var toolsContainer = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
			toolsContainer.halign = Gtk.Align.CENTER;
			toolsContainer.expand = true;
			
			//var drawTools = new Draw.DrawTools(Window);
			//toolsContainer.add(drawTools);
			
			// Create all our draw tools
			var mouseTool = new Draw.Tool("/draw/images/mouse.png", "Move/Resize");
			var selectTool = new Draw.Tool("/draw/images/select.png", "Select");
			var magicTool = new Draw.Tool("/draw/images/magic_select.png", "Magic Select");
			var dropperTool = new Draw.Tool("/draw/images/dropper.png", "Dropper");
			var eraserTool = new Draw.Tool("/draw/images/eraser.png", "Eraser");
			var cloneTool = new Draw.Tool("/draw/images/clone_stamp.png", "Clone Stamp");
			var bucketTool = new Draw.Tool("/draw/images/bucket.png", "Bucket");
			var pencilTool = new Draw.Tool("/draw/images/pencil.png", "Pencil");
			var brushTool = new Draw.Tool("/draw/images/brush.png", "Brush");
			var shapesTool = new Draw.Tool("/draw/images/shapes.png", "Shapes");
			var linesTool = new Draw.Tool("/draw/images/lines.png", "Lines");
			var textTool = new Draw.Tool("/draw/images/text.png", "Text");
			
			// Create mode button
			var toolsModeButton = new Granite.Widgets.ModeButton();
			toolsModeButton.append_pixbuf(mouseTool.Pixbuf);
			toolsModeButton.append_pixbuf(selectTool.Pixbuf);
			toolsModeButton.append_pixbuf(magicTool.Pixbuf);
			toolsModeButton.append_pixbuf(dropperTool.Pixbuf);
			toolsModeButton.append_pixbuf(eraserTool.Pixbuf);
			toolsModeButton.append_pixbuf(cloneTool.Pixbuf);
			toolsModeButton.append_pixbuf(bucketTool.Pixbuf);
			toolsModeButton.append_pixbuf(pencilTool.Pixbuf);
			toolsModeButton.append_pixbuf(brushTool.Pixbuf);
			toolsModeButton.append_pixbuf(shapesTool.Pixbuf);
			toolsModeButton.append_pixbuf(linesTool.Pixbuf);
			toolsModeButton.append_pixbuf(textTool.Pixbuf);
			toolsContainer.add(toolsModeButton);
			
			// Add all items to the toolbar
			add_center(toolsContainer);
			add_right(colorTools);
		}
	
		/*private not_in_use()
		{
			// Build the effects menu
			effectsMenu = new Gtk.Menu();
			
			// Blurs sub-menu
			var blursItem = new Gtk.MenuItem.with_label("Blurs");
			var blursMenu = new Gtk.Menu();
			var gaussianItem = new Gtk.MenuItem.with_label("Gaussian Blur...");
			var motionItem = new Gtk.MenuItem.with_label("Motion Blur...");
			var radialItem = new Gtk.MenuItem.with_label("Radial Blur...");
			var unfocusItem = new Gtk.MenuItem.with_label("Unfocus Blur...");
			blursMenu.add(gaussianItem);
			blursMenu.add(motionItem);
			blursMenu.add(radialItem);
			blursMenu.add(unfocusItem);
			
			// Set submenu and show
			blursItem.set_submenu(blursMenu);
			blursItem.show_all();
			
			// Add all sub-menus to the effects menu
			effectsMenu.add(blursItem);
			//effectsButton.set_menu(effectsMenu);
			
			var effectsImage = new Gtk.Image.from_file("images/effects.png");
			var effectsButton = new Granite.Widgets.ToolButtonWithMenu(effectsImage, "", effectsMenu);
			effectsButton.get_style_context().add_class("image-tools");
			
			// Build the effects menu
			adjustmentsMenu = new Gtk.Menu();
			
			// Blurs sub-menu
			var autolevelItem = new Gtk.MenuItem.with_label("Auto Level");
			var bawItem = new Gtk.MenuItem.with_label("Black and White");
			var bacItem = new Gtk.MenuItem.with_label("Brightness / Contrast...");
			var curvesItem = new Gtk.MenuItem.with_label("Curves...");
			adjustmentsMenu.add(autolevelItem);
			adjustmentsMenu.add(bawItem);
			adjustmentsMenu.add(bacItem);
			adjustmentsMenu.add(curvesItem);
			adjustmentsMenu.show_all();
			
			var adjustmentsImage = new Gtk.Image.from_file("images/adjustments.png");
			adjustmentsImage.icon_size = Gtk.IconSize.LARGE_TOOLBAR;
			
			var adjustmentsButton = new Granite.Widgets.ToolButtonWithMenu(adjustmentsImage, "", adjustmentsMenu);
			adjustmentsButton.get_style_context().add_class("image-tools");
			
			// Add all sub-menus to the effects menu
			//adjustmentsButton.set_menu(adjustmentsMenu);
			var buttonsBox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
			buttonsBox.add(adjustmentsButton);
			buttonsBox.add(effectsButton);
			//add_right(buttonsBox);
		}*/
	}
}
