Rails::Application::Configuration.class_eval do
  def caminio
    @caminio ||= ActiveSupport::OrderedOptions.new
  end
end