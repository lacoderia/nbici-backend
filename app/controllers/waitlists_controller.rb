class WaitlistsController < ApiController 
  include ErrorSerializer

  before_action :authenticate_user!

  def book 
    begin
      @waitlist = Waitlist.create_and_send_email(params[:schedule_id], current_user)
      render json: @waitlist
    rescue Exception => e
      waitlist = Waitlist.new
      waitlist.errors.add(:error_creating_waitlist, e.message)
      render json: ErrorSerializer.serialize(waitlist.errors), status: 500
    end
  end
  
end
