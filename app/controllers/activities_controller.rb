class ActivitiesController < ApplicationController

  include Tubesock::Hijack

  def index
    hijack do |tubesock|
      tubesock.onopen do
        tubesock.send_data latest_activities.to_json
      end

      tubesock.onmessage do |data|
        tubesock.send_data "You said: #{data}"
      end
    end
  end

  private

  def latest_activities
    user = User.find params[:user_id]
    organization = Organization.find params[:organization_id]
    return [] unless user
    Activity.where(organization: organization).desc(:created_at).limit(5)
  end

end