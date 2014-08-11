unless ( File.basename($0) == 'rake')

  app = App.find_or_create_by name: "caminio" do |a|
    a.position = 0
    a.hidden = false
    a.path = '/messages'
    a.icon = 'fa-envelope-o'
  end

  AppPlan.find_or_create_by name: "caminio Basic" do |app_plan|
    app_plan.price          = 0
    app_plan.hidden         = false
    app_plan.app_id         = app.id
    app_plan.user_quota     = 0
    app_plan.disk_quota     = 0
    app_plan.content_quota  = 0
  end

end
