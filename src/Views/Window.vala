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
		private ArrayList<Draw.Image> images = new ArrayList<Draw.Image>();
		private Draw.Image activeImage;
		private Gtk.Grid content;
		private Gtk.Box container;
		

		public Granite.Application Application { get; private set; }
		public Draw.Welcome WelcomeView { get; private set; }
		public Draw.NewImage NewImageView { get; private set; }
		public Draw.WindowToolbar WindowToolbar { get; private set; }
		public Draw.ActionToolbar ActionToolbar { get; private set; }
		public Draw.StatusToolbar StatusToolbar { get; private set; }
		public Draw.CanvasContainer CanvasContainer { get; private set; }
		public bool Maximized { get; set; }
		public Draw.Canvas Canvas { get; set; }

        /**
         * Gets/Sets the title for the Window
         */
		public new string Title
		{
			get { return WindowToolbar.Title; }
			set { WindowToolbar.Title = value; }
		}		
		
		/**
		 * Gets/Sets the working image
		 */
		public Draw.Image ActiveImage 
		{ 
			get { return activeImage; } 
			set
			{
				activeImage = value;
				CanvasContainer.Canvas = value.Canvas;
				
				if (value.Name != null)
					Title = value.Name + ((value.Modified) ? "*" : "");
				else
					Title = "Untitled*";
			}
		}
		
		public int OpenCount {	get { return images.size; } }
		public ArrayList<Draw.Image> Images { get { return images; } }

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

			// Create Welcome and File views
			WelcomeView = new Draw.Welcome(this);
			NewImageView = new Draw.NewImage(this);

			// Create Window toolbar
			WindowToolbar = new Draw.WindowToolbar(this);

			// Create Action toolbar
			ActionToolbar = new Draw.ActionToolbar(this);
			ActionToolbar.height_request = 55;

			// Create our Canvas Container
			CanvasContainer = new Draw.CanvasContainer(this);

			// Create Status toolbar
			StatusToolbar = new Draw.StatusToolbar(this);

			// Create a layout and push everything into it
			content = new Gtk.Grid();
			content.expand = true;
			content.orientation = Gtk.Orientation.VERTICAL;
			content.add(ActionToolbar);
			content.add(CanvasContainer);
			content.add(StatusToolbar);
			content.show_all();

			// Container for the Window contents
			container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		    container.expand = true;
		    container.pack_start(WindowToolbar, false);
		    
		    show_welcome();
			base.add(container);
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
		public void add_image(Draw.Image image, bool show = false)
		{
			images.add(image);

			if (show)
				ActiveImage = image;
		}
		
		/**
		 * Saves the currently active image
		 */
		public bool save_image()
		{
			return ActiveImage.save();
		}
		
		/**
		 * Saves the currently active image as something else
		 */
		public bool save_image_as()
		{
			return ActiveImage.save_as(this);
		}
		
		/**
		 * Shows the welcome screen (on load or if all images are closed)
		 * This may never be used if the preferences setting to show welcome screen is turned off
		 */
		public void show_welcome()
		{
			foreach(var child in container.get_children())
			{
				if (child == WindowToolbar)
					continue;
					
				container.remove(child);
			}
				
			container.pack_start(WelcomeView);
		}
		
		/**
		 * Shows the new image screen
		 */
		public void show_new()
		{
			foreach(var child in container.get_children())
			{
				if (child == WindowToolbar)
					continue;
					
				container.remove(child);
			}

			container.pack_start(NewImageView);
		}
		
		/**
		 * Shows all of the toolbars and the canvas
		 */
		public void show_content()
		{			
			foreach(var child in container.get_children())
			{
				if (child == WindowToolbar)
					continue;
					
				container.remove(child);
			}
			
			container.pack_start(content);
		}
	}
}
