# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  plan       :string(255)      default("free")
#  enabled    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Account < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy #also destroy the user if we destroy the account.
  attr_accessible :enabled, :plan

  validates :user_id, presence: true
  validates :plan, presence: true

  def current_plan
    Plan.new(plan)
  end

  def upgrade
    self.plan = Plan.new(self.plan).upgrade
  end

  def downgrade
    self.plan = Plan.new(self.plan).downgrade
  end

  def change_to(new_plan)
    self.plan = Plan.new(new_plan).to_s
  end

  def can_downgrade?(new_plan)
    #TODO we should check uses counts, projects, storage to see if a user can downgrade safely
    return true if current_plan.worse_than?(new_plan) #upgrades dont count, please die in a fire
    true
  end


end
