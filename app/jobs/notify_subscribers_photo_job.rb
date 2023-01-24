class NotifySubscribersPhotoJob < ApplicationJob
  queue_as :default

  def perform(event, photo)
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [photo.user.email]).uniq

    all_emails.each do |mail|
      EventMailer.photo(event, photo, mail).deliver_now
    end
  end
end
