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
			
			var colorTools = new Draw.ColorTools(Window);
			var drawTools = new Draw.DrawTools();
			var drawToolsOptions = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
			drawToolsOptions.expand = true;
			drawToolsOptions.halign = Gtk.Align.CENTER;
			drawToolsOptions.valign = Gtk.Align.CENTER;
			drawToolsOptions.add(new Gtk.Label("No options for this tool."));
			
			var buttonsBox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
			buttonsBox.add(adjustmentsButton);
			buttonsBox.add(effectsButton);
			
			var toolsBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			toolsBox.valign = Gtk.Align.CENTER;
			toolsBox.halign = Gtk.Align.CENTER;
			toolsBox.expand = true;
			toolsBox.add(drawTools);
			toolsBox.add(drawToolsOptions);
			
			// Add all items to the toolbar
			add_right(buttonsBox);
			add_right(colorTools);
			add_center(toolsBox);
		}
	}
}
