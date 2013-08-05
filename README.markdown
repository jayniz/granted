Quickstart:
===========

Install with bundler:

    gem 'granted'

Add to Rakefile:

    require 'granted/tasks'

Create the migration for the grants table:

    rake granted:create_migration
    rake db:migrate

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

How does it work
=================

Relations
---------

When creating the migration with `rake granted:create_migration`,
this gem will add a migration to your rails app that creates a
`grants` table when you run it.

This is a polymorphic model sitting between a `grantee` and a
`subject`. It has only one attribute, and that is the `right` that
it gives the grantee to do with the subject.

The following code:

```ruby
class Document < ActiveRecord::Base
  include Granted::ForGranted

  grantable :read, :write, to: User
end
```

creates the appropriate `has_many` relations to both `User` and
`Document`, so that they can be connected with a `Grant` instance.
It's really just a short way of writing this:

```ruby
class Document < ActiveRecord::Base
  has_many :grants, as: :subject, class_name: 'Granted::Grant',
dependent: :destroy
   has_many :write_users, source: :grantee, source_type: 'User', through: :grants, conditions: {'grants.right' => :write}
   has_many :read_users, source: :grantee, source_type: 'User', through: :grants, conditions: {'grants.right' => :read}
   has_many :all_users, source: :grantee, source_type: 'User', through: :grants, uniq: true
end

class User < ActiveRecord::Base
  has_many :grants, as: :grantee, class_name: 'Granted::Grant', dependent: :destroy
  has_many :writeable_documents, source: :subject, source_type: 'Document', through: :grants, conditions: {'grants.right' => :write}
  has_many :readable_documents, source: :subject, source_type: 'Document', through: :grants, conditions: {'grants.right' => :read}
  has_many :all_documents, source: :subject, source_type: Document, through: :grants, uniq: true
end
```

Granting/revoking rights
------------------------



