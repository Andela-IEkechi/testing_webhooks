module Markdownable
  extend ActiveSupport::Concern

  included do
    before_save :render_body
  end

  private
  def render_body
    return if self.body.blank?
    renderer = PygmentizeHTML
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.rendered_body = redcarpet.render(self.body).strip
  end
end

