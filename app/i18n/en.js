var en = {};

// general
en.init_application = 'Initializing application';
en.never = 'never';
en.action = 'Action';

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

// ADMIN domains
en.domains = en.domains || {};
en.domains.name = 'Name';
en.domains.nr = 'No.';
en.domains.plan = 'Current plan';
en.domains.edit = 'Edit domain';
en.domains.lock = 'Lock domain';
en.domains.delete = 'Delete domain';
en.domains.new = 'New domain';

module.exports = en;
