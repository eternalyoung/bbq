class NotifySubscribersCommentJob < ApplicationJob
  queue_as :default

  def perform(event, comment)
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email]).uniq
    all_emails.delete(comment.user.email) if comment.user.present?
    all_emails.each do |mail|
      EventMailer.comment(event, comment, mail).deliver_now
    end
  end
end
