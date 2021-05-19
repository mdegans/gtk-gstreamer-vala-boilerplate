/**
 * app_window.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

[GtkTemplate (ui = "/components/histogram.ui")]
public class Histogram : Gtk.Expander {
  /** The *drawing area* width */
  public const size_t WIDTH = 256;
  /** the *drawing area* height */
  public const size_t HEIGHT = 128;
  
  [GtkChild]
  public Gtk.StackSwitcher lcrgb_switcher;

  [GtkChild]
  public Gtk.DrawingArea drawing_area;

  bool bitmap[WIDTH * HEIGHT];

  construct {
    // connect all of the above
    (void)update_area;
  }

  void update_area(size_t hist[WIDTH]) {
    // find biggest element in array
    size_t max_elem = 0;
    foreach (size_t count in hist) {
      if (count > max_elem) {
        max_elem = count;
      }
    }
    // scale height the biggest element
    for (size_t i = 0; i < WIDTH; i++) {
      hist[i] = (size_t)((double)hist[i] / (double)max_elem * (double)128);
    }
    // update bitmap
    for (size_t row = 0; row < HEIGHT; row++) {
      for (size_t col = 0; row < WIDTH; col++) {
        this.bitmap[row + col] = hist[col] <= row;
      }
    }
  }
}

} // namespace Ggvb