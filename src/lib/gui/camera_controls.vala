/*
 * camera_controls.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

/**
 * An example histogram widget. There may be multiple instances of this but the
 * data will be shared.
 */

[GtkTemplate (ui = "/components/camera_controls.ui")]
public class CameraControls : Gtk.Box {
  [GtkChild]
  Gtk.Button record;

  [GtkChild]
  Gtk.Button framegrab;

  public CameraControls(Ggvb.PhotoBin? opt_photobin = null,
                        Ggvb.RecordBin? opt_recordbin = null) {
    // connect photobin
    if (opt_photobin != null) {
      var photobin = (!)opt_photobin;
      framegrab.clicked.connect(() => {
        try {
          photobin.capture();
        } catch (PhotoError e) {
          on_error(e);
        }
      });
    } else {
      framegrab.hide();
    }

    // connect recordbin
    if (opt_recordbin != null) {
      // connect the start and stop functionality
      var recordbin = (!)opt_recordbin;
      record.clicked.connect(() => {
        try {
          if (recordbin.recording) {
            assert(recordbin.stop());
            // grey out
            record.set_sensitive(false);
          } else {
            assert(recordbin.start(15.0f));
            record.set_sensitive(false);
          }
        } catch (RecordError e) {
          on_error(e);
          record.set_sensitive(true);
        }
      });
      recordbin.recording_started.connect(() => {
        // change icon to stop (need to find a replacement for Gtk.Stock but
        // they suck in comparison.) Seriously, it was removed for no good
        // reason. It was *already* internationalized!
        record.set_label("stop");
        // un-grey the icon
        record.set_sensitive(true);
      });
      recordbin.recording_done.connect(() => {
        // change label to record
        record.set_label("record");
        // un-grey the icon
        record.set_sensitive(true);
      });
    } else {
      record.hide();
    }
  }

  /**
   * Forwards a GError to the toplevel's on_error if it exist or logs the error
   * message to the `CRITICAL` level */
  void on_error(Error? err = null, string? debug = null) {
    assert(err != null || debug != null);
    var toplevel = get_toplevel();
    var opt_appwin = toplevel as AppWindow;
    if (opt_appwin != null) {
      var appwin = (!)opt_appwin;
      appwin.on_error(err, debug);
    } else {
      string errmsg = "";
      if (debug != null) {
        errmsg += (!)debug;
      }
      if (err != null) {
        errmsg += ((!)err).message;
      }
      critical(errmsg);
    }
  }
}

} // namespace Ggvb