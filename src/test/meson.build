# define environment variables for all tests here
test_env_variables = [
  'GST_DEBUG=4', # GST_DEBUG level. Google this if you want filtering.
  'GST_PLUGIN_PATH=' + pluginsdir_uninstalled, # uninstalled plugin path
  'GST_DEBUG_DUMP_DOT_DIR=' + meson.current_build_dir(), # graphviz .dot files
]

subdir('exitcode')
if gst_check_dep.found()
  subdir('gst_check')
endif