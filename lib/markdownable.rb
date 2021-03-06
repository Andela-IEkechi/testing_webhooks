module Markdownable
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_before_save_render_body
    before_save :render_body
  end

  def self.to_html(markdown)
    return if markdown.blank?
    renderer = PygmentizeHTML
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)

    html = redcarpet.render(markdown).strip

    #convert newlines inside of p tags to <br>
    html.gsub!(/(<p>.*)(\n)(.*<\/p>)/, '\1<br>\3')

    html
  end

  private

  def render_body
    unless @skip_before_save_render_body.present?
      return self.rendered_body = Markdownable.to_html(self.body)
    end
  end
end

