subdir('utils')
if gtk_dep.found()
  subdir('gui')
endif

# generates libggvb.so.0.0.0 and so on
lib = library(meson.project_name(), sources,
  dependencies: [
    gst_dep,
    gtk_dep,
  ],
  version: meson.project_version(),
  install: true,
)

