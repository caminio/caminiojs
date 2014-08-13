return if window.LANG != 'de'
Em.I18n.translations ||= {}
Em.merge( Em.I18n.translations, {
  accounts:
    'overview': "Überblick"
    'plans_and_prices': "Pläne und Preise"
    'organizations': "Organisationen"
    'invoices': 
      'title': "Rechnungen"
      'my': 'Meine Rechnungen'
      'date': 'Datum'
      'no': 'Nr.'
      'amount': 'Betrag'
      'none_yet': 'Es wurden noch keine Rechnungen ausgestellt'
    'personal_data': "Persönliche Angaben"
    'address': 'Adresse'
    'avatar': 'Avatar'
    'click_img_left_to_update': 'Klick auf das Bild um deinen persönlichen Avatar hochzuladen'
    'plans': 'Pläne'
    plan:
      'my': 'Meine Pläne'
      'save': 'Pläne speichern'
      'add': 'Plan hinzufügen'
      'select_your': 'Wähle deine Pläne'
      'select_first_then_apply': 'Wähle zuerst die Pläne und Apps aus, die du verwenden möchtest. Um einen Plan hinzuzufügen, klick auf das <button class="btn btn-primary btn-xs"><i class="fa fa-plus"></i></button>.<br> Um den Plan wieder zu entfernen, wechsle in deine Profileinstellungen -> "Pläne und Preise". Deine Auswahl wird erst gespeichert, wenn du in dieser Übersicht auf "Pläne speichern" geklickt hast'
      'disk': 'Speicherplatz'
      'items': 'max Einträge'
      'app_name': 'App'
      'name': 'Bezeichnung'
      'collaborators': 'Mitarbeiter'
      'price': 'Preis'
      'access': 'Zugriffsrechte'
      'quota': 'Quota'
})
