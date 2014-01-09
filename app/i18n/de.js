var de = {};

// general
de.init_application = 'Initializing application';
de.never = 'never';
de.action = 'Action';
de.total = 'Total';
de.remove = 'Remove';
de.add = 'Add';
de.yes = 'Yes';
de.no = 'No';
de.really_delete_caption = 'Really delete?';
de.really_delete = 'Really delete __name__?';

de.total = 'Total';

// errors
de.errors = de.errors || {};
de.errors.unknown = 'An unknown error occured!';

// navigation
de.back = 'Back';

// form control
de.save = 'Save';
de.create = 'Create';

// auth
de.username_email = 'Username';
de.password = 'Password';
de.login = 'Login';
de.forgot_password = 'Forgot your password?';
de.enter_email = 'Email address';
de.remember_your_email = 'If you remember your Email address, you can request a link to reset your password.';
de.request_link = 'Request link'
de.user_unknown = 'Login failed! - User unkown'
de.authentication_failed = 'Login failed!'
de.toggle_sidebar = 'Toggle sidebar'
de.logout = 'Logout'

// gears (application list)
de.gears = de.gears || {};
de.gears.paths = de.gears.paths || {};
de.gears.paths.admin = 'Administration';
de.gears.paths.dashboard = 'Dashboard';

// ADMIN module
de.navbar = de.navbar || {};
de.navbar.overview = 'Overview';
de.navbar.billing = 'Billing';
de.navbar.users_groups = 'Users';
de.navbar.domains = 'Domains';

// ADMIN users
de.users = de.users || {};
de.users.name = 'Name';
de.users.email = 'Email';
de.users.last_login = 'Last Login';
de.users.nr = 'No.';
de.users.edit = 'Edit user';
de.users.lock = 'Lock user';
de.users.delete = 'Delete user';
de.users.new = 'New user';

// ADMIN user
de.user = de.user || {};
de.user.full_name = 'Name';
de.user.full_name_exmpl = 'e.g.: Elisabeth Queen';
de.user.email = 'Email';
de.user.email_exmpl = 'e.g.: elisabeth@example.com';
de.user.password = 'Password';
de.user.password_exmpl = 'at least 6 characters';
de.user.password_res = 'Password is:';
de.user.send_link_to_set_pwd = 'Generate a link'
de.user.suggest_pwd = 'Suggest';
de.user.created = 'User has been created!';
de.user.creation_failed = 'User failed to create!';
de.user.saved = 'User has been saved';
de.user.saving_failed = 'Failed to save user';
de.user.admin = 'Administrative privileges';

// ADMIN domains
de.domains = de.domains || {};
de.domains.name = 'Name';
de.domains.nr = 'No.';
de.domains.plan = 'Current plan';
de.domains.edit = 'Edit domain';
de.domains.lock = 'Lock domain';
de.domains.delete = 'Delete domain';
de.domains.new = 'New domain';

// ADMIN domain
de.domain = de.domain || {};
de.domain.domain = 'Domain';
de.domain.name = 'Name';
de.domain.name_exmpl = 'my-organization.org';
de.domain.plan = 'Plan';
de.domain.owner = 'Domain owner';
de.domain.created = 'Domain has been created!';
de.domain.creation_failed = 'Failed to create domain!';
de.domain.saved = 'Domain has been saved';
de.domain.saving_failed = 'Failed to save domain';

// preferences
de.preferences = de.preferences || {};
de.preferences.save = 'Save preferences';
de.preferences.saved = 'Preferences have been saved';
de.preferences.saving_failed = 'Failed to save preferences';

// address defaults
de.addr = de.addr || {};
de.addr.address = 'Address';
de.addr.zip = 'Zip';
de.addr.city = 'City';
de.addr.street = 'Street';
de.addr.firstname = 'Firstname';
de.addr.lastname = 'Lastname';
de.addr.organization = 'Organization';
de.addr.email = 'Email';
de.addr.phone = 'Phone';

module.exports = de;
