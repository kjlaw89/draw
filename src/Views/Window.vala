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
    Original Author: Tom Beckmann <tom@elementaryos.org>
***/

using Granite;
using Granite.Widgets;
using Gee;

namespace Draw
{
	/**
	 * Application Window for Draw
	 * Initializes a window with an integrated toolbar
	 *
	 * This class will facilitate communications between all
	 * of the individual elements in the program through various
	 * methods and exposure of elements when necessary.
	 *
	 * Structure:
	 *	<Gtk.Window>
	 *		<Draw.Toolbar name="WindowToolbar" />
	 *		<Draw.Toolbar name="ActionToolbar">
	 *			<Gtk.Button name="ColorChooser" />
	 *			<Draw.Tools name="ColorPalette" />
	 *			<Draw.Tools name="ActionTools" />
	 *		</Draw.Toolbar>
	 *		<Draw.CanvasContainer>
	 *			<Gtk.Viewport>
	 *				<Gtk.Frame name="activeCanvas">
	 *					<Draw.Canvas />
	 *				</Gtk.Frame>
	 *			</Gtk.Viewport>
	 *		</Draw.CanvasContainer>
	 *		<Draw.Toolbar name="StatusToolbar" />
	 *	</Gtk.Window>
	 */
	public class Window : Gtk.Window
	{
		private Gtk.Grid Content;
		private ArrayList<Draw.Canvas> images = new ArrayList<Draw.Canvas>();

		public Granite.Application Application { get; set; }
		public Draw.WindowToolbar WindowToolbar { get; set; }
		public Draw.ActionToolbar ActionToolbar { get; set; }
		public Draw.StatusToolbar StatusToolbar { get; set; }
		public Draw.CanvasContainer CanvasContainer { get; set; }
		public Draw.Canvas Canvas { get; set; }

		public bool Maximized { get; set; }

        /**
         * Gets/Sets the title for the Window
         */
		public new string Title
		{
			get { return WindowToolbar.Title; }
			set { WindowToolbar.Title = value; }
		}

		/**
		 * Gets the count for images open in the images button
		 */
		public int OpenCount {	get { return images.size; } }

		/**
		 * Returns a hashmap of loaded images and their thumbnails
		 */
		public ArrayList<Draw.Canvas> Images { get { return images; } }

 		/**
 		 * Initializes the main window for the application
 		 */
		public Window(Granite.Application application)
		{
			Application = application;
			window_position = Gtk.WindowPosition.CENTER;
			delete_event.connect (() => exit());

		    // Try to load in and apply the CSS to the application
		    try
			{
				var css = new Gtk.CssProvider();
				css.load_from_file(File.new_for_path("./draw.css"));
				Gtk.StyleContext.add_provider_for_screen(screen, css, Gtk.STYLE_PROVIDER_PRIORITY_THEME);
			}
			catch (Error ex) { /* throw alert eventually */ }

			// Create Window toolbar
			WindowToolbar = new Draw.WindowToolbar(this);

			// Create Action toolbar
			ActionToolbar = new Draw.ActionToolbar(this);
			ActionToolbar.height_request = 55;

			// Create canvas
			CanvasContainer = new Draw.CanvasContainer(this);
			Canvas = CanvasContainer.Canvas;
			add_image(new Draw.Canvas(640, 480), true);

			// Create Status toolbar
			StatusToolbar = new Draw.StatusToolbar(this);

			// Create a layout and push everything into it
			Content = new Gtk.Grid ();
			Content.expand = true;
			Content.orientation = Gtk.Orientation.VERTICAL;
			Content.add(ActionToolbar);
			Content.add(CanvasContainer);
			Content.add(StatusToolbar);

			// Container for the Window contents
			var Container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		    Container.vexpand = true;
		    Container.hexpand = true;

		    // Add all elements to the container than the container to the window
		    Container.pack_start(WindowToolbar, false);
		    Container.pack_start(Content);
			base.add(Container);
		}

		/**
		 * Terminates the program
		 */
		public bool exit()
		{
			Gtk.main_quit();
			return false;
		}

		public override void show ()
		{
			base.show ();
			get_window().set_decorations(Gdk.WMDecoration.BORDER);
		}

		/**
		 * Wrapper for the Window Toolbar to update badge count
		 * @param imagesCount Amount of images opened
		 */
		public void update_images_count(int imagesCount)
		{
			WindowToolbar.update_open_count(imagesCount);
		}

		/**
		 * Loads an image into the application and
		 * creates a starting thumbnail for it (for
		 * use in the image chooser popover)
		 * @param canvas
		 */
		public void add_image(Draw.Canvas image, bool show)
		{
			if (!images.contains(image))
				images.add(image);

			if (show)
				CanvasContainer.Canvas = image;
		}
	}
}
