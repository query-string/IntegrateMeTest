class Api::V1::MailchimpController < ApplicationController
  def proxy
    api = Gibbon::Request.new(api_key: params[:api_key])

    begin
      lists = api.lists.retrieve.body['lists'].map { |l| { id: l['id'], name: l['name'] } }
      render json: { success: true, lists: lists }, status: :ok
    rescue
      render json: { success: false }, status: :bad_request
    end
  end
end