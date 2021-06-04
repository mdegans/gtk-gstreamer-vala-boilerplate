/*
 * photobin.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

public errordomain PhotoError {
  QUEUE_FULL;
}

public class PhotoBin : Gst.Bin {
  const size_t MAX_BUFFERS = 10;

  /** Internal queue for captures */
  Gst.Element queue;
  /** Photo conversion element */
  Gst.Element converter;
  /** GstAppSink as GstElement */
  Gst.Element sink;

  /** Number of buffers to capture. Starts at 1 because preroll needed. */
  [Description(
    nick = "Number of Buffers",
    blurb = "Number of buffers to capture.")]
  public int num_buffers { get; private set; default = 1; }

  construct {
    var opt_queue = Gst.ElementFactory.make("queue", null);
    var opt_converter = Gst.ElementFactory.make(GST_CONVERTER, null);
    var opt_sink = Gst.ElementFactory.make("appsink", null);

    assert(opt_queue != null);
    assert(opt_converter != null);
    assert(opt_sink != null);

    queue = (!)opt_queue;
    converter = (!)opt_converter;
    sink = (!)opt_sink;

    add_many(queue, converter, sink);
    assert(queue.link_many(converter, sink));

    // set caps on appsink. We only accept RGBA buffers.
    var appsink = get_appsink();
    var opt_caps = Gst.Caps.from_string("video/x-raw, format=RGBA");
    assert(opt_caps != null);
    appsink.set_caps((!)opt_caps);


    // we need the queue sink pad to setup callbacks and to ghost it
    var opt_queue_sink = queue.get_static_pad("sink");
    assert(opt_queue_sink != null);
    var queue_sink = (!)opt_queue_sink;

    // add callback to drop buffers if not capturing
    queue_sink.add_probe(Gst.PadProbeType.BUFFER, on_new_buffer);

    // ghost pad so this bin is linkable directly
    add_pad(new Gst.GhostPad("sink", queue_sink));
  }

  /** Attached to queue sink. Drops if no captures are requested. */
  public Gst.PadProbeReturn on_new_buffer() {
    lock (this.num_buffers) {
      if (this.num_buffers > 0) {
        this.num_buffers--;
        return Gst.PadProbeReturn.OK;
      }
    }
    return Gst.PadProbeReturn.DROP;
  }

  /**
   * Pass one or more stills through to the appsink. Increments `num-buffers`.
   */
  public bool capture(int num = 1) throws PhotoError.QUEUE_FULL {
    // Could use AtomicInt here but we want to notify as well and i'm not sure
    // it can work.
    lock (this.num_buffers) {
      if (this.num_buffers + num > MAX_BUFFERS) {
        throw new PhotoError.QUEUE_FULL(
          @"Capture Queue is full (max $(MAX_BUFFERS) at a time).");
      }
      this.num_buffers += num;
    }
    return true;
  }

  /**
   * Appsink interface to connect to and get Samples from.
   */
  public Gst.App.Sink get_appsink() {
    var opt_appsink = this.sink as Gst.App.Sink;
    assert(opt_appsink != null);
    return (!)opt_appsink;
  }
}

} // namespace Ggbv