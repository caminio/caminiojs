Em.I18n.availableTranslations ||= {}
Em.I18n.availableTranslations.de ||= {}

Em.merge Em.I18n.availableTranslations.de,
  alias: 'Alias'
  or: 'oder'
  year: 'Jahr'
  month: 'Monat'
  username_or_email: 'Benutzername oder Email'
  firstname: 'Vorname'
  lastname: 'Nachname'
  password: 'Passwort'
  login: 'Anmelden'
  logout: 'Abmelden'
  aborted: 'Abgebrochen'
  no_account_yet: 'Noch kein Konto?'
  back_to_login: 'Zurück zum Login'
  signup: 'Kostenlos Registrieren'
  confirmation_code: 'Bestätigungs-Code'
  confirmation_code_has_been_sent: 'Ein Bestätigungs-Code wurde an die angegebene Email-Adresse versandt. Bitte prüfe deinen Posteingang und gib den in der Email angeführten 4-stelligen Code hier ein'
  forgot_your_password: 'Passwort vergessen?'
  send_link: 'Email senden'
  reset_password: 'Passwort zurücksetzen'
  reset_password_desc: 'Sie können jetzt ein neues Passwort wählen. Bitte beachte die Kriterien (mind. 1 Großbuchstabe, mind. 1 Kleinbuchstabe, mind. 1 Ziffer)'
  forgot_password_desc: 'Sie haben Ihr dein Passwort vergessen? Wir wissen es auch nicht. Es liegt verschlüsselt auf unserem Server gespeichert. Geben Sie Ihre Email Adresse an, und wir senden dir einen Link zu, mit dem Sie Ihr Passwort neu setzen kannst.'
  link_sent: 'Ein Link wurde an {{email}} versandt. Bitte prüfe deinen Posteingang und klick auf den in der Email enthaltenen Link'
  continue: 'Weiter'
  register: 'Registrieren'
  username: 'Alias'
  private: 'Privat'
  color: 'Farbe'
  agree_policies: 'Ich bin mit den Allgemeinen Geschäftsbedingungen einverstanden'
  search_app: 'Anwendung suchen'
  search_dots: 'Suche ...'
  your_selection: 'Deine Auswahl'
  select_language: 'Sprache wählen'
  select_reference: 'Referenz auswählen'
  nothing_selected: 'Nichts ausgewählt'
  apps: 'Applikationen'
  date: 'Datum'
  time: 'Zeit'
  o_clock: 'Uhr'
  no_address_set: 'Keine Adresse vorhanden'
  no_address_set_abbr: 'k.A.'
  no_title_set: 'Kein Titel vorhanden'
  sum: 'Summe exkl. MwSt.'
  vat: 'MwSt.'
  total: 'Summe'
  actions: 'Aktionen'
  delete: 'Löschen'
  filter: 'Nach Kriterien filtern...'
  sort: 'Sortierung ändern'
  col_setup: 'Spalten konfigurieren'
  click_to_set_text: '&lt; Klicken um Text einzugeben &gt; '
  click_to_set_time: '&lt; Klicken um Zeit einzustellen &gt; '
  click_to_create_item: 'Klicken Sie hier um das Element anzulegen'
  edit_details: 'Details bearbeiten'
  no_results_found_creating_new: 'Keine Elemente gefunden. <br>Geben Sie einen Namen in das Suchfeld ein und drücken Sie auf den &quot;Erstellen&quot;-Knopf, um ein Element mit dem angegebenen Namen neu zu erstellen'
  enter_name_to_create_new: 'Geben Sie einen Namen ein, um ein neues Element anzulegen'
  dashboard:
    title: 'Dashboard'
    activity: 'Aktivitäten'

  activity:
    logged_in: 'hat sich am System angemeldet'
    logged_out: 'hat sich vom System abgemeldet'

  administration: 'Administration'
  
  save: 'Speichern'
  cancel: 'Abbrechen'
  close: 'Schließen'
  next: 'Weiter'
  previous: 'Zurück'
  finish: 'Abschließen'
  saved: '{{name}} wurde gespeichert'

  cancel_edit_entry: 'Bearbeiten abbrechen'
  edit_entry: 'Eintrag bearbeiten'
  entry_saved: 'Eintrag gespeichert'
  search_for: 'Suche nach...'

  superuser_actions: 'Superuser Aktionen'

  no_matches_found: 'Keine Ergebnisse gefunden'

  new: 'Neu'
  settings_saved: 'Einstellungen gespeichert'
  name: 'Name'
  title: 'Titel'
  create: 'Erstellen'
  created_at: 'Erstellt am'
  email: 'Email'
  phone: 'Mobiltelefon'
  current_organization: 'Aktuelle Organisation'

  users:
    title: 'Benutzerkonten'
    follow: 'Änderungen bei Benutzerkonten folgen'
    select_amount: 'Wählen Sie die gewünschte Teamgröße ( {{pricePerUser}} / Benutzer / Monat ). Ziehen Sie dazu den Regler auf die gewünschte Position'
    pl_title: 
      one: 'Benutzerkonto'
      other: 'Benutzerkonten'
    online: 'Benutzer online'
    quota: 'Quota'
    allowed: 'Max. Benutzer (Quota)'
    new: 'Neuer Benutzer'
    edit: 'Benutzer bearbeiten'

  roles:
    admin: 'Administrator'
    editor: 'Redakteur'
    user: 'Standard'

  user:
    role: 'Rolle'
    not_set: 'nicht vergeben'
    name: 'Voller Name'
    search: 'Benutzer suchen'
    change_password: 'Passwort ändern'
    role_changed: 'Benutzerkonto <tt>{{name}}</tt> ist jetzt <strong>{{role}}</strong>'
    locale_changed: 'Sprache für das Benutzerkonto wurde auf <strog>{{locale}}</strong> gesetzt'
    language: 'Sprache'
    general: 'Allgemein'
    edit: 'Benutzerkonto bearbeiten'
    select_role: 'Rolle wählen'
    suspend_login: 'Suspendieren'
    activate_login: 'Suspendierung aufheben'
    suspended: 'Suspendiert'
    status: 'Status'
    active: 'Aktiv'
    really_suspend: 'Möchten Sie dieses Benutzerkonto wirklich suspenieren?'
    has_been_suspended: 'Das Benutzerkonto wurde suspendiert. Login ist nicht mehr möglich'
    back_active: 'Das Benutzerkonto ist jetzt aktiv und kann wieder verwendet werden'
    really_delete: 'Um das Benutzerkonto <tt>{{email}}</tt> <strong>unwiderruflich</strong> zu löschen, gib bitte noch einmal die Email Adresse zur Bestätigung ein'
    has_been_deleted: 'Das Benutzerkonto <strong>{{name}}</strong> wurde gelöscht'
    unsubscribe_from_group: 'Aus Gruppe entfernen'
    delete: 'Löschen'
    delete_permanently: 'Permanent löschen'
    current_password: 'Aktuelles Passwort'
    new_password: 'Neues Passwort'
    repeat_new_password: 'Neues Passwort wiederholen'
    passwords_missmatch: 'Die Passwörter stimmen nicht überein'
    password_changed: 'Das Passwort wurde geändert'
    old_password_missmatch: 'Das aktuelle Passwort stimmt nicht'

  groups:
    manage: 'Gruppen verwalten'
    title: 'Gruppen'
    follow: 'Änderungen in Gruppen folgen'
    pl_title: 
      one: 'Gruppe'
      other: 'Gruppen'
    largest: 'Größte Gruppe'
    new: 'Neue Gruppe'

  group:
    create_new: 'Neue Gruppe erstellen'
    member_added: '{{email}} ist jetzt Mitglied in der Gruppe {{name}}'
    member_removed: '{{email}} ist jetzt kein Mitglied der Gruppe {{name}} mehr'
    name: 'Name der Gruppe'
    search: 'Gruppe suchen'
    edit: 'Gruppe bearbeiten'
    edit_members: 'Mitglieder bearbeiten'
    general: 'Allgemein'
    members: 'Mitglieder'
    members_of: 'Mitglieder von <strong>{{name}}</strong>'
    really_delete: 'Gruppe <tt>{{name}}</tt> wirklich löschen?'
    delete: 'Gruppe löschen'
    deleted: 'Gruppe <strong>{{name}}</strong> wurde gelöscht'
    add_user: 'Benutzer zur Gruppe hinzufügen'
    add_member: 'Mitglied hinzufügen'
    num_members:
      one: 'Ein Mitglied'
      other: '{{count}} Mitglieder'

  organizations:
    further: '{{count}} weitere Organisationen'
    show_all: 'Alle Organisationen anzeigen'

  organization:
    my: 'Meine Organisation'
    title: 'Organisation'
    edit: 'Organisation bearbeiten'
    name: 'Name der Organisation'
    create_new: 'Neue Organisation erstellen'
    new_0: 'Neue'
    new_1: 'Organisation'
    general: 'Allgemein'
    fqdn: 'Domäne (FQDN)'

  account:
    settings: 'Einstellungen'
    mine: 'Mein Konto'
    manage: 'Konten verwalten'
    personal: 'Angaben zur Person'
    security: 'Sicherheit'
    contact_info: 'Kontaktinformationen'
    enter_current_password: 'Zur Bestätigung gib bitte dein aktuelles Passwort an'
    wrong_password: 'Das angegebene Passwort ist falsch'
    general: 'Allgemein'
    privacy: 'Privatsphäre'
    groups: 'Gruppen'
    create_account: 'Konto erstellen'
    edit: 'Konto bearbeiten'
    edit_mine: 'Mein Konto bearbeiten'
    admin:
      users: 'Konten verwalten'
      organizations: 'Organisationen'

  table:
    start_tour: 'Einführung über Tabellen starten'
    select_unselect_all_rows: 'Alle Zeile selektieren / Selektion aller Zeilen aufheben'
    select_unselect_row: 'Diese Zeile selektieren / Selektion aufheben'
    click_here_to_save: 'Klicken Sie hier, um die Einstellungen für diese Zeile zu speichern'
    delete_row: 'Diese Zeile löschen'
    cancel_edit: 'Bearbeiten abbrechen und Änderungen verwerfen'
    rows:
      one: 'Eine Zeile gesamt'
      other: '{{count}} Zeilen gesamt'
    rows_selected:
      one: 'Eine ausgewählte Zeile'
      other: '{{count}} ausgewählte Zeilen'

  subscriptions:
    title: 'Abonnements'
    really_switch_to_plan: 'Möchten Sie wirklich auf den Plan <tt>{{title}}</tt> wechseln? Bestätigen Sie den Wechsel bitte mit Ihrem Password'
    switched_to_plan: 'Sie haben nun in den Plan <tt>{{title}}</tt> gewechselt'
    start_tour: 'Einführung starten'

  subscription:
    checkout: 'Zur Kassa'
    no_changes: 'keine Änderungen'
    saved_will_reload_now: 'Abonnement gespeichert. Die Seite lädt sich in Kürze neu.'
    walkthrough:
      title: 'Einführung in Abonnements'
      welcome: 
        title: 'Willkommen!' 
        body: 'Hier können Sie Anwendungen und Pläne auswählen, die für Sie von Interesse sind.<br><br>Fast alle Anwendungen haben kostenlose- oder Testangebote.<br><br>Sie können Ihre Konfiguration jederzeit ändern. Im Falle eines Upgrades erhalten Sie für die bereits bezahlten Beträge eine Gutschrift. Eine Kündigung bereits bezahlter Perioden ist nicht möglich.'
      select_plan: 'Wählen Sie für jede Anwendung jenen Plan aus, der die Funktionen bietet, die Sie benötigen. Klicken Sie dazu auf die Box.'
      select_num_users: 'Außerdem können Sie die Anzahl ihrer Mitarbeiter einstellen, die auf Ihre Anwendungen zugreifen können sollen. <br>Ein Benutzer kostet nichts, ab dem 2. Benutzer kostet jeder Benutzer (inkl. des ersten) 1,-- Euro'
      overview_price: 'Hier sehen Sie die Summe die monatlich für Ihre ausgewählten Pläne zu bezahlen ist'
      checkout: 'Erst, wenn Sie auf das "zur Kassa"-Feld klicken und die Bezahlung erfolgreich war, tritt die neue Konfiguration in Kraft'
      start_again: 'Sie können diese Einführung jederzeit wieder starten, indem Sie auf dieses Symbol klicken'

  location:
    title: 'Ort'
    street: 'Straße'
    zip: 'PLZ'
    city: 'Stadt'
    state: 'Bundesland'
    country: 'Land'
    search: 'Ort suchen'
    delete: 'Ort löschen'
    edit: 'Ort bearbeiten'
    address: 'Adresse'
    
  locations:
    title: 'Orte'
    
  errors:
    login_failed: 'Anmeldung fehlgeschlagen!'
    email_required: 'Email Adresse erforderlich'
    email_exists: 'Die Email Adresse {{email}} ist schon registriert'
    email_unknown: 'Die Email Adresse {{email}} ist uns nicht bekannt'
    organization_exists: 'Diese Organisation ist bereits registriert'
    organization_name_required: 'Organisationsname muss vergeben werden'
    group_name_required: 'Gruppenname muss vergeben werden'
    not_an_email_address: 'Die angegebene Email Adresse ist ungültig'
    organization_required: 'Wenn Sie sich als Organisation registrieren möchtest, müssen Sie auch einen Organisationsnamen angeben. Ansonsten wähle "Privat"'
    password_required: 'Bitte wähle ein Passwort'
    password_policies_not_fulfilled: 'Das Passwort entspricht nicht den Kritierien:<br><ul><li>mindestens 6 Zeichen lang</li><li>Enthält mindestens einen Großbuchstaben</li><li>Enthält midnestens einen Kleinbuchstaben</li><li>Enthält mindestens eine Zahl oder ein Sonderzeichen</li></ul>'
    accept_terms: 'Sie müssen unsere Geschäftsbedingungen akzeptieren, um fortzufahren'
    invalid_code: 'Der angegebene Code ist falsch'
    key_invalid_or_expired: 'Der Schlüssel ist falsch oder abgelaufen. Bitte wiederhole den Vorgang'
    code_required: 'Bitte gib den Code ein, der dir in der Email zugesandt wurde'
    unkown: 'Unbekannter Fehler! Bitte kontaktiere den Support'
    cannot_suspend_yourself: 'Sie können sich nicht selbst suspendieren'
    cannot_delete_until_new_admin: 'Sie können Ihr Konto nicht löschen, bevor nicht ein neuer Administrator bestimmt wurde'
    please_remove_yourself_in_your_account_settings: 'Bitte löschen Sie Ihr eigenes Konto ausschließlich in deinen Kontoeinstellungen'
