# Reader

The best RSS feed aggregator. Ever. Period.

![](https://dl.dropbox.com/u/1906634/Captured/Reader.png)

## API

### GET /user/subscriptions

List subscriptions.

### POST /user/subscriptions?url=url

Subscribe to a feed.

### DELETE /user/subscriptions/:id

Unsubscribe from a feed.

### PUT /items/:id/read

Mark the item as read.

### DELETE /items/:id/read

Mark the item as unread.
