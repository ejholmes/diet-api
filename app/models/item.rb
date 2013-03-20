class Item < ActiveRecord::Base
  include Grape::Entity::DSL

  self.per_page = 25

  # Associations
  belongs_to :feed

  # Scopes
  scope :unread, -> { where(read: false) }
  scope :read,   -> { where(read: true)  }

  class << self
    def read!
      scoped.reorder('').update_all(read: true)
    end

    def filtered(params = {})
      scope = scoped
      scope = scope.where(feed_id: params[:subscription]) if params[:subscription]
      scope
    end
  end

  def user
    feed.user
  end

  def read!
    update_attributes!(read: true)
  end

  def unread!
    update_attributes!(read: false)
  end

  def entity
    Entity.new(self)
  end

  entity :id, :title, :link, :read, :description, :pub_date do
    expose :feed, using: Feed::Entity
  end
end
