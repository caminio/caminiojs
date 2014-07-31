return if window.LANG != 'de'
Em.I18n.translations ||= {}
Em.merge( Em.I18n.translations, {
  accounts:
    'overview': "Überblick"
    'plans_and_prices': "Pläne und Preise"
    'organizations': "Organisationen"
    'personal_data': "Persönliche Angaben"
    'address': 'Adresse'
    'avatar': 'Avatar'
    'click_img_left_to_update': 'Klick auf das Bild um deinen persönlichen Avatar hochzuladen'
    plan:
      'app_name': 'App'
      'name': 'Bezeichnung'
      'collaborators': 'Mitarbeiter'
      'price': 'Preis'
      'access': 'Zugriffsrechte'
})
