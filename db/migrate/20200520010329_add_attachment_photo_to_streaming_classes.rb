class AddAttachmentPhotoToStreamingClasses < ActiveRecord::Migration
  def self.up
    change_table :streaming_classes do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :streaming_classes, :photo
  end
end
