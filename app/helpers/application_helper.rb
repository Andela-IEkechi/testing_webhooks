module ApplicationHelper
  def flash_class(level)
    case level
    when :notice  then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error   then 'alert alert-error'
    when :alert   then 'alert alert-error'
    end
  end

  def project_name
    @project rescue ''
  end

  def progress_meter(progress=50)
    raw "<div class='meter clearfix'>
      <div class='progress-done' style='width: #{progress}%'>&nbsp;</div>
      <div class='progress-left' style='width: #{100-progress}%'>&nbsp;</div>
    </div>"
  end

  def trial_days
    days = (Date.today - current_user.created_at.to_date).to_i
  end
end
