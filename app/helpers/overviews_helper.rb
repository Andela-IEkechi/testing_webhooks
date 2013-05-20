module OverviewsHelper

  def cancel_button
    link_to 'cancel', '#cancel', :class => 'btn cancel-btn', :title => 'back', :onclick => 'javascript:history.go(-1);'
  end
end
