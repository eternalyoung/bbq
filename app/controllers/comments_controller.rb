class CommentsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      NotifySubscribersCommentJob.perform_later(@event, @new_comment)
      redirect_to @event, notice: t('.created')
    else
      render 'events/show', alert: t('errors.comments.error')
    end
  end

  def destroy
    message = { notice: t('.destroyed') }

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = { alert: t('errors.comments.error') }
    end

    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end
end
