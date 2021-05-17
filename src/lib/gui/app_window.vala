/**
 * app_window.vala
 *
 * Copyright 2021 Michael de Gans <47511965+mdegans@users.noreply.github.com>
 *
 * MIT License - see LICENSE.build
 */

namespace Ggvb {

[GtkTemplate (ui = "/layouts/app_window.ui")]
public class AppWindow : Gtk.ApplicationWindow {
  /** reveals the left sidebar */
  [GtkChild]
  public Gtk.Revealer sidebar_l;

  /** reveals the right sidebar */
  [GtkChild]
  public Gtk.Revealer sidebar_r;

  /** reveals the bottom bar when the mouse is close */
  [GtkChild]
  public Gtk.Revealer bottom_revealer;

  /** drawing area for the video overlay */
  [GtkChild]
  public Gtk.DrawingArea video_area;

  /** left set of buttons (sources, ...) */
  [GtkChild]
  public Gtk.ButtonBox left_buttons;

  /** right set of buttons (fullscreen, preferences, ...) */
  [GtkChild]
  public Gtk.ButtonBox right_buttons;

  /** we add source appropriate controls to this box at runtime */
  [GtkChild]
  public Gtk.Box control_box;

  /** toggles the sources revealer */
  [GtkChild]
  public Gtk.ToggleButton btn_sources;

  /** toggles fullscreen */
  [GtkChild]
  public Gtk.ToggleButton btn_fullscreen;

  /** toggles the preferences revealer */
  [GtkChild]
  public Gtk.ToggleButton btn_preferences;

  construct {
    // connect all of the above
  }
}

} // namespace Ggvb