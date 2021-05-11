# Put any GStreamer plugin targets in this folder. Example bins are provided.
# Plugins should be usable on their own and not depend on ../lib etc.


# change this if you install plugins somewhere else
# generally, gstreamer does not search anywhere else unless you append to
# the GST_PLUGIN_PATH environment variable
pluginsdir = config['PLUGINSDIR']

# a variable to point to this **build** directory for use in testing
# (so gstreamer can find the .so files generated without installation).
# see ../test/meson.build
pluginsdir_uninstalled = meson.current_build_dir()

# we'll configure plugin.vala the same way we did config.vala, and with the same
# configuration dict
plugin_vala = configure_file(
  input: 'plugin.vala.in',
  output: 'plugin.vala',
  configuration: config,
)

# sources for the plugin
plugin_sources = [
  plugin_vala,  # registers the bins/elements below
  'dvrbin.vala',  # a dvr bin to record video clips
  'photobin.vala',  # a photo bin to take snapshots
]

# The plugin library. Generally, but not always, this is a shared library.
plugin = library('gst' + meson.project_name(), plugin_sources,
  dependencies: [
    gio_dep,
    gst_dep,
    gst_base_dep,
    gst_video_dep,
    gdk_pixbuf_dep,
  ]
)