# Copyright (c) 2021 Michael de Gans

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# put regular tests here
tests = []

# put gui tests here
gui_tests = [
  {
    'description': 'test histogram',
    'filename': 'test_histogram',
    'sources': ['test_histogram.vala'],
    'suites': ['interactive'],
    'extra_deps': [],
  },
]

if build_gui
  tests += gui_tests
endif

foreach t : tests
  # build the test executable
  exe = executable(t['filename'], t['sources'],
    dependencies: ggvb_dep,
    c_args: [
      test_c_args,
      '-DTEST_NAME="' + t['filename'] + '"',
    ],
    vala_args: [test_vala_args],
  )

  # skip running test if it's an interactive one
  if 'interactive' in t['suites']
    continue
  endif

  # run the rest of the tests in parallel
  test(t['description'], exe,
    protocol: 'exitcode',
    is_parallel: false,
    suite: t['suites'],
    timeout: 300,  # seconds
    env: test_env_variables,
  )
endforeach