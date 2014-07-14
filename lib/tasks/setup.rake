require File::expand_path '../rake_colors', __FILE__

namespace :caminio do

  desc "setup admin account"
  task :setup => :environment do

    include Colors

    email = "manager@camin.io"
    password = "mgr"
    puts "[caminio] email #{green email} pass #{green password}"

    @user = User.new firstname: 'caminio', lastname: 'superuser', email: email, access_level: 1, password: password, password_confirmation: password
    if @user.valid? && @user.save
      puts "[caminio] successfully created user #{email}"
    else
      puts "[caminio]#{red " ERROR"} user #{red @user.email} already exists"
    end

  end

  desc "run initial install script"
  task :install do
    system 'rails g caminio:install'
  end

end
