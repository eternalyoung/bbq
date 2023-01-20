class UserContext
  attr_reader :user, :params

  def initialize(user, params = nil)
    @user = user
    @params = params
  end
end
