# == Schema Information
#
# Table name: features
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :string(255)
#  due_on      :date
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  scoped_id   :integer          default(0)
#

class Feature < ActiveRecord::Base
  include TicketHolder
  include Scoped

  belongs_to :project #not optional


  attr_accessible :title, :description, :due_on

  validates :project_id, :presence => true
  validates :title, :presence => true, :uniqueness => {:scope => :project_id}

  def to_s
    title
  end

end
