class Account < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy #also destroy the user if we destroy the account.
  attr_accessible :enabled, :plan, :started_on, :blocked

  validates :user, :presence => true
  validates :plan, :presence => true

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
    plan = Plan.new(new_plan.to_s)
    current_plan.better_than?(new_plan) && available_members?(plan) && available_storage?(plan) && available_projects?(plan)
  end

  #check available resources
  def available_members?(plan = nil)
    plan ||= current_plan
    @used_members = user.projects.closedsource.collect{|p| p.memberships.count}.sum
    @plan_members = plan[:members]
    @plan_members > @used_members
  end

  def available_storage?(plan = nil)
    plan ||= current_plan
    @plan_storage = plan[:storage_gb]*1024**3
    @used_storage = user.projects.closedsource.collect do |p|
      p.tickets.includes(:comments).collect do |t|
        t.comments.includes(:assets).collect do |c|
          c.assets.collect(&:filesize)
        end
      end
    end.flatten.sum
    @plan_storage > @used_storage
  end

  def available_projects?(plan = nil)
    plan ||= current_plan
    @used_projects = user.projects.closedsource.count
    @plan_projects = plan[:projects]
    @plan_projects > @used_projects
  end

  def block!
    self.blocked = true
    self.save!
  end

  def unblock!
    self.blocked = false
    self.save!
  end
end
