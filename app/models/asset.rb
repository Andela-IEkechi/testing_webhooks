class Asset < ActiveRecord::Base
  include Scoped

  belongs_to :project
  belongs_to :sprint
  belongs_to :comment

  mount_uploader  :payload, FileUploader
  attr_accessible :payload

  validates :project, :presence => true
  #NOTE: DO NOT validate this, it prevents us from saving new assest on new comments (on new tickets implicitly)
  #validates :comment_id, :presence => true

  scope :for_sprint, lambda{|sprint_id| {:conditions => {:sprint_id => sprint_id}}}
  scope :for_comment, lambda{|comment_id| {:conditions => {:comment_id => comment_id}}}
  scope :general, lambda{{:conditions => {:comment_id => nil}}}
  scope :unassigned, lambda{{:conditions => {:comment_id => nil, :sprint_id => nil, :feature_id => nil}}}

  scope :search, lambda{ |s|
    {
      :conditions => [
        "LOWER(assets.payload) LIKE :search",
        {:search => "%#{s.to_s.downcase}%"}
      ]
    }
  }

  attr_accessible :project_id, :sprint_id, :comment_id

  before_save :verify_payload

  def name
    payload.file.filename rescue payload
  end

  def image?
    payload.file.content_type.include? 'image' rescue false
  end

  def to_s
    name
  end

  def verify_payload
    self.payload_size = (payload.file.size rescue 0)
  end
end
