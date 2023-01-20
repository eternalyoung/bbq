class EventPolicy < ApplicationPolicy
  attr_reader :user, :record

  def edit?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  def show?
    pincode_check!
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  private

  def user_is_owner?
    user.present? && (record&.user == user)
  end

  def pincode_check!
    return true if record.pincode.blank?
    return true if user_is_owner?

    if user.params[:pincode].present? && record.pincode_valid?(user.params[:pincode])
      user.params[:cookies].permanent["events_#{record.id}_pincode"] = user.params[:pincode]
    end

    pincode = user.params[:cookies].permanent["events_#{record.id}_pincode"]
    record.pincode_valid?(pincode)
  end
end
