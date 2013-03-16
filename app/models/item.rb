class Item < ActiveRecord::Base
  autoload :Creator, 'item/creator'

  attr_accessible :description, :guid, :link, :pub_date, :title, :read

  belongs_to :feed

  default_scope order('created_at DESC, pub_date DESC')

  def read!
    self.read = true
    self.save!
  end
end
