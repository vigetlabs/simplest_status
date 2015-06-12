# SimplestStatus [![Gem Version](https://badge.fury.io/rb/simplest_status.svg)](http://badge.fury.io/rb/simplest_status) [![Code Climate](https://codeclimate.com/github/vigetlabs/simplest_status/badges/gpa.svg)](https://codeclimate.com/github/vigetlabs/simplest_status) [![Test Coverage](https://codeclimate.com/github/vigetlabs/simplest_status/badges/coverage.svg)](https://codeclimate.com/github/vigetlabs/simplest_status/coverage) [![Build Status](https://travis-ci.org/vigetlabs/simplest_status.svg)]((https://travis-ci.org/vigetlabs/simplest_status))

SimplestStatus is a gem built to provide simple, convenient status functionality for Rails models.

SimplestStatus is similar to the recently introduced [`enum`](http://api.rubyonrails.org/classes/ActiveRecord/Enum.html) (debuted in Rails 4.1), but is different in that it's Rails version-agnostic, geared specifically toward `status` columns, and provides additional functionality like constant-based status lookup and label helpers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simplest_status'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simplest_status

## Usage
Add an `integer`-type `status` field to a model with `:null => false` and `:default => 0`:
```ruby
class AddStatusToPostsMigration < ActiveRecord::Migration
  def change
    add_column :posts, :status, :integer, :null => false, :default => 0
  end
end
```
Then in your model, extend `SimplestStatus` and list out your statuses:
```ruby
class Post < ActiveRecord::Base
  extend SimplestStatus

  statuses :draft, :preview, :published, :archived
end
```

This will generate a number of constants, methods, and model validations.

#### Status List
```ruby
Post.statuses # => { :draft => 0, :preview => 1, :published => 2, :archived => 3 }
```

The returned hash is a [`StatusCollection`](link) that, when iterated over, yields [`Status`](link) objects:
```
Post.statuses.first.tap do |status|
  status.name          # => :draft
  status.value         # => 0
  status.string        # => 'draft'
  status.to_hash       # => { :draft => 0 }
  status.constant_name # => 'DRAFT'
  status.label         # => 'Draft'
  status.for_select    # => ['Draft', 0]
end
```

It also provides a helper method for usage in a form select:
```ruby
Post.statuses.for_select # => [['Draft', 0], ['Preview', 1], ['Published', 2], ['Archived', 3]]
```

#### Constants
Instead of referring to status values by the underlying integer, SimplestStatus generates constants for this purpose:
```ruby
Post::DRAFT     # => 0
Post::PREVIEW   # => 1
Post::PUBLISHED # => 2
Post::ARCHIVED  # => 3
```

#### Scopes
```ruby
Post.draft
Post.preview
Post.published
Post.archived
```

#### Predicate Methods
```ruby
Post.new(:status => Post::DRAFT) do |post|
  post.draft?     # => true
  post.preview?   # => false
  post.published? # => false
  post.archived?  # => false
end
```

#### Status Mutation Methods
```ruby
Post.new(:status => Post::ARCHIVED) do
  post.draft      # status from Post::ARCHIVED to Post::DRAFT
  post.preview    # status from Post::DRAFT to Post::PREVIEW
  post.published  # status from Post::PREVIEW to Post::PUBLISHED
  post.archived   # status from Post::PUBLISHED to Post::ARCHIVED
end
```

#### Status Label Method
```ruby
Post.new(:status => Post::DRAFT).status_label     # => 'Draft'
Post.new(:status => Post::PREVIEW).status_label   # => 'Preview'
Post.new(:status => Post::PUBLISHED).status_label # => 'Published'
Post.new(:status => Post::ARCHIVED).status_label  # => 'Archived'
```

#### Status Validations
SimplestStatus will automatically add the following validations:
```ruby
validate :status, :presence => true, :inclusion => { :in => proc { statuses.values } }
```
