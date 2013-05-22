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
		public bool Modified { get; set; }

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

		private bool regenerate_thumbnail = true;
		private Gtk.Image thumbnail;
		private Granite.Drawing.BufferSurface buffer;
		private bool hasFocus;
		private double? lastX;
		private double? lastY;
		private uint buttonPress;
		private double zoomAmount = 1;

		/**
		 * Creates a new Canvas to draw on
		 * @param width Initial Width of Canvas
		 * @param height Initial Height of Canvas
		 */
		public Canvas(int width, int height, bool transparent = false)
		{
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
			add_events(Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | 
					   Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.ENTER_NOTIFY_MASK | 
					   Gdk.EventMask.LEAVE_NOTIFY_MASK | Gdk.EventMask.SCROLL_MASK | 
					   Gdk.EventMask.TOUCH_MASK);
			event.connect(handle_events);

			// Draw what is in our buffer
			draw.connect ((context) => {			
				context.scale(zoomAmount, zoomAmount);
				context.set_source_surface(buffer.surface, 0, 0);
				
				// If zooming in, do nearest neighbor zoom (so the canvas is pixelated correctly)
				if (zoomAmount > 1)
				{
					var resizePattern = context.get_source();
					resizePattern.set_filter(Cairo.Filter.NEAREST);
				}
								
				context.paint();
				return false;
			});
		}
		
		private new void queue_draw()
		{
			base.queue_draw();
			regenerate_thumbnail = true;
		}

		/**
		 * Loads a new canvas from the given Pixel Buffer
		 * @param image Pixbuf image to load
		 */
		public Canvas.load_from_pixbuf(Gdk.Pixbuf image)
		{
			this(image.width, image.height);

			Gdk.cairo_set_source_pixbuf(buffer.context, image, 0, 0);
			buffer.context.paint();
			queue_draw();
		}

		public Gdk.Pixbuf get_buffer()
		{
			return buffer.load_to_pixbuf();
		}

		/**
		 * Generates a thumbnail for use through the program (usually opened images or layers)
		 * @param width? Width of thumbnail 
		 * @param height? Height of thumbnail
		 * @note Width and height required to have specific dimensions, otherwise 65x65 is used
		 */
		public unowned Gtk.Image get_thumbnail(int? width = null, int? height = null)
		{
			if (thumbnail == null || regenerate_thumbnail || (width != null && height != null))
			{
				var thumb = new Gtk.Image();
				thumb.width_request = (width != null) ? (!) width : 65;
				thumb.height_request = (height != null) ? (!) height : 65;

				var thumb_buffer = get_buffer();
				if (thumb_buffer.width > thumb.width_request || thumb_buffer.height > thumb.height_request)
					thumb_buffer = thumb_buffer.scale_simple(thumb.width_request, thumb.height_request, Gdk.InterpType.BILINEAR);

				// Load buffer into thumbnail
				thumb.set_from_pixbuf(thumb_buffer);
				thumbnail = thumb;
				regenerate_thumbnail = false;
			}

			return thumbnail;
		}
		
		public void handle_paste(Gdk.Pixbuf pasteBuffer)
		{
			stdout.printf("Pasting image!\n");
			var context = buffer.context;
			Gdk.cairo_set_source_pixbuf(context, pasteBuffer, 0, 0);
			context.paint();
			base.queue_draw();
		}

		/**
		 * Handles all drawing events
		 * Note: This function will eventually be written to split out
		 * the input from the drawing aspect of the canvas - this is
		 * where the user input will be used to actually fill in the canvas
		 */
		private bool handle_events(Gdk.Event event)
		{
			Cairo.Context context = buffer.context;

			//context.move_to(0, 0);
			if (event.type == Gdk.EventType.BUTTON_PRESS)
			{
				buttonPress = event.button.button;
				lastX = (int)event.motion.x / zoomAmount;
				lastY = (int)event.motion.y / zoomAmount;
				context.rectangle(lastX, lastY, 1, 1);
				
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
				context.fill();
				hasFocus = true;
			}

			if (event.type == Gdk.EventType.BUTTON_RELEASE)
			{
				lastX = null;
				lastY = null;
				queue_draw();
				hasFocus = false;
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
				context.line_to(event.motion.x / zoomAmount, event.motion.y / zoomAmount);
				context.stroke();

				lastX = event.motion.x / zoomAmount;
				lastY = event.motion.y / zoomAmount;
				queue_draw();
			}

			return false;
		}

		/**
		 * Zooms the camera in (using the appropriate image resizing function to do so)
		 * @param zoomAmount Amount to zoom in by (% based)
		 */
		public void zoom(double zoomAmount)
		{
			this.zoomAmount = zoomAmount;
			Width = (int)(DefaultWidth * zoomAmount);
		    Height = (int)(DefaultHeight * zoomAmount);
		    
		    // Queue a base redraw (if we use the class redraw method we'll queue up a new
		    // a new thumbnail when we don't need it)
			base.queue_draw();
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
