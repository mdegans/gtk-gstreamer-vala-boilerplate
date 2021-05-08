# sources for the console app target
capp_src = [
  'capp.vala',
]
capp = executable(capp_src)

if gtk_dep.found() 
  # sources for the Gtk app target
  gapp_src = [
    'gapp.vala',
  ]
  gapp = executable('ggvb', gapp_src,
    dependencies: [
      gtk_dep,
      gst_dep,
    ]
  )
endif