var en = {};

// general
en.init_application = 'Initializing application';
en.never = 'never';
en.action = 'Action';
en.total = 'Total';
en.remove = 'Remove';
en.add = 'Add';
en.yes = 'Yes';
en.no = 'No';
en.really_delete_caption = 'Really delete?';
en.really_delete = 'Really delete __name__?';

en.total = 'Total';

// errors
en.errors = en.errors || {};
en.errors.unknown = 'An unknown error occured!';

// navigation
en.back = 'Back';

// form control
en.save = 'Save';
en.create = 'Create';

// auth
en.username_email = 'Username';
en.password = 'Password';
en.login = 'Login';
en.forgot_password = 'Forgot your password?';
en.enter_email = 'Email address';
en.remember_your_email = 'If you remember your Email address, you can request a link to reset your password.';
en.request_link = 'Request link'
en.user_unknown = 'Login failed! - User unkown'
en.authentication_failed = 'Login failed!'
en.toggle_sidebar = 'Toggle sidebar'
en.logout = 'Logout'

// gears (application list)
en.gears = en.gears || {};
en.gears.paths = en.gears.paths || {};
en.gears.paths.admin = 'Administration';
en.gears.paths.dashboard = 'Dashboard';

// ADMIN module
en.navbar = en.navbar || {};
en.navbar.overview = 'Overview';
en.navbar.billing = 'Billing';
en.navbar.users_groups = 'Users';
en.navbar.domains = 'Domains';

// ADMIN users
en.users = en.users || {};
en.users.name = 'Name';
en.users.email = 'Email';
en.users.last_login = 'Last Login';
en.users.nr = 'No.';
en.users.edit = 'Edit user';
en.users.lock = 'Lock user';
en.users.delete = 'Delete user';
en.users.new = 'New user';

// ADMIN user
en.user = en.user || {};
en.user.full_name = 'Name';
en.user.full_name_exmpl = 'e.g.: Elisabeth Queen';
en.user.email = 'Email';
en.user.email_exmpl = 'e.g.: elisabeth@example.com';
en.user.password = 'Password';
en.user.password_exmpl = 'at least 6 characters';
en.user.password_res = 'Password is:';
en.user.send_link_to_set_pwd = 'Generate a link'
en.user.suggest_pwd = 'Suggest';
en.user.created = 'User has been created!';
en.user.creation_failed = 'User failed to create!';
en.user.saved = 'User has been saved';
en.user.saving_failed = 'Failed to save user';
en.user.admin = 'Administrative privileges';

// ADMIN domains
en.domains = en.domains || {};
en.domains.name = 'Name';
en.domains.nr = 'No.';
en.domains.plan = 'Current plan';
en.domains.edit = 'Edit domain';
en.domains.lock = 'Lock domain';
en.domains.delete = 'Delete domain';
en.domains.new = 'New domain';

// ADMIN domain
en.domain = en.domain || {};
en.domain.domain = 'Domain';
en.domain.name = 'Name';
en.domain.name_exmpl = 'my-organization.org';
en.domain.plan = 'Plan';
en.domain.owner = 'Domain owner';
en.domain.created = 'Domain has been created!';
en.domain.creation_failed = 'Failed to create domain!';
en.domain.saved = 'Domain has been saved';
en.domain.saving_failed = 'Failed to save domain';

// preferences
en.preferences = en.preferences || {};
en.preferences.save = 'Save preferences';
en.preferences.saved = 'Preferences have been saved';
en.preferences.saving_failed = 'Failed to save preferences';

// address defaults
en.addr = en.addr || {};
en.addr.address = 'Address';
en.addr.zip = 'Zip';
en.addr.city = 'City';
en.addr.street = 'Street';
en.addr.firstname = 'Firstname';
en.addr.lastname = 'Lastname';
en.addr.organization = 'Organization';
en.addr.email = 'Email';
en.addr.phone = 'Phone';

module.exports = en;
