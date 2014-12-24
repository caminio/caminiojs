Em.I18n.availableTranslations ||= {}
Em.I18n.availableTranslations.de ||= {}

Em.merge Em.I18n.availableTranslations.de,
  alias: 'Alias'
  username_or_email: 'Benutzername oder Email'
  password: 'Passwort'
  login: 'Anmelden'
  no_account_yet: 'Noch kein Konto?'
  forgot_your_password: 'Passwort vergessen?'
  back_to_login: 'Zurück zum Login'
  signup: 'Kostenlos Registrieren'
  register: 'Registrieren'
  username: 'Alias'
  email: 'Email Adresse'
  organization: 'Organisation'
  private: 'Privat'
  agree_policies: 'Ich bin mit den Allgemeinen Geschäftsbedingungen einverstanden'
  errors:
    email_required: 'Email Adresse erforderlich'
    not_an_email_address: 'Die angegebene Email Adresse ist ungültig'
    organization_required: 'Wenn du dich als Organisation registrieren möchtest, musst du auch einen Organisationsnamen angeben. Ansonsten wähle "Privat"'
    password_required: 'Bitte wähle ein Passwort'
    password_policies_not_fulfilled: 'Das Passwort entspricht nicht den Kritierien:<br><ul><li>mindestens 6 Zeichen lang</li><li>Enthält mindestens einen Großbuchstaben</li><li>Enthält midnestens einen Kleinbuchstaben</li><li>Enthält mindestens eine Zahl oder ein Sonderzeichen</li></ul>'
    accept_terms: 'Du musst unsere Geschäftsbedingungen akzeptieren, um fortzufahren'