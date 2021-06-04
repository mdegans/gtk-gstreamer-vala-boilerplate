/*
 * recordbin.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

public errordomain RecordError {
  BUSY;
}

public class RecordBin : Gst.Bin {
  /** Internal queue for captures */
  Gst.Element queue;
  /** Output selector (like a tee) */
  dynamic Gst.Element selector;
  Gst.Pad selector_src_fake;
  Gst.Pad selector_src_conv;

  /** Fakesink to dump video when not recording */
  Gst.Element fakesink;

  /** Video conversion element */
  Gst.Element converter;
  /** Encoder element */
  dynamic Gst.Element encoder;
  /** Encoded stream parser */
  dynamic Gst.Element parser;
  /** File sink */
  dynamic Gst.Element filesink;

  /** True if recording is in progress. */
  [Description(
    nick = "Recording",
    blurb = "True if recording is in progress.")]
  public bool recording { get; private set; }

  /** True if recording is in progress. */
  [Description(
    nick = "Codec",
    blurb = "Codec used for encoding. Set at build time."),
   CCode(notify=false)]
  public string codec { get { return USE_H265 ? "h265" : "h264"; } }

  construct {
    // decide which encoder and parser
    string encoder_name = "";
    string parser_name = "";
    if (USE_H265) {
      encoder_name = GST_H265_ENCODER;
      parser_name = "h265parse";
    } else {
      // use H264
      encoder_name = GST_H264_ENCODER;
      parser_name = "h264parse";
    }

    // create elements
    var opt_queue = Gst.ElementFactory.make("queue", null);
    var opt_selector = Gst.ElementFactory.make("output-selector", null);
    var opt_fakesink = Gst.ElementFactory.make("fakesink", null);
    var opt_converter = Gst.ElementFactory.make(GST_CONVERTER, null);
    var opt_encoder = Gst.ElementFactory.make(encoder_name, null);
    var opt_parser = Gst.ElementFactory.make(parser_name, null);
    var opt_filesink = Gst.ElementFactory.make("filesink", null);

    assert(opt_queue != null);
    assert(opt_selector != null);
    assert(opt_fakesink != null);
    assert(opt_converter != null);
    if (opt_encoder == null) {
      // panic (no good way to signal the gui here)
      if (IS_TEGRA) {
        error(@"$(encoder_name) not found. Are Nvidia plugins available?");
      } else {
        error(@"$(encoder_name) not found. Try `sudo apt install gstreamer1.0-plugins-ugly`");
      }
    }
    if (opt_parser == null) {
      error(@"$(parser_name) not found. Try `sudo apt install gstreamer1.0-plugins-bad`");
    }
    assert(opt_filesink != null);

    queue = (!)opt_queue;
    selector = (!)opt_selector;
    fakesink = (!)opt_fakesink;
    converter = (!)opt_converter;
    encoder = (!)opt_encoder;
    parser = (!)opt_parser;
    filesink = (!)opt_filesink;

    // add all to self
    add_many(queue, selector, fakesink, converter, encoder, parser, filesink);

    // link it all together
    queue.link(selector);
    // we need to get some pads from the selector to be able to select branches
    // later on.
    var opt_selector_src_fake = selector.get_request_pad("src_%u");
    var opt_selector_src_conv = selector.get_request_pad("src_%u");
    assert(opt_selector_src_fake != null);
    assert(opt_selector_src_conv != null);
    selector_src_fake = (!)opt_selector_src_fake;
    selector_src_conv = (!)opt_selector_src_conv;

    // set the active pad to be the one to the fakesink and the only one active
    selector.active_pad = selector_src_fake;
    selector.pad_negotiation_mode = 2; // active

    // link the pads teo the fakesink and converter
    var opt_fakesink_sink = fakesink.get_static_pad("sink");
    var opt_converter_sink = converter.get_static_pad("sink");
    assert(opt_fakesink_sink != null);
    assert(opt_converter_sink != null);
    selector_src_fake.link((!)opt_fakesink_sink);
    selector_src_conv.link((!)opt_converter_sink);



  }

  public bool start(float seconds) throws RecordError.BUSY {
    lock (this.recording) {
      if (this.recording) {
        throw new RecordError.BUSY(
          "Recording already in progress.");
      }
      this.recording = true;
      selector.active_pad = selector_src_conv;
      return true;
    }
  }

  public bool stop() {
    selector.active_pad = selector_src_fake;
    return false;
  }

  public signal void recording_started(string filename);
  public signal void recording_done(string filename, float seconds);
}

} // namespace Ggbv