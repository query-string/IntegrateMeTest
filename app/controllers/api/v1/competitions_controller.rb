class Api::V1::CompetitionsController < ApplicationController
    def update
      Competition.find(params[:id]).update(competition_params)
      head :ok
    end

    private

    def competition_params
      params.require(:competition).permit(:mailchimp_list_id, :mailchimp_api_key)
    end
  end