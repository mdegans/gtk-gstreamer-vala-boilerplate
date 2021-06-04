/*
 * pipeline.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

public class Pipeline : Gst.Pipeline {
  // Sub-Bins
  public PhotoBin photobin = new PhotoBin();
  public RecordBin recordbin = new RecordBin();

  /** Get overlay interface provided by sink. */
  Gst.Video.Overlay overlay;

  construct {
    var opt_src = Gst.ElementFactory.make("videotestsrc", null);
    var opt_sink = Gst.ElementFactory.make("xvimagesink", null);
    assert(opt_src != null && opt_sink != null);
    var src = (!)opt_src;
    var sink = (!)opt_sink;

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
  public signal void errmsg(Error? err = null, string? debug = null);

  /**
   * Get the video overlay interface of the sink. Not a property because
   * Overlay is not a GType and GParamSpec only supports.
   */
  public Gst.Video.Overlay get_overlay() { return overlay; }
}

} // namespace Ggvb