module Markdownable
  extend ActiveSupport::Concern

  included do
    before_save :render_body
  end

  private
  def render_body
    return if self.body.blank?
    extensions = {fenced_code_blocks: true, autolink: true, space_after_headers: true}
    redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions)
    self.rendered_body = redcarpet.render(self.body).strip
  end
end
