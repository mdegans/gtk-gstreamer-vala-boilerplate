/**
 * pipeline.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 *
 * This file is a template. These will eventually become #defines in C, prefixed
 * with the namespace name like `GGVB_VERSION_LONG`.
 */

namespace Ggvb {

class Pipeline : Gst.Pipeline {
  public Gst.Video.Overlay overlay;

  construct {
    var src = Gst.ElementFactory.make("videotestsrc", null);
    var sink = Gst.ElementFactory.make("xvimagesink", null);

    if (sink is Gst.Video.Overlay) {
      overlay = (!)(sink as Gst.Video.Overlay);
    } else {

    }

    add_many(src, sink);
    src.link(sink);
  }

  /**
   * Signal emitted by the pipeline on error so it can be handled by the UI.
   * Supply a string and/or GError.
   */
  public signal void errmsg(string? msg = null, Error? err = null);
}

} // namespace Ggvb