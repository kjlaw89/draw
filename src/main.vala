// Vala uses a syntax similar to C#. Anything that's in a namespace can be included by doing "using _NAMESPACE_";
// We include GTK here because we want to build a Hello World Window.
using Gtk;
using Granite;
using Granite.Widgets;
using GLib;

// Next we define our own namespace to hold our application.
namespace Draw {
    
    // Here we create our main application class. We derive from Granite.Application because it includes
    // many helper functions for us. It also includes a Granite window which is based off of the 
    // Elementary Human Interface Guildlines. You'll see in the future how much it helps us.
    public class Draw : Granite.Application 
    {
        
        // Before we get into the constructor functions. We need to define any classwide variables.
        // Here we're going to define the MainWindow variable. We'll be assigning the GTK Window to this.
        public AppWindow w;
        
        private const string CSS = """  """;


        // Here we create the construct function for our class. Vala uses "construct" as a constructor
        // function. In this construct we define many variable that are needed for granite.
        // As time goes on we'll show that granite will take these variables and construct an about
        // dialog just for us.
        construct 
        {
            // Your Program's Name
            program_name        = "Draw";

            // The Executable name for your program.
            exec_name           = "Draw";
            
            // The years your application is copyright.
            app_years           = "2013";

            // The icon your application uses.
            // This icon is usually stored within the "/usr/share/icons/elementary" path.
            // Put your icon in each of the respected resolution folders to enable it's use.
            app_icon            = "application-default-icon";

            // This defines the name of our desktop file. This file is used by launchers, docks,
            // and desktop environments to display an icon. We'll cover this later.
            app_launcher        = "draw.desktop";

            // This is a unique ID to your application. A traditional way is to do
            // com/net/org (dot) your companies name (dot) your applications name
            // For here we have "Organization.Elementary.GraniteHello"
            application_id      = "org.elementary.draw";
            

            // These are very straight forward.
            // main_url = The URL linking to your website.
            main_url            = "http://elementaryos.org";

            // bug_url = The URL Linking to your bug tracker.
            bug_url             = "http://elementaryos.org";

            // help_url = The URL to your helpfiles.
            help_url            = "http://elementaryos.org";

            // translate_url = the URL to your translation documents.
            translate_url       = "http://elementaryos.org";

            // These are straight forward. Just like above.
          	about_authors       = {"KJ Lawrence <kj@nsfugames.com>"};
            /*about_documenters   = {"Your Guy <YourGuy@gmail.com>"};
            about_artists       = {"Your Girl <YourGirl@gmail.com>"};
            about_comments      = {"Your Guy <YourGuy@gmail.com>"};
            about_translators   = {"Bob The Translator <Bob@gmail.com>"};*/

            // What license type is this app under? I prefer MIT but theres 
            // also License.GPL_2_0 and License.GPL_3_0
            about_license_type  = License.GPL_3_0;
        }
        
        // This is another constructor. We can put GTK Overrides here...
        public Draw() {}
        

        // This is our function to "activate" the GTK App. Here is where we define our startup functions.
        // Splash Screen? Initial Plugin Loading? Initial Window building? All of that goes here.
        public override void activate ()
        {
        	bool first_run = true;
            AppWindow w = new AppWindow ();
            w.title = "Draw";
            w.set_application(this);
			w.set_default_size(980, 720);
            w.window_position = Gtk.WindowPosition.CENTER;
			w.destroy.connect (Gtk.main_quit);
			
			// Don't allow the window to be sized smaller than a certain amount
			// Commented out until I can research why it resizes to a small size in the beginning
			/*w.configure_event.connect(() => 
			{
				if (w.width_request < 630)
					w.width_request = 630;
				
				if (w.height_request < 460)
					w.height_request = 460;
					
				w.resize(w.width_request, w.height_request);
				return false;
			});*/
			
			var css = new Gtk.CssProvider();
			css.load_from_file(File.new_for_path("./draw.css"));
			Gtk.StyleContext.add_provider_for_screen(w.screen, css, Gtk.STYLE_PROVIDER_PRIORITY_THEME);
			
			// App Menu (this gives access to the About dialog)
        	Gtk.Menu settings = new Gtk.Menu ();
        	Gtk.MenuItem about_item = new Gtk.MenuItem.with_label("About");
        	about_item.activate.connect(() => { show_about(w); });
        	
        	// Add our settings items to our menu
        	settings.add(about_item);
        	
		    // Create the widgets for the status bar
		    var zoom_widget = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 25, 800, 25);
		    zoom_widget.get_style_context().add_class("zoom-widget");
		    zoom_widget.tooltip_text = "Zoom";
		    zoom_widget.width_request = 150;
		    zoom_widget.value_pos = Gtk.PositionType.LEFT;
		    zoom_widget.set_value(100);
		    
		    // Hack way of getting the slider to lock to 25-increments
		    zoom_widget.value_changed.connect(() =>
		    {
		    	double zValue = zoom_widget.get_value();
		    	double newValue = Math.round((zValue / 25.0)) * 25.0;
		    	zoom_widget.set_value(newValue);
		    });
		    
		    // Application Statusbar (used for image zooming, canvas size details, mouse position and general stats)
		    var statusbar = new AppToolbar("status-toolbar", null);
		    statusbar.insert_widget(zoom_widget, ToolbarPosition.RIGHT);
		    
		    var content = new Gtk.ScrolledWindow(null, null);
		    content.get_style_context().add_class("container");
		    content.expand = true;
		    
		    // Main toolbar
		    var main_toolbar = new AppToolbar("primary-toolbar", null);
		    main_toolbar.height_request = 55;
        	
        	 // Main widget structure
			Gtk.Grid layout = new Gtk.Grid ();
			layout.expand = true;
			layout.orientation = Gtk.Orientation.VERTICAL;
			layout.add(main_toolbar);
			layout.add(content);
			layout.add(statusbar);
	 
			w.add(layout);
			w.append_toolitem (new Gtk.ToolButton.from_stock (Gtk.Stock.NEW));
			w.append_toolitem (new Gtk.ToolButton.from_stock (Gtk.Stock.OPEN));
			w.append_toolitem (new Gtk.ToolButton.from_stock (Gtk.Stock.SAVE));
			w.append_toolitem (w.create_separator ());
			w.append_toolitem (w.create_separator (), true);
			w.append_toolitem (new Gtk.ToolButton.from_stock (Gtk.Stock.PRINT), true);
			w.append_toolitem (new Gtk.ToolButton (new Gtk.Image.from_icon_name ("document-export", Gtk.IconSize.LARGE_TOOLBAR), ""), true);
			w.append_toolitem (new Granite.Widgets.ToolButtonWithMenu (new Gtk.Image.from_icon_name ("application-menu", Gtk.IconSize.LARGE_TOOLBAR), "", settings), true);
			w.show_all();
        }
    }
}



// Now that our application and window are defined, we have to call them through the main loop.
// We do this by starting with a main function. You could theoretically include all the code above
// in a main function. However it doesn't make for clean code and you wont be able to take part
// in all of granite's cool features.

// All main loop functions should start as an int. You can do self-checks within the app and 
// return 0 to force the app to close in the event of an issue.
public static int main(string[] args){

    // We need to tell GTK To start. Even though we've written all the code above. None of it
    // is started yet. So we need to start GTK then run our code.
    Gtk.init(ref args);

    // Lets assign our Application Class and Namespace to a variable. You always call it by
    // var VarName = new NameSpace.Class();
    // The Classname and Namespace Name do not have to be identical. They can be different.
    var draw_app = new Draw.Draw();

    // Now remember how this is an Int? Instead of returning a number we're going to return our window.
    return draw_app.run(args);
}
