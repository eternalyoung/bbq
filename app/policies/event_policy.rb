class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user_is_owner?
  end

  def edit?
    update?
  end

  def destroy?
    user_is_owner?
  end

  def show?
    pincode_allowed?
  end

  private

  def user_is_owner?
    user.present? && (record&.user == user)
  end

  def pincode_allowed?
    return true if record.pincode.blank?
    return true if user_is_owner?

    pincode = params[:cookies].permanent["events_#{record.id}_pincode"]
    record.pincode_valid?(pincode)
  end
end
