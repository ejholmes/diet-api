collection @items
attributes :id, :title, :description, :guid, :link, :pub_date, :read, :feed_id
child(:feed) { attributes :title }
