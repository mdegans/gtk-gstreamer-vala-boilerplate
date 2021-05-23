/*
 * test_histogram.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

int main(string[] args) {
  var app = new Gtk.Application(
    "dev.mdegans.GgvbTestHistogram", GLib.ApplicationFlags.FLAGS_NONE);

  size_t[] hist = new size_t[256];
  for (size_t i = 0; i != hist.length; i++) {
    hist[i] = i;
  }

  app.activate.connect(() => {
    var window = new Gtk.ApplicationWindow(app);

    var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    
    var histogram = new Ggvb.Histogram();
    var draw_btn = new Gtk.Button();

    draw_btn.clicked.connect(() => {
      histogram.update(hist);
    });

    box.add(histogram);
    box.add(draw_btn);

    window.add(box);
    window.show_all();
    window.present();
  });

  return app.run(args);
}