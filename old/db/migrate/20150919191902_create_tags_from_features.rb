class CreateTagsFromFeatures < ActiveRecord::Migration
  def up
    Ticket.includes(:comments).select(:id).find_each do |ticket|
      p "re-tagging ticket ##{ticket.id}"
      comment = ticket.comments.last
      if comment.feature.present?
        new_tags = comment.feature.title.gsub(/[^\w\s]/,'').split().uniq + comment.tag_list
        comment.tag_list = new_tags.flatten.uniq
        comment.save
      end
    end

  end

  def down
    Ticket.includes(:comments).select(:id).find_each do |ticket|
      p "re-tagging ticket ##{ticket.id}"
      comment = ticket.comments.last
      if comment.feature.present?
        new_tags = comment.tag_list - comment.feature.title.gsub(/[^\w\s]/,'').split().uniq
        comment.tag_list = new_tags.flatten.uniq
        comment.save
      end
    end
  end
end
