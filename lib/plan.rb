class Plan

  PLANS = {
    :free   => {:title => 'Free',               :price => 0,  :users => 3,  :projects => 1,  :storage_gb => 1},
    :small  => {:title => 'Startups',           :price => 10, :users => 10, :projects => 5,  :storage_gb => 2},
    :medium => {:title => 'Small Company',      :price => 25, :users => 50, :projects => 15, :storage_gb => 10, :preferred => true},
    :large  => {:title => 'Large Organization', :price => 70, :users => 999,:projects => 100, :storage_gb => 50} #unlimited users = 999
  }

  def initialize(name)
    @name = name
  end

  def <=>(other)
    plan_names = PLANS.keys.collect(&:to_str)
    plan_names.index(self) <=> plan_names.index(other)
  end

  def to_s
    @name.to_s
  end

  def upgrade_to?
    case self.name
    when 'free'
      'small'
    when 'small'
      'medium'
    when 'medium'
      'large'
    else
      'large'
    end
  end

  def downgrade_to?
    case self.name
    when 'large'
      'medium'
    when 'medium'
      'small'
    when 'small'
      'free'
    else
      'free'
    end
  end

  def upgrade
    new(upgrade_to?)
  end

  def downgrade
    new(downgrade_to?)
  end

  def better_than?(other)
    PLANS.keys.index(self) > PLANS.keys.index(other)
  end

  def worse_than?(other)
    !better_than?(other)
  end
end