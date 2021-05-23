# Change your project name here, Which will change it everywhere except in
# some `namespace` blocks, which you must rename manually. To be safe, just run
# a search and replace of this project, replacing `Ggbb` with
# `YourProjectName` likewise rename `ggvb` to `your_project_name` and
# `GGVB` to `YOUR_PROJECT_NAME`
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

test_c_args = [
  # ditto as above, but only for tests
]

vala_args = [
  # because the language server is failing:
  # FIXME(mdegans): fix this
  '--pkg=gtk+-3.0',
  # '--pkg=gdk_x11_3_0',
  # '--pkg=gdk-wayland-3.0',
  # '--more', 'strings',
  '--vapi-comments',  # puts code comments in the vapi
  '--abi-stability',
  '--enable-experimental-non-null',  # to not foot gun
]

test_vala_args = [
  # ditto as above, but only for tests
]

## deps we'll reuse throught the project

# Note: deps that are required: false will be ignored if not found

# gio for async stuff and GLib.Application
gio_dep = dependency('gio-2.0')
# main gstreamer dep
gst_dep = dependency('gstreamer-1.0')
# base classes for plugin building
gst_base_dep = dependency('gstreamer-base-1.0')
# video overlay and more (required for gui and video format info)
gst_video_dep = dependency('gstreamer-video-1.0')
# GstCheck (for tests)
gst_check_dep = dependency('gstreamer-check-1.0', required: get_option('tests'))
# gtk (required for gui)
gtk_dep = dependency('gtk+-3.0', required: get_option('gui'))
# gdk-pixbuf (required for still snapshots)
gdk_pixbuf_dep = dependency('gdk-pixbuf-2.0')
# gdk-x11 (required for gui video overlay in x11)
gdk_x11_dep = dependency('gdk-x11-3.0', required: get_option('gui'))
# gdk-wayland (required for wayland)
gdk_wayland_dep = dependency('gdk-wayland-3.0', required: get_option('wayland'))

# includes for extern c/cpp/rust stuff. They can be used in Vala if you wrap
# them.
subdir('include')
# most of our source is in this dir and subdirs
subdir('src')

# see src/meson.build for configuration details