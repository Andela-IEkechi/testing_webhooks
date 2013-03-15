class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :enabled, :plan

  validates :user_id, presence: true
  validates :plan, presence: true

  def plan_specs(value=nil)
    value ||= self.plan
    PLANS[value]
  end

  def upgrade
    self.plan = Plan.new(self.plan).upgrade
  end

  def downgrade
    self.plan = Plan.new(self.plan).downgrade
  end

  private
  def can_downgrade?
    #TODO we should check uses counts, projects, storage to see if a user can downgrade safely
    true
  end


end
