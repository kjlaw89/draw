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

namespace Draw
{
	public class ToolsPane : Gtk.Dialog
	{
		private Gtk.Widget Widget;
	
		construct 
		{
		    app_paintable = true;
		    resizable = false;
		    decorated = false;
		    set_position(Gtk.WindowPosition.NONE);
		    set_type_hint(Gdk.WindowTypeHint.MENU);
		    skip_pager_hint = true;
       		skip_taskbar_hint = true;
		}
	
		public ToolsPane(Gtk.Widget widget)
		{
			Widget = widget;
			//modal = true;
			set_role("popover");
			
			
			var content = get_content_area() as Gtk.Box;
			content.orientation = Gtk.Orientation.VERTICAL;
			content.valign = Gtk.Align.START;
			content.halign = Gtk.Align.START;
			content.hexpand = true;
			content.vexpand = true;
			content.width_request = 225;
			
			var toolsLabel = new Gtk.Label("Tools");
			toolsLabel.halign = Gtk.Align.START;
			content.add(toolsLabel);
			
			var toolsBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			content.add(toolsBox);
			
			var spacingBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			spacingBox.add(new Gtk.Label("t"));
			spacingBox.vexpand = true;
			content.add(spacingBox);
			
			var colorsLabel = new Gtk.Label("Colors");
			colorsLabel.halign = Gtk.Align.START;
			content.add(colorsLabel);
			
			var colorsBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			content.add(colorsBox);
			
			var brushesLabel = new Gtk.Label("Brushes");
			brushesLabel.halign = Gtk.Align.START;
			content.add(brushesLabel);
			
			var brushesBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			content.add(brushesBox);
		}
		
		public override bool map_event(Gdk.EventAny event)
		{
			var pointer = Gdk.Display.get_default ().get_device_manager ().get_client_pointer ();
			pointer.grab(get_window (), Gdk.GrabOwnership.NONE, true, Gdk.EventMask.SMOOTH_SCROLL_MASK | 
				Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | 
				Gdk.EventMask.ENTER_NOTIFY_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK | 
				Gdk.EventMask.POINTER_MOTION_MASK, null, Gdk.CURRENT_TIME);
			Gtk.device_grab_add(this, pointer, false);

			return false;
		}
	
		public override bool button_press_event(Gdk.EventButton event)
		{
			if (event_in_window(event))
				return true;
		
			return base.button_press_event(event);
		}
	
		public override bool button_release_event(Gdk.EventButton event)
		{
			if (event_in_window(event))
				return true;
		
			hide();
			return false;
		}
	
		bool event_in_window(Gdk.EventButton event)
		{
			int x, y, w, h;
			get_position (out x, out y);
			get_size (out w, out h);
		
			return event.x_root >= x && event.x_root <= x + w &&
				   event.y_root >= y && event.y_root <= y + h;
		}
		
		public override void hide()
		{
			var pointer = Gdk.Display.get_default().get_device_manager().get_client_pointer();
			Gtk.device_grab_remove(this, pointer);
			pointer.ungrab(Gdk.CURRENT_TIME);
		
			base.hide();
		}

		public override void show() {			
			int winX, winY;
			int widX, widY;
			Gdk.Rectangle geo;
			Gdk.Screen screen = Widget.get_screen();
			
			Widget.get_window().get_origin(out winX, out winY);
			Widget.translate_coordinates(Widget.get_toplevel(), 0, 0, out widX, out widY);
        	screen.get_monitor_geometry(screen.get_monitor_at_point (winX, winY), out geo);
        	
        	var content = get_content_area() as Gtk.Box;
        	content.height_request = Widget.get_allocated_height() + 28; 	// +28 covers the statusbar too
			move(geo.x + winX, geo.y + winY + widY);
			
			base.show();
		}
	}
}
