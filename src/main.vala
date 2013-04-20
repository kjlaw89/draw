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
    Original Author: Victor Eduardo <victoreduardm@gmail.com>
***/

using Gtk;
using Granite;
using Granite.Widgets;
using GLib;

// Next we define our own namespace to hold our application.
namespace Draw {
    
    // Here we create our main application class. We derive from Granite.Application because it includes
    // many helper functions for us. It also includes a Granite window which is based off of the 
    // Elementary Human Interface Guildlines. You'll see in the future how much it helps us.
    public class Application : Granite.Application 
    {
        
        // Before we get into the constructor functions. We need to define any classwide variables.
        // Here we're going to define the MainWindow variable. We'll be assigning the GTK Window to this.
        public Window w;
        
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
        public Application() {}
        

        // This is our function to "activate" the GTK App. Here is where we define our startup functions.
        // Splash Screen? Initial Plugin Loading? Initial Window building? All of that goes here.
        public override void activate ()
        {
            Window w = new Window(this);
            w.Title = "Draw";
            w.set_application(this);
			w.set_default_size(980, 720);
            w.show_all();
        }
    }
}

public static int main(string[] args){
    Gtk.init(ref args);
    var draw_app = new Draw.Application();
    return draw_app.run(args);
}
