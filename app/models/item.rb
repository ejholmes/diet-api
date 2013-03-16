class Item < ActiveRecord::Base
  autoload :Processor, 'item/processor'

  attr_accessible :description, :guid, :link, :pub_date, :title, :read

  belongs_to :feed

  default_scope order('pub_date DESC')

  def read!
    self.read = true
    self.save!
  end
end
