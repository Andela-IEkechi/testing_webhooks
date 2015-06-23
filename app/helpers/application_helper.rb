module ApplicationHelper
  def flash_class(level)
    case level
    when :notice    then 'alert alert-info'
    when :success   then 'alert alert-success'
    when :error     then 'alert alert-error'
    when :alert     then 'alert alert-error'
    when :account_upgrade_notice  then 'alert alert-info account_upgrade_notice'
    when :account_downgrade_notice  then 'alert alert-info account_downgrade_notice'
    when :account_downgrade_alert   then 'alert alert-error account_downgrade_alert'
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
end
