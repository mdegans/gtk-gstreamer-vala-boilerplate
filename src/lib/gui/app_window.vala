/*
 * app_window.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

[GtkTemplate (ui = "/layouts/app_window.ui")]
public class AppWindow : Gtk.ApplicationWindow {
  /** reveals the left sidebar */
  [GtkChild]
  public Gtk.Revealer sidebar_l;

  /** reveals the right sidebar */
  [GtkChild]
  public Gtk.Revealer sidebar_r;

  /** reveals the bottom bar when the mouse is close */
  [GtkChild]
  public Gtk.Revealer bottom_revealer;

  /** drawing area for the video overlay */
  [GtkChild]
  public Gtk.DrawingArea video_area;

  /** left set of buttons (sources, ...) */
  [GtkChild]
  public Gtk.ButtonBox left_buttons;

  /** right set of buttons (fullscreen, preferences, ...) */
  [GtkChild]
  public Gtk.ButtonBox right_buttons;

  /** we add source appropriate controls to this box at runtime */
  [GtkChild]
  public Gtk.Box control_box;

  /** toggles the sources revealer */
  [GtkChild]
  public Gtk.ToggleButton btn_sources;

  /** toggles fullscreen */
  [GtkChild]
  public Gtk.ToggleButton btn_fullscreen;

  /** toggles the preferences revealer */
  [GtkChild]
  public Gtk.ToggleButton btn_preferences;

  bool is_fullscreen = false;
  Gst.State state = Gst.State.NULL;

  construct {
    var pipe = new Ggvb.Pipeline();

    // setup fullscreen button
    window_state_event.connect((state) => {
        // cache the fullscreen state
        is_fullscreen = (bool)(state.new_window_state & Gdk.WindowState.FULLSCREEN);
    });
    btn_fullscreen.toggled.connect((btn) => {
      if (is_fullscreen) {
        unfullscreen();
      } else {
        fullscreen();
      }
    });

    sidebar_r.add(new Histogram());

    // setup revealer buttons
    btn_sources.toggled.connect(() => {
      sidebar_l.set_reveal_child(btn_sources.get_active());
    });
    btn_preferences.toggled.connect(() => {
      sidebar_r.set_reveal_child(btn_preferences.get_active());
    });

    // connect bus message callback
    var maybe_bus = pipe.get_bus();
    assert(maybe_bus is Gst.Bus);
    var bus = (!)maybe_bus;
    bus.add_watch(Priority.DEFAULT, on_bus_message);

    // set video overlay window id when overlay area is realized
    video_area.realize.connect(() => {
      var maybe_area_win = video_area.get_window() as Gdk.X11.Window;
      if (maybe_area_win != null) {
          var area_win = (!)maybe_area_win;
          pipe.get_overlay().set_window_handle((uint*)area_win.get_xid());
      } else {
          error("could not get DrawingArea window as Gdk.X11.Window");
      }
    });

    // If the pipeline is less than the paused state, we need to draw
    // a black box over the drawing area using the Cairo.Context, or it
    // doesn't redraw and we get trails and junk.
    video_area.draw.connect((ctx) => {
        if (state < Gst.State.PAUSED) {
            Gtk.Allocation allocation;
            video_area.get_allocation(out allocation);
            ctx.set_source_rgb(0,0,0);
            ctx.rectangle(0,0,allocation.width, allocation.height);
            ctx.fill();
        }
    });

    // cleanup pipeline when widget is destroyed
    destroy.connect(() => {
        Gst.Debug.BIN_TO_DOT_FILE((!)(pipe as Gst.Bin),
                                  Gst.DebugGraphDetails.ALL,
                                  "destroy-start");
        pipe.set_state(Gst.State.NULL);
        Gst.Debug.BIN_TO_DOT_FILE((!)(pipe as Gst.Bin),
                                  Gst.DebugGraphDetails.ALL,
                                  "destroy-end");
    });
  }

  public AppWindow(Gtk.Application app) {
    Object(application: app);
  }

  private bool on_bus_message(Gst.Bus bus, Gst.Message msg) {
    switch (msg.type) {
      case Gst.MessageType.ERROR: {
        Error err;
        string debug;
        msg.parse_error(out err, out debug);
        on_error(debug);
        this.destroy();
        break;
      }
      case Gst.MessageType.STATE_CHANGED: {
        // cache the current state for ui use
        msg.parse_state_changed(null, out state, null);
        video_area.queue_draw();
        break;
      }
    }
    return true;
  }

  private void on_error(string errmsg) {
    var dialog = new Gtk.MessageDialog(
      this,
      Gtk.DialogFlags.MODAL,
      Gtk.MessageType.ERROR,
      Gtk.ButtonsType.CLOSE,
      errmsg);
    dialog.show();
  }
}

} // namespace Ggvb