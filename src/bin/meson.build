# sources for the console app target
capp = executable('cgvb', 'capp.vala',
  dependencies: [
    ggvb_dep,
  ],
  install: true,
)

if gtk_dep.found()
  gapp = executable('ggvb', 'gapp.vala',
    dependencies: [
      ggvb_dep,
    ],
    install: true,
  )
endif