class PaginationListLinkRenderer < WillPaginate::ActionView::LinkRenderer

  # Special customization to match Bootstrap formatting

  def to_html
    html = pagination.map do |item|
      item.is_a?(Fixnum) ?
        tag(:li, page_number(item)) :
        tag(:li, send(item))
    end.join(@options[:link_separator])

    html = tag(:ul, html)

    # Don't use a container, required to inject a button
    # on the same DIV as the pagination

    # @options[:container] ? html_container(html) : html
    html
  end

  def page_number(page)
    unless page == current_page
      link(page, page, :rel => rel_value(page))
    else
      tag(:span, page, :class => 'disabled')
    end
  end

end
