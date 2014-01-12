var t = {};

// general
t.init_application = 'Initializing application';
t.never = 'nie';
t.action = 'Aktion';
t.total = 'Gesamt';
t.remove = 'Löschen';
t.add = 'Hinzufügen';
t.yes = 'Ja';
t.no = 'Nein';
t.nr = 'Nr.';
t.unsaved_changes_really_leave = 'Es gibt ungespeicherte Änderungen. Diese Ansicht wirklich verlassen?';
t.no_cancel = 'Nein, abbrechen';
t.really_delete_caption = 'Löschen bestätigen';
t.really_delete = '__name__ wirkliche löschen?';
t.changes_saved = 'Änderungen gespeichert';
t.created_by = 'Erstellt von';
t.created_at = 'Erstellt am';
t.updated_at = 'Aktualisert am';
t.updated_by = 'Aktualisiert von';
t.time = 'Zeit';
t.name = 'Name';

t.total = 'Total';

// errors
t.errors = t.errors || {};
t.errors.unknown = 'An unknown error occured!';

// navigation
t.back = 'Zurück';

// form control
t.save = 'Speichern';
t.create = 'Erstellen';

// auth
t.username_email = 'Email';
t.password = 'Passwort';
t.login = 'Login';
t.forgot_password = 'Passwort vergessen?';
t.enter_email = 'Email addresse';
t.remember_your_email = 'If you remember your Email address, you can request a link to reset your password.';
t.request_link = 'Request link'
t.user_unknown = 'Login failed! - User unkown'
t.authentication_failed = 'Login failed!'
t.toggle_sidebar = 'Toggle sidebar'
t.logout = 'Logout'

// gears (application list)
t.gears = t.gears || {};
t.gears.paths = t.gears.paths || {};
t.gears.paths.admin = 'Administration';
t.gears.paths.dashboard = 'Dashboard';

// ADMIN module
t.navbar = t.navbar || {};
t.navbar.overview = 'Übersicht';
t.navbar.billing = 'Abrechnung';
t.navbar.users_groups = 'BenutzerInnen';
t.navbar.domains = 'Domains';

// ADMIN users
t.users = t.users || {};
t.users.name = 'Name';
t.users.email = 'Email';
t.users.last_login = 'Letzter Zugriff';
t.users.nr = 'Nr.';
t.users.edit = 'Benutzer bearbeiten';
t.users.lock = 'Benutzer sperren';
t.users.delete = 'Benutzer löschen';
t.users.new = 'Neuer Benutzer';

// ADMIN user
t.user = t.user || {};
t.user.full_name = 'Name';
t.user.full_name_exmpl = 'e.g.: Elisabeth Queen';
t.user.email = 'Email';
t.user.email_exmpl = 'e.g.: elisabeth@example.com';
t.user.password = 'Passwort';
t.user.password_exmpl = 'mind. 6 Zeichen';
t.user.password_res = 'Passwort ist:';
t.user.send_link_to_set_pwd = 'Link generieren'
t.user.suggest_pwd = 'Vorschlagen';
t.user.created = 'Benutzer wurde angelegt!';
t.user.creation_failed = 'User failed to create!';
t.user.saved = 'User has been saved';
t.user.saving_failed = 'Failed to save user';
t.user.admin = 'Administrationsrechte';

// ADMIN domains
t.domains = t.domains || {};
t.domains.name = 'Name';
t.domains.nr = 'Nr.';
t.domains.plan = 'Current plan';
t.domains.edit = 'Edit domain';
t.domains.lock = 'Lock domain';
t.domains.delete = 'Delete domain';
t.domains.new = 'New domain';

// ADMIN domain
t.domain = t.domain || {};
t.domain.domain = 'Domain';
t.domain.name = 'Name';
t.domain.name_exmpl = 'my-organization.org';
t.domain.plan = 'Plan';
t.domain.owner = 'Domain owner';
t.domain.created = 'Domain has been created!';
t.domain.creation_failed = 'Failed to create domain!';
t.domain.saved = 'Domain has been saved';
t.domain.saving_failed = 'Failed to save domain';

// preferences
t.preferences = t.preferences || {};
t.preferences.save = 'Einstellungen speichern';
t.preferences.saved = 'Einstellungen wurden gespeichert';
t.preferences.saving_failed = 'Fehler beim Speichern der Einstellungen';

// address defaults
t.addr = t.addr || {};
t.addr.address = 'Addresse';
t.addr.zip = 'PLZ';
t.addr.city = 'Stadt';
t.addr.street = 'Straße';
t.addr.firstname = 'Vorname';
t.addr.lastname = 'Nachname';
t.addr.organization = 'Organisation';
t.addr.email = 'Email';
t.addr.phone = 'Telefon';

module.exports = t;