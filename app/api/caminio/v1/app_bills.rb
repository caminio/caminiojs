module Caminio

  module V1

    class AppBills < Grape::API

      default_format :json
      helpers Caminio::AuthHelper
      helpers Caminio::UsersHelper

      before { authenticate! }

      helpers do
        def get_app_plan(app_name,name)
          filename = Rails.root.join 'config', 'app_plans', "#{current_user.locale}.yml"
          app_plans = YAML.load_file filename
          app_plans['app_plans'][app_name][name]
        # rescue
        #   error! "plan #{app_name} - #{name} was not found", 500
        end
      end

      params do
        requires :plans, type: Array do
          requires :name
          requires :app_name
        end
        requires :users, type: Integer
      end
      post do
        require_admin!
        app_bill = AppBill.new organization: current_organization, paid_at: Time.now # TODO: CHANGE THIS !!!
        params.plans.each do |plan|
          orig_plan = get_app_plan plan['app_name'], plan['name']
          app_bill.app_bill_entries.build app_name: plan['app_name'],
                                          name: plan['name'], 
                                          total_value: orig_plan['total_value'],
                                          tax_rate: Rails.configuration.caminio.default_tax_rate || 20
        end
        if params.users > 1
          app_bill.app_bill_entries.build app_name: 'users', 
                                          name: params.users, 
                                          total_value: params.users * 100,
                                          tax_rate: Rails.configuration.caminio.default_tax_rate || 20
        end
        return error!('FailedToSave',500) unless app_bill.save
        present :app_bill, app_bill, with: AppBillEntity
        present :app_bill_entries, app_bill.app_bill_entries, with: AppBillEntryEntity
      end

    end
  end
end