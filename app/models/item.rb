class Item < ActiveRecord::Base
  autoload :Processor, 'item/processor'

  paginates_per 25

  attr_accessible :description, :guid, :link, :pub_date, :title, :read

  belongs_to :feed

  default_scope order('created_at DESC')

  scope :unread, -> { where(read: false) }
  scope :read,   -> { where(read: true)  }

  def self.read!
    scoped.map(&:read!)
  end

  def read!
    update_attributes!(read: true)
  end

  def unread!
    update_attributes!(read: false)
  end
end
