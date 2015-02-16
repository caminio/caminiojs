Caminio.UsersLayoutView = Caminio.FadedView.extend
  layoutName: 'settings/layout'

#
# INDEX
#
Caminio.UsersIndexView = Caminio.UsersLayoutView.extend()

#
# NEW
#
Caminio.UsersNewView = Caminio.FadedView.extend()


#
# EDIT
#
Caminio.UsersEditView = Caminio.UsersLayoutView.extend()
