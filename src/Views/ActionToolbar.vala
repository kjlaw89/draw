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
			var effectsButton = new Gtk.MenuToolButton(null, "Effects");
			effectsButton.get_style_context().add_class("effects-menu");
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
			effectsButton.set_menu(effectsMenu);
			
			var effectsContainer = new Gtk.Frame(null);
			effectsContainer.get_style_context().add_class("button-menu");
			effectsContainer.add(effectsButton);
			
			// Build the effects menu
			var adjustmentsButton = new Gtk.MenuToolButton(null, "Adjustments");
			adjustmentsButton.get_style_context().add_class("adjustments-menu");
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
			
			// Add all sub-menus to the effects menu
			adjustmentsButton.set_menu(adjustmentsMenu);
			
			var adjustmentsContainer = new Gtk.Frame(null);
			adjustmentsContainer.get_style_context().add_class("button-menu");
			adjustmentsContainer.add(adjustmentsButton);
			
			// Add all items to the toolbar
			add_left(new Draw.DrawTools());
			add_left(new Draw.ColorTools());
			add_right(adjustmentsContainer);
			add_right(effectsContainer);
		}
	}
}
