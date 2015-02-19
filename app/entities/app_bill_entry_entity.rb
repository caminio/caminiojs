class AppBillEntryEntity < Grape::Entity
  
  expose :id
  expose :app_name
  expose :app_icon do |e|
    if e.app_name != 'users'
      get_app_plan(e)['app_icon']
    end
  end
  expose :app_link do |e|
    if e.app_name != 'users'
      get_app_plan(e)['app_link']
    end
  end
  expose :name
  expose :total_value
  expose :tax_rate

  def get_app_plan(e)
    filename = Rails.root.join 'config', 'app_plans', "de.yml"
    app_plans = YAML.load_file filename
    app_plans['app_plans'][e.app_name][e.name]
  # rescue
  #   error! "plan #{app_name} - #{name} was not found", 500
  end

end
