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
using Granite.Drawing;

namespace Draw
{
	public class ColorTools : Gtk.Box
	{
		private Gtk.Fixed chosenContainer;
		private Draw.Tools paletteTools;
		private ArrayList<Palette> palettes = new ArrayList<Palette>(); // ToDO: Pull this out eventually, ColorTools does not need to reference it itself
		private Palette activePalette;
		
		/**
		 * Returns the active palette
		 * If modified it will recreate the colors 
		 * palette with the given palette
		 */
		public Palette Palette
		{
			get { return activePalette; }
			set
			{
				activePalette = value;
				paletteTools.clear();
				
				// Load our colors from the palette in
				for (var i = 0; i < 3; i++)
				{
					for (var ii = 0; ii < 16; ii++)
					{
						var color = activePalette.Colors[(i * 16) + ii];
						var button = new Gtk.Button();
						button.set_image(new ColorIcon(color, 12, 12));
						button.set_events(Gdk.EventMask.ALL_EVENTS_MASK);
						button.event.connect(color_clicked);
						
						paletteTools.add_button(button, i, true);
					}
				}
			}
		}
		
		private ColorIcon primaryColor;
		public Granite.Drawing.Color PrimaryColor
		{
			get { return primaryColor.Color; }
			set
			{
				primaryColor.Color = value;
			}
		}
		
		private ColorIcon secondaryColor;
		public Granite.Drawing.Color SecondaryColor
		{
			get { return secondaryColor.Color; }
			set
			{
				secondaryColor.Color = value;
			}
		}
		
		public Draw.Window Window { get; private set; }
	
		public ColorTools(Draw.Window window)
		{
			Window = window;
			paletteTools = new Draw.Tools("color-palette", 5, 10, 0);
			paletteTools.valign = Gtk.Align.CENTER;
			
			palettes = Draw.Palette.load_palettes();
			Palette = palettes[0];
			
			chosenContainer = new Fixed();
			primaryColor = new ColorIcon(new Color(0, 0, 0, 1), 18, 18);
			secondaryColor = new ColorIcon(new Color(1, 1, 1, 1), 18, 18);
			
			var primaryFrame = new Gtk.Frame(null);
			primaryFrame.get_style_context().add_class("primary-color");
			primaryFrame.add(primaryColor);
			
			var secondaryFrame = new Gtk.Frame(null);
			secondaryFrame.get_style_context().add_class("secondary-color");
			secondaryFrame.add(secondaryColor);
			
			chosenContainer.width_request = 50;
			chosenContainer.put(secondaryFrame, 18, 12);  // Secondary color first so primary overlaps it
			chosenContainer.put(primaryFrame, 6, 2);
			
			var label = new Gtk.Label("Colors...");
			chosenContainer.put(label, 2, 36);
			
			var button = new Gtk.ToolButton(chosenContainer, null);
			
			valign = Gtk.Align.CENTER;
			add(paletteTools);
			add(button);
		}
		
		private bool color_clicked(Gtk.Widget widget, Gdk.Event event)
		{
			var color = ((widget as Gtk.Button).get_image() as Draw.ColorIcon).Color;
			if (event.type == Gdk.EventType.BUTTON_PRESS)
			{
				switch (event.button.button)
				{
					case 1:
						PrimaryColor = color;
						break;
					case 2:
						break;
					case 3:
						SecondaryColor = color;
						break;
				}
				
				Window.Canvas.PrimaryColor = PrimaryColor;
				Window.Canvas.SecondaryColor = SecondaryColor;
			}
			
			return true;
		}
	}
}
