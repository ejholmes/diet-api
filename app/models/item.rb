class Item < ActiveRecord::Base
  self.per_page = 25

  belongs_to :feed

  default_scope order('created_at DESC')

  scope :unread, -> { where(read: false) }
  scope :read,   -> { where(read: true)  }

  class << self
    # TODO: Make this more efficient.
    def read!
      scoped.update_all(read: true)
    end

    def filtered(params = {})
      scope = scoped
      scope = scope.where(feed_id: params[:subscription]) if params[:subscription]
      scope
    end
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

  class Entity < Grape::Entity
    expose :id
    expose :title
    expose :link
    expose :read
    expose :description
    expose :pub_date
    expose :feed, using: Feed::Entity
  end
end
