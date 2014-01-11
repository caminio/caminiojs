var t = {};

// general
t.init_application = 'Initializing application';
t.never = 'never';
t.action = 'Action';
t.total = 'Total';
t.remove = 'Remove';
t.add = 'Add';
t.yes = 'Yes';
t.no = 'No';
t.unsaved_changes_really_leave = 'You have unsaved changes. Are you sure you want to leave this view?';
t.no_cancel = 'No, cancel';
t.really_delete_caption = 'Really delete?';
t.really_delete = 'Really delete __name__?';
t.changes_saved = 'Changes saved';
t.created_by = 'Created by';
t.updated_by = 'Updated by';
t.time = 'Zeit';
t.total = 'Total';

// errors
t.errors = t.errors || {};
t.errors.unknown = 'An unknown error occured!';

// navigation
t.back = 'Back';

// form control
t.save = 'Save';
t.create = 'Create';

// auth
t.username_email = 'Username';
t.password = 'Password';
t.login = 'Login';
t.forgot_password = 'Forgot your password?';
t.enter_email = 'Email address';
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
t.navbar.overview = 'Overview';
t.navbar.billing = 'Billing';
t.navbar.users_groups = 'Users';
t.navbar.domains = 'Domains';

// ADMIN users
t.users = t.users || {};
t.users.name = 'Name';
t.users.email = 'Email';
t.users.last_login = 'Last Login';
t.users.nr = 'No.';
t.users.edit = 'Edit user';
t.users.lock = 'Lock user';
t.users.delete = 'Delete user';
t.users.new = 'New user';

// ADMIN user
t.user = t.user || {};
t.user.full_name = 'Name';
t.user.full_name_exmpl = 'e.g.: Elisabeth Queen';
t.user.email = 'Email';
t.user.email_exmpl = 'e.g.: elisabeth@example.com';
t.user.password = 'Password';
t.user.password_exmpl = 'at least 6 characters';
t.user.password_res = 'Password is:';
t.user.send_link_to_set_pwd = 'Generate a link'
t.user.suggest_pwd = 'Suggest';
t.user.created = 'User has been created!';
t.user.creation_failed = 'User failed to create!';
t.user.saved = 'User has been saved';
t.user.saving_failed = 'Failed to save user';
t.user.admin = 'Administrative privileges';

// ADMIN domains
t.domains = t.domains || {};
t.domains.name = 'Name';
t.domains.nr = 'No.';
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
t.preferences.save = 'Save preferences';
t.preferences.saved = 'Preferences have been saved';
t.preferences.saving_failed = 'Failed to save preferences';

// address defaults
t.addr = t.addr || {};
t.addr.address = 'Address';
t.addr.zip = 'Zip';
t.addr.city = 'City';
t.addr.street = 'Street';
t.addr.firstname = 'Firstname';
t.addr.lastname = 'Lastname';
t.addr.organization = 'Organization';
t.addr.email = 'Email';
t.addr.phone = 'Phone';

module.exports = t;