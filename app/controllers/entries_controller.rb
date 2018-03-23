class EntriesController < ApplicationController

  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      MailChimp::SubscribeEntryJob.perform_later(@entry)
      render json: { success: true, entry: { id: @entry.id, state: @entry.state } }
    else
      render json: { success: false, errors: @entry.errors }
    end
  end

  def show
    @entry = Entry.find(params[:id])
    render json: { entry: { id: @entry.id, state: @entry.state, log: JSON.parse(@entry.mailchimp_error_log) } }
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:competition_id, :name, :email)
    end
end
