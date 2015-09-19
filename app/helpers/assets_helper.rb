module AssetsHelper

  def asset_url_params(options={})
    {
      :paginate => true,
      :project_id => @project && @project.id,
      :sprint_id => @sprint && @sprint.to_param,
      :feature_id => @feature && @feature.to_param,
      :query => {:payload_cont => @term}
    }.merge(options)
  end

  def asset_load_link(name, url_options={}, link_options={})
    url_options = asset_url_params(url_options)
    link_options = {
      :remote => true
    }.merge(link_options)
    link_to name, project_assets_path(url_options), link_options
  end
end
