class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :save_pincode, only: :show
  before_action :policy_authorize, only: %i[show edit update destroy]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @events = policy_scope(Event)
  end

  def show
    @new_comment = @event.comments.build(params[:comment])
    @new_subscription = @event.subscriptions.build(params[:subscription])
    @new_photo = @event.photos.build(params[:photo])
  end

  def new
    authorize Event
    @event = current_user.events.build
  end

  def edit
  end

  def create
    authorize Event
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: t('.created')
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: t('.destroyed')
  end

  private

  def event_params
    params.require(:event).permit(:title, :address, :datetime, :description, :pincode)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def policy_authorize
    authorize(@event)
  end

  def save_pincode
    if params[:pincode].present? && @event.pincode_valid?(params[:pincode])
      cookies.permanent["events_#{@event.id}_pincode"] = params[:pincode]
    end
  end
end
