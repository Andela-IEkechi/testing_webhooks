class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :enabled, :plan

  PLANS = {
    "free"         => {:title => 'Free',         :price => 10, :user => 3, :projects => 10},
    "startup"      => {:title => 'Startup',      :price => 10, :user => 3, :projects => 10},
    "company"      => {:title => 'Company',      :price => 10, :user => 3, :projects => 10},
    "organization" => {:title => 'Organization', :price => 10, :user => 3, :projects => 10}
  }

  def plan_specs
    PLANS[plan]
  end
end
