using Granite;
using Granite.Widgets;

namespace Draw
{
	// Window creation class - handles creating the window
	// with an integrated toolbar and square style
	public class AppWindow : Gtk.Window
	{
			Gtk.Box container;
			Gtk.Toolbar toolbar;
			Gtk.ToolItem label;
	 
			const int HEIGHT = 48;
			const int ICON_SIZE = Gtk.IconSize.LARGE_TOOLBAR;
	 
			Gtk.Label _title;
			public new string title 
			{
				get { return _title.label; }
		        set { _title.label = value; }
			}
			
			public bool maximized
			{
				get;
				private set;
			}
	 
			public AppWindow ()
			{
				this.delete_event.connect (() => {
				    Gtk.main_quit ();
				    return false;
				});
        
		        toolbar = new Gtk.Toolbar ();
		        toolbar.icon_size = ICON_SIZE;
		        container = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		        container.pack_start (toolbar, false);
		        container.vexpand = true;
		        container.hexpand = true;
 
		        var close = new Gtk.ToolButton (new Gtk.Image.from_file ("/usr/share/themes/elementary/metacity-1/close.svg"), "Close");
		        close.height_request = HEIGHT;
		        close.width_request = HEIGHT;
		        close.clicked.connect (() => destroy());
 
		        var maximize = new Gtk.ToolButton (new Gtk.Image.from_file ("/usr/share/themes/elementary/metacity-1/maximize.svg"), "Close");
		        maximize.height_request = HEIGHT;
		        maximize.width_request = HEIGHT;
		        maximize.clicked.connect (() => 
		        { 
		        	if (!maximized)
		        	{
		        		get_window ().maximize();
		        		maximized = true;
		        	}
		        	else
		    		{
		    			get_window().unmaximize();
		    			maximized = false;
		    		}
		        });
 
		        _title = new Gtk.Label ("");
		        _title.override_font (Pango.FontDescription.from_string ("bold"));
		        label = new Gtk.ToolItem ();
		        label.add (_title);
		        label.set_expand (true);
		        label.get_style_context ().add_class ("title");
 
		        toolbar.insert (close, -1);
		        toolbar.insert (create_separator (), -1);
		        toolbar.insert (label, -1);
		        toolbar.insert (create_separator (), -1);
		        toolbar.insert (maximize, -1);
 
		        base.add (container);
			}
	 
			public Gtk.ToolItem create_separator ()
			{
			        var sep = new Gtk.ToolItem ();
			        sep.height_request = HEIGHT;
			        sep.width_request = 1;
			        sep.draw.connect ((cr) => {
			                cr.move_to (0, 0);
			                cr.line_to (0, 60);
			                cr.set_line_width (1);
			                var grad = new Cairo.Pattern.linear (0, 0, 0, HEIGHT);
			                grad.add_color_stop_rgba (0, 0.3, 0.3, 0.3, 0.4);
			                grad.add_color_stop_rgba (0.8, 0, 0, 0, 0);
			                cr.set_source (grad);
			                cr.stroke ();
			                return true;
			        });
			        sep.get_style_context ().add_class ("sep");
	 
			        return sep;
			}
	 
			public override void add (Gtk.Widget widget)
			{
			        container.pack_start (widget);
			}
			public override void remove (Gtk.Widget widget)
			{
			        container.remove (widget);
			}
			public override void show ()
			{
			        base.show ();
			        get_window ().set_decorations (Gdk.WMDecoration.BORDER);
			}
			public void append_toolitem (Gtk.ToolItem item, bool after_title = false)
			{
			        toolbar.insert (item, after_title ? toolbar.get_n_items () - 2 : toolbar.get_item_index (label));
			}
	}
}
