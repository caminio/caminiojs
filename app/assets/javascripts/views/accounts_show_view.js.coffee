Caminio.AccountsShowView = Caminio.FadedView.extend
  layoutName: 'accounts/layout'

Caminio.AccountsMineView = Caminio.AccountsShowView.extend
  templateName: 'accounts/show'
  layoutName: 'accounts/layout'
