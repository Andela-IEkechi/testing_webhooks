class Account < ActiveRecord::Base
  belongs_to :user
  attr_accessible :enabled, :plan

  validates :user_id, presence: true
  validates :plan, presence: true

  PLANS = {
    :free   => {:title => 'Free',               :price => 0,  :users => 3,  :projects => 1,  :storage_gb => 1},
    :small  => {:title => 'Startups',           :price => 10, :users => 10, :projects => 5,  :storage_gb => 2},
    :medium => {:title => 'Small Company',      :price => 25, :users => 50, :projects => 15, :storage_gb => 10, :preferred => true},
    :large  => {:title => 'Large Organization', :price => 70, :users => 999,:projects => 10, :storage_gb => 50} #unlimited users = 999
  }

  def plan_specs(value=nil)
    value ||= self.plan
    PLANS[value]
  end

  def upgrade_to?
    case self.plan
    when 'free'
      return 'small'
    when 'small'
      return 'medium'
    when 'medium'
      return 'large'
    else
      return 'large'
    end
  end

  def upgrade
    self.plan = upgrade_to?
  end

  def downgrade_to?
    case self.plan
    when 'large'
      return 'medium'
    when 'medium'
      return 'small'
    when 'small'
      return 'free'
    else
      return 'free'
    end
  end

  def downgrade
    self.plan = downgrade_to? if can_downgrade?
  end


  private
  def can_downgrade?
    #TODO we should check uses counts, projects, storage to see if a user can downgrade safely
    true
  end


end
