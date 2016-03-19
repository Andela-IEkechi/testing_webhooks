module ActionsHelper

  def action_back_to(target)
    return unless target && can?(:read, target)

    link_content = content_tag :span, :class => 'navico' do
      content_tag(:i, :class => 'icon-fixed-width icon-arrow-left') do
        #block needs to be here to pass in the class !?
      end
    end
    link_content += "back to #{target.class.name.downcase}"

    link_path = case target.class.name
    when 'Project'
      project_path(target)
    when 'Sprint'
      project_sprint_path(target.project, target)
    when 'Asset'
      project_asset_path(target.project, target)
    else '#'
    end

    content_tag :li do
      link_to link_path  do
        link_content
      end
    end
  end

  def action_edit(target)
    return unless target && can?(:edit, target) && !target.new_record?

    link_content = content_tag :span, :class => 'navico' do
      content_tag(:i, :class => 'icon-fixed-width icon-edit') do
        #block needs to be here to pass in the class !?
      end
    end
    link_content += "edit this #{target.class.name.downcase}"

    link_path = case target.class.name
    when 'Project'
      edit_project_path(target)
    when 'Sprint'
      edit_project_sprint_path(target.project, target)
    when 'Asset'
      edit_project_asset_path(target.project, target)
    when 'Ticket'
      edit_project_ticket_path(target.project, target)
    when 'Overview'
      edit_user_overview_path(target.user, target)
    else '#'
    end

    content_tag :li do
      link_to link_path  do
        link_content
      end
    end
  end

  def action_remove(target)
    return unless target && can?(:delete, target) && !target.new_record?

    link_content = content_tag :span, :class => 'navico' do
      content_tag(:i, :class => 'icon-fixed-width icon-trash') do
        #block needs to be here to pass in the class !?
      end
    end
    link_content += "remove this #{target.class.name.downcase}"

    link_path = case target.class.name
    when 'Project'
      project_path(target)
    when 'Sprint'
      project_sprint_path(target.project, target)
    when 'Asset'
      project_asset_path(target.project, target)
    when 'Ticket'
      project_ticket_path(target.project, target)
    when 'Overview'
      user_overview_path(target.user, target)
    else '#'
    end

    content_tag :li do
      link_to link_path, :method => :delete, :data => {:confirm => "Are you sure you want to delete this #{target.class.name.downcase}?"}  do
        link_content
      end
    end
  end

  def action_add(target)
    return unless target && can?(:create, target)

    link_content = content_tag :span, :class => 'navico' do
      content_tag(:i, :class => 'icon-fixed-width icon-plus') do
        #block needs to be here to pass in the class !?
      end
    end
    link_content += "add a new #{target.class.name.downcase}"

    link_path = case target.class.name
    when 'Project'
      new_project_path()
    when 'Sprint'
      new_project_sprint_path(target.project)
    when 'Asset'
      new_project_asset_path(target.project)
    when 'Ticket'
      new_project_ticket_path(target.project, :sprint_id => (@sprint rescue nil))
    when 'Overview'
      new_user_overview_path(target.user)
    else '#'
    end

    content_tag :li do
      link_to link_path  do
        link_content
      end
    end
  end

end
