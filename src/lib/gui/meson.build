# add gui dependencies
ggvb_deps += [
  gdk_pixbuf_dep,
  gdk_wayland_dep,
  gdk_x11_3_0,
  gtk_dep,
]
# generate C sources from Vala
ggvb_sources += files(
  'components.vala',
  'gapplication.vala',
  'layouts.vala',
)
# generate C sources from xml resources
ggvb_sources += import('gnome').compile_resources(
  'gui-resources',
  'resources/gresources.xml',
  source_dir: ['resources'],
)
