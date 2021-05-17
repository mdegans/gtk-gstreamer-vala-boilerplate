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
  public const size_t HISTOGRAM_WIDTH = 256;
  public const size_t HISTOGRAM_HEIGHT = 128;
  
  [GtkChild]
  public Gtk.StackSwitcher lcrgb_switcher;

  [GtkChild]
  public Gtk.DrawingArea drawing_area;

  bool bitmap[HISTOGRAM_WIDTH * HISTOGRAM_HEIGHT];

  construct {
    // connect all of the above
    (void)update_area;
  }

  void update_area(size_t hist[HISTOGRAM_WIDTH]) {
    // find biggest element in array
    size_t max_elem = 0;
    foreach (size_t count in hist) {
      if (count > max_elem) {
        max_elem = count;
      }
    }
    // scale height the biggest element
    for (size_t i = 0; i < HISTOGRAM_WIDTH; i++) {
      hist[i] = (size_t)((double)hist[i] / (double)max_elem * (double)128);
    }
    // update bitmap
    for (size_t row = 0; row < HISTOGRAM_HEIGHT; row++) {
      for (size_t col = 0; row < HISTOGRAM_WIDTH; col++) {
        this.bitmap[row + col] = hist[col] <= row;
      }
    }
  }
}

} // namespace Ggvb