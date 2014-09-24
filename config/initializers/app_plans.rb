# unless ( File.basename($0) == 'rake')
#
#   app = App.find_or_create_by name: "caminio" 
#   app.update(
#     position: 0,
#     hidden: false,
#     path: '/',
#     icon: 'fa-home'
#   )
#
#   AppPlan.find_or_create_by name: "caminio Basic" do |app_plan|
#     app_plan.price          = 0
#     app_plan.hidden         = false
#     app_plan.app_id         = app.id
#     app_plan.user_quota     = 0
#     app_plan.disk_quota     = 0
#     app_plan.content_quota  = 0
#   end
#
# end
