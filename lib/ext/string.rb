class String
  def integer?
    (self =~ /\A[+-]?\d+\Z/) == 0
  end
end