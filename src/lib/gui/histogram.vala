/*
 * app_window.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

[GtkTemplate (ui = "/components/histogram.ui")]

/**
 * An example histogram widget. There may be multiple instances of this but the
 * data will be shared.
 */
public class Histogram : Gtk.Expander {
  [GtkChild]
  Gtk.DrawingArea drawing_area;

  /** Static pixbuf data */
  // I would be using consts for the size/width/channels but there's a valac C
  // generation bug that puts the #define *after* it's use in the private struct
  // so:
  // "src/lib/libGgvb.so.0.0.0.p/gui/histogram.c:57:59: error:
  // ‘GGVB_HISTOGRAM_HEIGHT’ undeclared here (not in a function); ..."
  static uint8 data[256 * 128 * 4];
  //  uint8[] data = new uint8[256 * 128 * 4];

  construct {
    // this is broken in the XML because GNU QA
    set_label("histogram");

    // connect all of the above
    drawing_area.draw.connect((ctx) => {
      // NOTE(mdegans): So, i've tried creating a pixbuf at creation, but when I
      // tried to get the allocated pixels i got an error, so it reuses the data
      // but a new GObject is constructed from data on every draw, which happens
      // a lot, so this isn't ideal, but it works.
      var pixbuf = new Gdk.Pixbuf.from_data(
        data,
        Gdk.Colorspace.RGB,
        true,  // alpha
        8,  // bits per sample
        256,  // width
        128,  // height
        256,  // stride
        null);  // deleter (data is static, no need)
      Gdk.cairo_set_source_pixbuf(ctx, pixbuf, 0.0, 0.0);
      ctx.paint();
    });
  }

  public Histogram(uint8 r=uint8.MIN,
                   uint8 g=uint8.MIN,
                   uint8 b=uint8.MIN) {
    for (size_t i = 0; i < data.length; i += 4) {
      data[i] = r;
      data[i + 1] = g;
      data[i + 2] = b;
      data[i + 3] = uint8.MIN;
    }
  }


  public void update(size_t[] hist) {
    // There is no point updating if the widget isn't expanded (?)
    if (!get_expanded()) {
      return;
    }

    // This should be on the class, but the compiler is spitting out broken code
    const size_t height = 128;
    const size_t width = 256;
    const size_t channels = 4;
    const size_t stride = width;

    assert(hist.length == width);

    // find biggest element in array
    size_t max_elem = 0;
    foreach (size_t count in hist) {
      if (count > max_elem) {
        max_elem = count;
      }
    }

    // we don't ever need to change color, so we only touch the alpha channel
    uint8 alpha = 0;
    uint8 h_val = 0;
    for (size_t y = 0; y != height; y++) {
      for (size_t x = 0; x < width; x++) {
        // histogram value scaled to height
        h_val = (uint8)((double)hist[x] / 
                (double)max_elem * (double)(height));
        // alpha is opaque if h_val is greater than the (inverse) height
        alpha = h_val > (height - y) ? uint8.MAX : uint8.MIN;
        data[y * stride + (x * channels) + channels - 1] = alpha;
      }
    }

    // draw the updated pixbuf
    drawing_area.queue_draw();
  }
}

} // namespace Ggvb