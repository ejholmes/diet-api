class Item < ActiveRecord::Base
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
      scope = scope.where(feed_id: params[:feed_id]) if params[:feed_id]
      scope = scope.unread if params[:unread] && params[:unread] == 1
      scope
    end
  end

  def read!
    update_attributes!(read: true)
  end

  def unread!
    update_attributes!(read: false)
  end
end
