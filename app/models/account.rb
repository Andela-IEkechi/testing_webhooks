class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :enabled, :plan

  validates :user_id, presence: true
  validates :plan, presence: true

  PLANS = {
    "free"   => {:title => 'Free',               :price => 0,  :user => 3,  :projects => 1,  :storage_gb => 1},
    "small"  => {:title => 'Startup',            :price => 10, :user => 10, :projects => 5,  :storage_gb => 2},
    "medium" => {:title => 'Small Company',      :price => 25, :user => 50, :projects => 15, :storage_gb => 10},
    "large"  => {:title => 'Large Organization', :price => 70, :user => 999,:projects => 10, :storage_gb => 50} #unlimited users = 999
  }

  def plan_specs(value=nil)
    value ||= self.plan
    PLANS[value]
  end

  def upgrade(new_plan=nil)
    return unless plan_specs(new_plan)
    case self.plan
    when 'free'
      self.plan = 'small'
    when 'small'
      self.plan = 'medium'
    when 'medium'
      self.plan = 'large'
    else
      self.plan = 'large'
    end
  end

  def downgrade(new_plan=nil)
    if plan_specs(new_plan) && can_downgrade?(new_plan)
      self.plan = new_plan
    case self.plan
    when 'large'
      self.plan = 'medium'
    when 'medium'
      self.plan = 'small'
    when 'small'
      self.plan = 'free'
    else
      self.plan = 'free'
    end
  end

  private
  def can_downgrade?(new_plan)
    #TODO we should check uses counts, projects, storage to see if a user can downgrade safely
    false
  end


end
