# NOTE: might need to remove this down the line 
# require "html_with_pygments"
require 'active_record/diff'

class Comment < ApplicationRecord
  include ActiveRecord::Diff

  diff :status, :assignee

  belongs_to :ticket
  has_many :attachments, dependent: :destroy
  belongs_to :commenter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :status

  def self.most_recent_comments
    order('created_at DESC').limit(2)
  end

  def self.comment_differences
    most_recent_comments[0].diff(most_recent_comments[1])
  end

  # NOTE: we should likely define a list of tracked attrs here, so we dont track everything
  # TRACKED_ATTRS = [:status_id, :assignee_id, :tags] #tags is not yet implemented

  # NOTE: rather use wysiwyg editor, not markdown
  # def html
  #   markdown = ::Redcarpet::Markdown.new(html_renderer, fenced_code_blocks: true)
  #   markdown.render(message || "").strip
  # end


  private

  # def html_renderer
  #   ::HTMLwithPygments.new(escape_html: true, hard_wrap: true, prettify: true)
  # end

end
