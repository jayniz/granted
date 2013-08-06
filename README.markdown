This gem lets you define arbitrary permissions on a per object level (as opposed to roles).
They are implemented purely as active record associations and hence easy to understand.
Check out this readme on how to grant read/write permissions on individual documents to
individual users. This is a [moviepilot.com](http://moviepilot.com) project licensed
[MIT](LICENSE.txt).

[![Build Status](https://travis-ci.org/jayniz/granted.png?branch=master)](https://travis-ci.org/jayniz/granted)

# Quickstart

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

# We can also do it rails association style
document.read_users << user

# Let's count all documents a user has read access to
user.readable_documents.count

# Let's count all documents a user has any access to
user.all_documents.count

# Define the things we took for granted (scuse me) above
class Document
  include Granted::ForGranted

  # Creates associations and grant/revoke methods
  grantable :read, :write, :destroy, to: User
end
```

## How does it work

When creating the migration with `rake granted:create_migration`,
this gem will add a migration to your rails app that creates a
`grants` table when you run it. This is a polymorphic model sitting
between a `grantee` (e.g. `User` and a `subject` (e.g. `Document`).
It has only one attribute, and that is the `right` that it gives the
grantee to do with the subject.

### What does this code do?

```ruby
class Document < ActiveRecord::Base
  include Granted::ForGranted

  grantable :read, :write, to: User
end
```

### It does that:

```ruby
class Granted::WriteGrant < Granted::Grant; end
class Granted::ReadGrant < Granted::Grant; end

class Document < ActiveRecord::Base
  has_many :grants,       as: :subject, class_name: 'Granted::Grant', dependent: :destroy
  has_many :write_grants, as: :subject, class_name: 'Granted::WriteGrant'
  has_many :read_grants,  as: :subject, class_name: 'Granted::ReadGrant'
  
  has_many :write_users, source: :grantee, source_type: 'User', through: :write_grants
  has_many :read_users,  source: :grantee, source_type: 'User', through: :read_grants
  has_many :all_users,   source: :grantee, source_type: 'User', through: :grants, uniq: true

  attr_accessible :write_users_attributes, :read_users_attributes
  accepts_nested_attributes_for :write_users, :read_users
end

class User < ActiveRecord::Base
  has_many :grants,       as: :grantee, class_name: 'Granted::Grant', dependent: :destroy
  has_many :write_grants, as: :grantee, class_name: 'Granted::WriteGrant'
  has_many :read_grants,  as: :grantee, class_name: 'Granted::ReadGrant'
  
  has_many :writeable_documents, source: :subject, source_type: 'Document', through: :write_grants
  has_many :readable_documents,  source: :subject, source_type: 'Document', through: :read_grants
  has_many :all_documents,       source: :subject, source_type: 'Document', through: :grants, uniq: true

  attr_accessible :writeable_documents_attributes, :readable_documents_attributes
  accepts_nested_attributes_for :writeable_documents, :readable_documents
end
```

First it creates STI classes that inherit from `Granted::Grant`, one for
each right you defined as grantable (e.g. ReadGrant, WriteGrant).
It then creates the appropriate `has_many` relations to both `User` and
`Document`, so that they can be connected with a `Grant` instance.
So you have all the access control available via normal active record
associations (reading and writing).

## Granting/revoking rights

So now that you know how querying grants/rights work, you might wonder
how you give or revoke certain access rights to a user and a document.
Consider this familiar snippet of code:

```ruby
class Document < ActiveRecord::Base
  include Granted::ForGranted

  grantable :read, :write, to: User
end
```

It does not only create the associations, it also creates the `grant`
and `revoke` methods on `User` and `Document`. They return a convenient
little object ([Grant::Granter](lib/granted/granter.rb), if you're curious).
You can grant/revoke access rights using Users or Documents as a starting
point, it's all the same:

```ruby
# Both ways to grant are identical
my_user.grant(:read).on(my_document) 
my_document.grant(:read).to(my_user)
  
# Both ways to revoke are identical
my_user.revoke(:read).on(my_document)
my_document.revoke(:read).from(my_user)

# Clever: even weird grammatic yields identic results
my_user.on(my_document).revoke(:read)
my_document.revoke(:read).from(:my_user)

# This is what the grant/revoke methods do:
Granted::Granter.new.grant(:read).on(my_document).to(my_user)
Granted::Granter.new.revoke(:read).on(my_document).from(my_user)
```

## Interedasting things

You can use arrays or single objects in `grantable` both as access rights
and grantees:

```ruby
class Document < ActiveRecord::Base
  include Granted::ForGranted
  
  grantable :read, to: [User, Editor]
  
  grantable :update, :destroy, to: [Editor]
end
```

