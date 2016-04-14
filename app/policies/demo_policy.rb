class DemoPolicy < ApplicationPolicy
  def deprovision?
    logged_in?
  end
end
