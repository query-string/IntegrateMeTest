class Api::V1::CompetitionsController < ApplicationController
    def update
      Competition.find(params[:id]).update(competition_params)
    end

    private

    def competition_params
      params.permit(:mailchimp_key, :mailchimp_list_id)
    end
  end