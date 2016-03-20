class Asset < ApplicationRecord
  belongs_to :assetable, polymorphic: true

  # TODO attach payload
end
