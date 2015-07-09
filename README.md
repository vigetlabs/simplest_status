# SimplestStatus [![Gem Version](https://badge.fury.io/rb/simplest_status.svg)](http://badge.fury.io/rb/simplest_status) [![Code Climate](https://codeclimate.com/github/vigetlabs/simplest_status/badges/gpa.svg)](https://codeclimate.com/github/vigetlabs/simplest_status) [![Test Coverage](https://codeclimate.com/github/vigetlabs/simplest_status/badges/coverage.svg)](https://codeclimate.com/github/vigetlabs/simplest_status/coverage) [![Build Status](https://travis-ci.org/vigetlabs/simplest_status.svg)]((https://travis-ci.org/vigetlabs/simplest_status))

SimplestStatus is a gem built to provide simple, convenient status functionality for Rails models.  It's designed to work with practically every version of Rails (tested as far back as 2.0.5) and will work with Ruby 1.9.3 and up.

SimplestStatus is similar to the recently introduced [`enum`](http://api.rubyonrails.org/classes/ActiveRecord/Enum.html) (debuted in Rails 4.1), but is different in that it doesn't rely on a particular version of Rails and it also provides additional functionality like constant-based status lookup, label helpers, and validations.

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
There are two ways to use SimplestStatus, through the default `statuses` method or the `simple_status` method.

The default assumes you've set up an `integer`-type `status` field with `:null => false` and `:default => 0`.  For a `simple_status`, use the same column-type and settings, just give it the name of your custom status:
```ruby
class AddStatusToPostsMigration < ActiveRecord::Migration
  def change
    add_column :posts, :status, :integer, :null => false, :default => 0
    add_column :posts, :locale, :integer, :null => false, :default => 0
  end
end
```
Then in your model, extend `SimplestStatus` and list out your statuses using `statuses` or `simple_status`:
```ruby
class Post < ActiveRecord::Base
  extend SimplestStatus

  statuses :draft, :preview, :published, :archived

  simple_status :locale, %i(english spanish russian)
end
```
This will generate a number of constants, methods, and model validations.

#### Status List
```ruby
Post.statuses # => { :draft => 0, :preview => 1, :published => 2, :archived => 3 }
Post.locales  # => { :english => 0, :spanish => 1, :russian => 2 }
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

Post.locales.first.tap do |locale|
  locale.name          # => :english
  locale.value         # => 0
  locale.string        # => 'english'
  locale.to_hash       # => { :english => 0 }
  locale.constant_name # => 'ENGLISH'
  locale.label         # => 'English'
  locale.for_select    # => ['English', 0]
end
```

It also provides a helper method for usage in a form select:
```ruby
Post.statuses.for_select # => [['Draft', 0], ['Preview', 1], ['Published', 2], ['Archived', 3]]
Post.locales.for_select  # => [['English', 0], ['Spanish', 1], ['Russian', 2]]
```

#### Constants
Instead of referring to status values by the underlying integer, SimplestStatus generates constants for this purpose:
```ruby
Post::DRAFT     # => 0
Post::PREVIEW   # => 1
Post::PUBLISHED # => 2
Post::ARCHIVED  # => 3

Post::ENGLISH   # => 0
Post::SPANISH   # => 1
Post::RUSSIAN   # => 2
```

#### Scopes
```ruby
Post.draft
Post.preview
Post.published
Post.archived

Post.english
Post.spanish
Post.russian
```

#### Predicate Methods
```ruby
Post.new(:status => Post::DRAFT) do |post|
  post.draft?     # => true
  post.preview?   # => false
  post.published? # => false
  post.archived?  # => false
end

Post.new(:locale => Post::RUSSIAN) do |post|
  post.english? # => false
  post.spanish? # => false
  post.russian? # => true
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

Post.new(:status => Post::SPANISH) do
  post.english # locale from Post::SPANISH to Post::ENGLISH
  post.spanish # locale from Post::ENGLISH to Post::SPANISH
  post.russian # locale from Post::SPANISH to Post::RUSSIAN
end
```

#### Status Label Method
```ruby
Post.new(:status => Post::DRAFT).status_label     # => 'Draft'
Post.new(:status => Post::PREVIEW).status_label   # => 'Preview'
Post.new(:status => Post::PUBLISHED).status_label # => 'Published'
Post.new(:status => Post::ARCHIVED).status_label  # => 'Archived'

Post.new(:locale => Post::ENGLISH).locale_label # => 'English'
Post.new(:locale => Post::SPANISH).locale_label # => 'Spanish'
Post.new(:locale => Post::RUSSIAN).locale_label # => 'Russian'
```

#### Status Validations
SimplestStatus will automatically add the following validations:
```ruby
validates :status, :presence => true, :inclusion => { :in => statuses.values }
validates :locale, :presence => true, :inclusion => { :in => locales.values }
```
