/**
 * gapp.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 *
 * This file is a template. These will eventually become #defines in C, prefixed
 * with the namespace name like `GGVB_VERSION_LONG`.
 */

static int main(string[] args) {
  Gst.init(ref args);

  var app = new Gtk.Application(
    "dev.mdegans.GgvbGui", GLib.ApplicationFlags.FLAGS_NONE);

  app.activate.connect(() => {
    var window = new Ggvb.AppWindow(app);

    window.show_all();
    window.present();
  });

  return app.run(args);
}
