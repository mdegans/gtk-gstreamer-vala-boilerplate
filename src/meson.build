# if it's configuration related, it should probably be in this file

# handy version variables for this project.
version_arr = meson.project_version().split('.')
version_short = (version_arr[0] + '.' + version_arr[1]).substring(0, 16)
version_major = version_arr[0].to_int()
version_minor = version_arr[1].to_int()
version_patch = version_arr[2].to_int()
version_git = 'untracked'
origin = 'tarball'
version_git_cmd = run_command(
  'git', 'rev-parse', '--short', 'HEAD'
)
if version_git_cmd.returncode() == 0
  version_git = version_git_cmd.stdout().strip().substring(0, 7)
  origin = 'git'
endif
version_long = meson.project_version() + '.' + version_git

# handy version variables for GStreamer
gst_version_long = gst_dep.version()
gst_version_arr = gst_version_long.split('.')
gst_version_major = gst_version_arr[0].to_int()
gst_version_minor = gst_version_arr[1].to_int()
gst_version_patch = gst_version_arr[2].to_int()

build_gui = false
if gtk_dep.found() and gdk_pixbuf_dep.found() and (gdk_x11_dep.found() or gdk_wayland_dep.found())
  build_gui = true
endif

# a dict for this project's configuration.
config = {
  'PROJECT_NAME': meson.project_name(),
  'PROJECT_NAME_LOWER': meson.project_name().to_lower(),
  'PROJECT_DESCRIPTION': project_description,
  'PLUGIN_DESCRIPTION': 'Plugin for ' + meson.project_name(),

  # config stuff
  'HAS_GUI': build_gui,

  # we can only specify one because GStreamer.
  'LICENSE': meson.project_license()[0],
  'PROJECT_URL': project_url,
  'PACKAGE_NAME': package_name,
  'ORIGIN': origin,

  # version stuff
  'VERSION_LONG': version_long,
  'VERSION_SHORT': version_short,
  'VERSION_MAJOR': version_major,
  'VERSION_MINOR': version_minor,
  'VERSION_PATCH': version_patch,
  'VERSION_GIT': version_git,

  ## random variables
  # Note: it's advasible to use the systemwide pluginsdir since another prefix
  # will probably not be scanned by GStreamer by default.
  'PLUGINSDIR': gst_dep.get_variable(pkgconfig: 'pluginsdir'),
  'PREFIX': get_option('prefix'),
  'DATADIR': get_option('prefix') / get_option('datadir'),
  'LIBDIR': get_option('prefix') / get_option('libdir'),
  'GIRDIR': get_option('prefix') / get_option('datadir') / 'gir-1.0',
  'TYPELIBDIR': get_option('prefix') / get_option('libdir') / 'girepository-1.0',

  # gstreamer version stuff
  'GST_VERSION_LONG': gst_version_long,
  'GST_VERSION_MAJOR': gst_version_major,
  'GST_VERSION_MINOR': gst_version_minor,
  'GST_VERSION_PATCH': gst_version_patch,

  # gstreamer
  'GST_PLUGINSDIR': gst_dep.get_variable(pkgconfig: 'pluginsdir'),
  'GST_PREFIX': gst_dep.get_variable(pkgconfig: 'prefix'),
  'GST_DATADIR': gst_dep.get_variable(pkgconfig: 'datadir'),
  'GST_LIBDIR': gst_dep.get_variable(pkgconfig: 'libdir'),
  'GST_GIRDIR': gst_dep.get_variable(pkgconfig: 'girdir'),
  'GST_TYPELIBDIR': gst_dep.get_variable(pkgconfig: 'typelibdir'),
}

# this works like cmake's configure_file, except
# we're feeding it a dict instead of letting it grab
# anything and everything. It also accepts a configuration
# object, which further restricts what can be stuffed
# into a template.
config_vala = configure_file(
  input: 'config.vala.in',
  output: 'config.vala',
  configuration: config,
)


# build gstreamer plugins in this dir
if gst_base_dep.found()
  subdir('plugins')
endif
subdir('lib')
subdir('bin')
subdir('test')