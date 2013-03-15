module Plan

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
    plan_names = PLAN.keys.collect(&:to_str)
    plan_names.index(self) <=> plan_names.index(other)
  end

  def to_s
    @name.to_s
  end

  def upgrade
    new case self.name
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

  def downgrade
    new case self.name
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

end