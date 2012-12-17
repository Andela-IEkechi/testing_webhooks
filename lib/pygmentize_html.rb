class PygmentizeHTML < Redcarpet::Render::HTML
  def block_code(code, language)
    language ||= "ruby"
    Pygmentize.process(code, language)
  end
end    