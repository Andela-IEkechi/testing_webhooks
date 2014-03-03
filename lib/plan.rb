class Plan

  PLANS = {
    :free   => {:title => 'Free',               :price_usd => 0,  :members => 3,   :projects => 1,   :storage_gb => 1},
    :small  => {:title => 'Startups',           :price_usd => 10, :members => 10,  :projects => 5,   :storage_gb => 2},
    :medium => {:title => 'Small Company',      :price_usd => 25, :members => 50,  :projects => 15,  :storage_gb => 10, :preferred => true},
    :large  => {:title => 'Large Organization', :price_usd => 70, :members => 999, :projects => 100, :storage_gb => 50} #unlimited members = 999
  }

  def initialize(name)
    @name = name.to_sym
    @name = :free if PLANS.keys.index(name.to_sym) == nil
  end

  def to_s
    @name.to_s
  end

  def [](key)
    PLANS[@name][key.to_sym]
  end

  def upgrade_to?
    case @name.to_s
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
    case @name.to_s
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
    Plan.new(upgrade_to?)
  end

  def downgrade
    Plan.new(downgrade_to?)
  end

  def better_than?(other)
    PLANS.keys.index(@name.to_sym) > PLANS.keys.index(other.to_s.to_sym)
  end

  def worse_than?(other)
    !better_than?(other)
  end
end
