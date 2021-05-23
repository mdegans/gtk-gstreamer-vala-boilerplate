# .build for the top level library

# sources for the library
ggvb_sources = [
  config_vala,
  # more files are appended to this list by subdirs
]

# deps for the library
ggvb_deps = [
  gio_dep,
  gst_base_dep,
  gst_check_dep,
  gst_dep,
  gst_video_dep,
  # more deps may be appended by subdirs
]

subdir('core')
subdir('utils')
if build_gui
  subdir('gui')
else
  warning('libgtk-3-dev not found. Gui will not be built.')
endif

# library target for libggvb
libggvb = library(meson.project_name(), ggvb_sources,
  dependencies: ggvb_deps,
  vala_args: [
    vala_args,
    # fix compiler bug where valac generates "Ggvb.h" instead of "ggvb.h" FML
    '--header=' + meson.current_build_dir() / 'ggvb.h',
  ],
  c_args: c_args,
  # generates libggvb.so.0.0.0 and symlinks
  version: meson.project_version(),
  install: true,
)

# config as a "key=value" list of strings for
# use in declare_dependency and pkgconfig
ggvb_variables = []
foreach k, v : config
  ggvb_variables = '@0@=@1@'.format(k, v)
endforeach

ggvb_dep = declare_dependency(
  link_with: libggvb,
  dependencies: [
    ggvb_deps,
  ],
  include_directories: [
    incdirs,
    include_directories('.'),  # for the generated header
  ],
  variables: ggvb_variables,
)