class Account < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy #also destroy the user if we destroy the account.
  attr_accessible :enabled, :plan

  validates :user_id, presence: true
  validates :plan, presence: true

  def current_plan
    Plan.new(self.plan.to_s)
  end

  def upgrade
    self.plan = self.current_plan.upgrade.to_s
  end

  def downgrade
    self.plan = self.current_plan.downgrade.to_s
  end

  def change_to(new_plan)
    self.plan = Plan.new(new_plan).to_s
  end

  def can_downgrade?(new_plan)
    return true if current_plan.worse_than?(new_plan) #upgrades dont count, please die in a fire
    available_members?(new_plan) && available_storage?(new_plan) && available_projects?(new_plan)
  end

  def available_members?(plan = nil)
    plan ||= current_plan
    @used_members = Project.closedsource.find_all_by_user_id(user.id).collect{|p| p.memberships.count}.sum
    @plan_members = plan[:members]
    @plan_members > @used_members
  end

  def available_storage?(plan = nil)
    plan ||= current_plan
    @plan_storage = plan[:storage_gb]*1024**3
    @used_storage = Project.closedsource.find_all_by_user_id(user.id).collect{|p| p.tickets.includes(:comments).collect{ |t| t.comments.includes(:assets).collect{ |c| c.assets.collect(&:filesize)} }}.flatten.sum
    @plan_storage > @used_storage
  end

  def available_projects?(plan = nil)
    plan ||= current_plan
    @used_projects = Project.closedsource.find_all_by_user_id(user.id).count
    @plan_projects = plan[:projects]
    @plan_projects > @used_projects
  end

end
