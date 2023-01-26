# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :params, :record

  delegate :user, to: :@context
  delegate :params, to: :@context

  def initialize(context, record)
    @context = context
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(context, scope)
      @context = context
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :context, :scope
  end
end
