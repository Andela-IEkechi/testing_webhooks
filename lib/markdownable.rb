module Markdownable
  extend ActiveSupport::Concern

  included do
    before_save :render_body
  end

  def self.to_html(markdown)
    return if markdown.blank?
    renderer = PygmentizeHTML
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    redcarpet.render(markdown).strip
  end

  private

  def render_body
    return self.rendered_body = to_html(self.body)
  end
end

