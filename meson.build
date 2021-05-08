# Change your project name here, Which will change it everywhere except in
# some `namespace` blocks, which you must rename manually. To be safe, just run
# a search and replace of this project, replacing `Ggbb` with
# `YourProjectNameLikeThis`
project('Ggvb', ['c', 'vala'],  # cpp/rust/whatever can be added here 
# change version in VERSION file. Semver is mandatory the way these meson.build
# files are written.
  version: run_command(
    'head', '-n', '1', files('VERSION'),
  ).stdout().strip(),
  meson_version: '>= 0.56.0',
  license: 'MIT', # change this to your project's license. List here:
  # https://spdx.org/licenses/
  # note: GStreamer may screech at you and plugins might not load if this is
  # not parsed by GStreamer because freetards. Recommand `LGPL-2.1+` to STFU.
  default_options: [
    'warning_level=2',  # -Wall, -Wextra
    'werror=true',  # -Werror
  ],
)

# describe your project in a sentence here
project_description = 'Example Gtk + GStreamer + Vala project.'
project_url = 'https://github.com/mdegans/gtk-gstreamer-vala-boilerplate'
package_name = meson.project_name() + ' (' + get_option('buildtype') + ')'

# add any global compiler flags here (be aware, Meson expects to manage most of
# this). almost anything you can add here can be set elsewhere, better.
c_args = [
  # '--strings', 'be', '-DADDED', 'here',
]
vala_args = [
  # '--more', 'strings',
]

# deps we'll reuse throught the project

# main gstreamer dep
gst_dep = dependency('gstreamer-1.0')
# base classes for plugin building
gst_base_dep = dependency('gstreamer-base-1.0': required: false)
# video overlay and more (required for gui)
gst_video_dep = dependency('gstreamer-video-1.0': required: false)
# GstCheck (for tests)
gst_check_dep = dependency('gstreamer-check-1.0': required: false)
# gtk (required for gui)
gtk_dep = dependency('gtk+-3.0', required: false)

# includes for extern c/cpp/rust stuff
subdir('include')
# most of our source is in this dir and subdirs
subdir('src')
