class CreateAssetVersions < ActiveRecord::Migration
  def up
    return if Rails.env.development?
    Comment::Asset.all.each do |asset|
      asset.payload.recreate_versions! if asset.image?
    end
  end

  def down
  end
end
