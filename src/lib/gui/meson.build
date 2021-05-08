# generate C sources from Vala
sources += files([
  'components.vala',
  'layouts.vala',
])
# generate C sources from xml
sources += import('gnome').compile_resources(
  'gui-resources',
  'resources/gresources.xml',
  source_dir: ['resources'],
)
