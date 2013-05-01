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

using Granite;
using Granite.Widgets;

namespace Draw
{
	/**
	 * Canvas for drawing
	 */
	public class Canvas : Gtk.DrawingArea
	{
		public Granite.Drawing.Color PrimaryColor { get; set; }
		public Granite.Drawing.Color SecondaryColor { get; set; }
		public int DefaultWidth { get; private set; }
		public int DefaultHeight { get; private set; }

		public int Width
		{
			get { return width_request; }
			set { width_request = value; }
		}

		public int Height
		{
			get { return height_request; }
			set { height_request = value; }
		}

		private Granite.Drawing.BufferSurface buffer;
		private bool hasFocus;
		private double? lastX;
		private double? lastY;
		private uint buttonPress;

		/**
		 * Creates a new Canvas to draw on
		 * @param width Initial Width of Canvas
		 * @param height Initial Height of Canvas
		 */
		public Canvas(int width, int height)
		{
			stdout.printf("%d, %d\n", width, height);
			buffer = new Granite.Drawing.BufferSurface(width, height);
			width_request = Width = DefaultWidth = width;
			height_request = Height = DefaultHeight = height;

			// Create canvas and content area
			get_style_context().add_class("canvas");
			valign = Gtk.Align.CENTER;
			halign = Gtk.Align.CENTER;

			// Set default colors
			PrimaryColor = new Granite.Drawing.Color(0, 0, 0, 1);
			SecondaryColor = new Granite.Drawing.Color(1, 1, 1, 1);
			
			// Handle canvas events
			set_events(Gdk.EventMask.ALL_EVENTS_MASK);
			event.connect(handle_events);

			// Draw what is in our buffer
			draw.connect ((context) => {
				stdout.printf("Drawing\n");
				context.set_source_surface(buffer.surface, 0, 0);
				context.paint();
				return true;
			});
		}
		
		/**
		 * Loads a new canvas from the given Pixel Buffer
		 * @param image Pixbuf image to load
		 */
		public Canvas.load_from_pixbuf(Gdk.Pixbuf image)
		{
			this(image.width, image.height);
			stdout.printf("Done initializing...\n");
			
			Gdk.cairo_set_source_pixbuf(buffer.context, image, 0, 0);
			buffer.context.paint();
			queue_draw();
		}

		private bool handle_events(Gdk.Event event)
		{
			Cairo.Context context = buffer.context;
		
			//context.move_to(0, 0);
			if (event.type == Gdk.EventType.BUTTON_PRESS)
			{
				buttonPress = event.button.button;
				lastX = (int)event.motion.x;
				lastY = (int)event.motion.y;
				context.rectangle(lastX, lastY, 1, 1);
				context.set_source_rgb(0, 0, 0);
				context.fill();
				hasFocus = true;
				return true;
			}

			if (event.type == Gdk.EventType.BUTTON_RELEASE)
			{
				lastX = null;
				lastY = null;
				queue_draw();
				hasFocus = false;
				return true;
			}

			if (hasFocus && event.type == Gdk.EventType.MOTION_NOTIFY)
			{
				context.set_antialias(Cairo.Antialias.SUBPIXEL);
				context.set_line_width(1);
				
				switch (buttonPress)
				{
					case 1:
					case 2:
						context.set_source_rgba(PrimaryColor.R, PrimaryColor.G, PrimaryColor.B, PrimaryColor.A);
						break;
					case 3:
						context.set_source_rgba(SecondaryColor.R, SecondaryColor.G, SecondaryColor.B, SecondaryColor.A);
						break;
				}
				
				context.move_to((!) lastX, (!) lastY);
				context.line_to(event.motion.x, event.motion.y);
				context.stroke();
				
				lastX = event.motion.x;
				lastY = event.motion.y;
				queue_draw();
			}

			return true;
		}

		/**
		 * Zooms the camera in (using the appropriate image resizing function to do so)
		 * @param width Width to zoom in to
		 * @param height Height to zoom in to
		 */
		public void canvas_zoom(int width, int height)
		{
			Width = width;
		    Height = height;

		    // ToDO: Perform some image resizing function since we'll be zooming in or out

		    // Extra logging (should be able to be removed eventually
		    stdout.printf("Canvas Resized to (%s, %s)\n", width.to_string(), height.to_string());
		}

		/**
		 * Stub method for future use, affects both
		 * Width/Height properties and Default Width/Height
		 * properties
		 */
		public void canvas_resize(int width, int height, ResizeDirection direction)
		{
		}

		public enum ResizeDirection
		{
			TOP_LEFT,
			TOP_CENTER,
			TOP_RIGHT,
			MIDDLE_LEFT,
			MIDDLE_CENTER,
			MIDDLE_RIGHT,
			BOTTOM_LEFT,
			BOTTOM_CENTER,
			BOTTOM_RIGHT
		}
	}
}