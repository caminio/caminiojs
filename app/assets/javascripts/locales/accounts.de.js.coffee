Em.I18n.availableTranslations ||= {}
Em.I18n.availableTranslations.de ||= {}
Em.merge Em.I18n.availableTranslations.de,
  accounts:
    'overview': "Überblick"
    'plans_and_prices': "Tarife und Preise"
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
    'plans': 'Tarife'
    plan:
      'my': 'Meine Tarife'
      'save': 'Pläne speichern'
      'add': 'Tarif hinzufügen'
      'select_your': 'Wähle deine Tarife'
      'select_first_then_apply': 'Wähle zuerst die Pläne und Apps aus, die du verwenden möchtest. Um einen Tarif hinzuzufügen, klick auf das <button class="btn btn-primary btn-xs"><i class="fa fa-plus"></i></button>.<br> Um den Tarif wieder zu entfernen, wechsle in deine Profileinstellungen -> "Pläne und Preise". Deine Auswahl wird erst gespeichert, wenn du in dieser Übersicht auf "Pläne speichern" geklickt hast'
      'disk': 'Speicherplatz'
      'items': 'max Einträge'
      'app_name': 'App'
      'name': 'Bezeichnung'
      'collaborators': 'Mitarbeiter'
      'price': 'Preis'
      'access': 'Zugriffsrechte'
      'quota': 'Quota'
    plans:
      'updated': 'Pläne wurden aktualisiert und gespeichert'
      'select_at_least_one': 'Es muss mindestens ein Tarif aktiv sein. Es gibt auch kostenlose Tarife. Bitte wähle einen.'
    organizations:
      'title': 'Organisationen'
      'add': 'Neue Organisationen hinzufügen'
      'name': 'Firma / Arbeitsgruppe'
      'default_lang': 'Bevorzugte Sprache'
      'owner': 'Eigentümer'
      'collaborators': 'Mitarbeiter'
      'create': 'Organisation erstellen'
      'create_title': 'Neue Organisation'
      'created': 'Organisation {{name}} wurde erfolgreich gespeichert'
      'select': 'Wähle eine Organisation aus der Liste, um sie zu bearbeiten'
      'settings': 'Einstellungen'
      'change_ownership_desc': 'Du kannst die Eigentümerschaft dieser Organisation an eine andere Person übertragen. Die angegebene Person muss Mitglied in der Organistaion sein. Um den Eigentümerwechsel abzuschließen, muss der neue Eigentümer zustimmen und falls kommerzielle Produkte verwendet werden, die erforderlichen Bankdaten bekannt gegeben haben.'
      'delete': 'Organisation löschen'
      'really_delete': 'Möchtest du die Organisation <strong>{{name}}</strong> wirklich löschen? Alle Mitglieder werden aus der Organisation ausgetragen und zugehörige Daten werden gelöscht. Diese Aktion kann nicht rückgängig gemacht werden. Falls du fortfahren möchtest, schreib bitte den Namen der Organisation (<strong>{{name}}</strong>)'
      'deleted': 'Organisation <strong>{{name}}</strong> wurde gelöscht'
      'yes': 'ja'
    users:
      'title': 'Mitarbeiter'
      'id': 'ID'
      'email': 'Email'
      'firstname': 'Vorname'
      'lastname': 'Nachname'
      'formattedLastLoginAt': 'Login'
      'add': 'Mitarbeiter hinzufügen / einladen'
      'invite_desc': 'Du kannst Mitarbeiter in deine Organisation einladen und ihnen Rechte für Anwendungen zuteilen.'
      'lang_help': 'Sprache der Einladungsemail und voreingestellte Systemsprache'
      'password_saved': 'Das neue Passwort wurde gespeichert'
      'model_access': 'Du kannst hier Zugriffsrechte für dieses Konto einstellen'
