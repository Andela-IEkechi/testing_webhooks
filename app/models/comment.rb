# NOTE: might need to remove this down the line 
# require "html_with_pygments"

class Comment < ApplicationRecord
  belongs_to :ticket
  has_many :attachments, dependent: :destroy
  belongs_to :commenter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :status

  after_save :update_tracked_changes

  # NOTE: rather use wysiwyg editor, not markdown
  # def html
  #   markdown = ::Redcarpet::Markdown.new(html_renderer, fenced_code_blocks: true)
  #   markdown.render(message || "").strip
  # end

  private

  def update_tracked_changes
    update_column(:tracked_changes, changes)
  end

  # def html_renderer
  #   ::HTMLwithPygments.new(escape_html: true, hard_wrap: true, prettify: true)
  # end

end
