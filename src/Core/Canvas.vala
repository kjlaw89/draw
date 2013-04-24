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
		private int? lastX;
		private int? lastY;

		/**
		 * Creates a new Canvas to draw on
		 * @param width Initial Width of Canvas
		 * @param height Initial Height of Canvas
		 */
		public Canvas(int width, int height)
		{
			buffer = new Granite.Drawing.BufferSurface(width, height);
			width_request = Width = DefaultWidth = width;
			height_request = Height = DefaultHeight = height;

			// Create canvas and content area
			get_style_context().add_class("canvas");
			valign = Gtk.Align.CENTER;
			halign = Gtk.Align.CENTER;

			// Handle canvas events
			set_events(Gdk.EventMask.ALL_EVENTS_MASK);
			event.connect(handle_events);

			// Draw what is in our buffer
			draw.connect ((context) => {
				context.set_source_surface(buffer.surface, 0, 0);
				context.paint();
				return true;
			});
		}

		private bool handle_events(Gdk.Event event)
		{
			Cairo.Context context = buffer.context;
		
			//context.move_to(0, 0);
			if (event.type == Gdk.EventType.BUTTON_PRESS)
			{
				lastX = (int)event.motion.x;
				lastY = (int)event.motion.y;
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
				stdout.printf("X: %i, Y: %i\n", (int)event.motion.x, (int)event.motion.y);
				context.set_line_width(0.5);
				context.set_source_rgb(0, 0, 0);
				context.move_to((!) lastX, (!) lastY);
				context.line_to((int)event.motion.x, (int)event.motion.y);
				context.stroke();
				
				lastX = (int)event.motion.x;
				lastY = (int)event.motion.y;
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
