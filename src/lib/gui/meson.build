# add gui dependencies
ggvb_deps += [
  gdk_pixbuf_dep,
  gdk_wayland_dep,
  gdk_x11_3_0,
  gtk_dep,
]
# generate C sources from Vala
ggvb_sources += files(
  'app_window.vala',
  'histogram.vala',
)
# generate ui resources
subdir('resources')