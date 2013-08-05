Install with bundler:

    gem 'granted'

Add to Rakefile:

    require 'granted/tasks'

And then:

```ruby

  # Let's grant a user access to a document
  user.grant(:read).on(document)

  # Let's revoke a user's write access to a document
  user.revoke(:grant).from(document)

  # Let's count all documents a user has read access to
  user.readable_documents.count

  # Let's count all documents a user has any access to
  user.all_documents.count

  # Define the things we took for granted (scuse me) above
  class Document
    include Granted::ForGranted

    # The following command will add `grant` and `revoke` methods
    # to `User` and `Document` so you can change permissions.
    # 
    # It also adds `User#readable_documents` and 
    # `Document#read_users` as `has_many` so you can do your 
    # thing
    grantable :read, :write, :destroy, to: User
  end
```
