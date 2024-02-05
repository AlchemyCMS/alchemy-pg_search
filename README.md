[![CI](https://github.com/AlchemyCMS/alchemy-pg_search/actions/workflows/ci.yml/badge.svg)](https://github.com/AlchemyCMS/alchemy-pg_search/actions/workflows/ci.yml)

# Alchemy CMS Postgresql Fulltext Search

This gem provides full text search for projects using postgresql databases to Alchemy CMS 6.0 and above.

## Requirements

* Ruby 3.0 or newer
* Alchemy CMS 7.0 or newer
* PostgreSQL 12.x or newer

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'alchemy-pg_search', github: 'AlchemyCMS/alchemy-pg_search', branch: 'main'
```

And then execute:

```shell
$ bundle install
```

Run install script:

```shell
$ bin/rails g alchemy:pg_search:install
```

> [!NOTE]  
> The installation will generate an autogenerated column which can be configured with a language. The default
> value should work for the most languages. If you wish to change this behavior you should add
> the `Alchemy::PgSearch.config`
> into the project initializer before running the install script. (See [Configure Behavior](#configure-behavior))

## Usage

Every `Ingredient` will be indexed unless you tell Alchemy to not index a specific content.

### Disable Indexing

#### Exclude whole pages from the search index

Pass `searchable: false` to your page layout definitions and Alchemy will not index that particular page.

```yaml
# page_layouts.yml
- name: secret_page
  searchable: false
  elements:
    - secret_sauce
```

#### Exclude whole elements from the search index

Pass `searchable: false` to your element definitions and Alchemy will not index that particular element.

```yaml
# elements.yml
- name: secret_sauce
  searchable: false
  ingredients:
    - role: sauce
      type: Text
      default: 'This is my secret sauce.'
```

#### Exclude single contents from being indexed

Pass `searchable: false` to your content definitions and Alchemy will not index that particular content.

```yaml
# elements.yml
- name: secrets
  ingredients:
    - role: passwords
      type: Text
      searchable: false
      default: 'This is my secret password.'
```

The same works for `ingredients` as well

```yaml
# elements.yml
- name: secrets
  ingredients:
    - role: passwords
      type: Text
      searchable: false
      default: 'This is my secret password.'
```

### Configure Behavior

Configure the gem in an initializer. The default configurations are:

```ruby
Rails.application.config.before_initialize do
  Alchemy::PgSearch.config = {
    dictionary: 'simple',
    paginate_per: 10
  }
end
```

> [!NOTE]  
> Be aware that `before_initialize` is used. Otherwise the configuration will not have an effect, because of the load
> order in Rails.

 Configuration Name | Default Value | Description                                                                                                                                                                                                                                                                                                 
--------------------|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 dictionary         | simple        | Dictionary for the multisearch tsearch - config, which is used to find the content. The dictionary can impact the amout found documents, because it removes language specific stop words. See more in the [PostgreSQL documentation](https://www.postgresql.org/docs/current/textsearch-dictionaries.html). 
 paginate_per       | 10            | Amount of results per page. The value can be set to `nil` to disable the pagination.                                                                                                                                                                                                                        

You can also overwrite the default multisearch configuration to use other search strategies. For more information take
a look into the [PgSearch Readme](https://github.com/Casecommons/pg_search#configuring-multi-search).

```ruby
Rails.application.config.after_initialize do
  ::PgSearch.multisearch_options = {
    using: {
      tsearch: { prefix: true }
    }
  }
end
```

### Rendering search results.

In order to render the search results, you'll need a page layout that represents the search result page. Simply mark a
page layout as `searchresults: true`. The search form will pick this page as result page.

#### Search Results Page

```yaml
# page_layouts.yml
- name: search
  searchresults: true
  unique: true
```

Tip: For maximum flexibility you could also add an element that represents the search results. This lets your editors to
place additional elements (maybe a header image or additional text blocks) on the search result page.

```yaml
# page_layouts.yml
- name: search
  searchresults: true
  unique: true
  elements:
    - searchresults
  autogenerate:
    - searchresults

# elements.yml
- name: searchresults
  unique: true
  ingredients:
    - role: search_string
      hint: The is only for presentational purposes in the Alchemy preview
      default: lorem
      type: Text
```

and then use the view helpers to render the search form on the page layout partial and the search results on the element
view partial.

### View Helpers

This gem provides some helper methods that let you render the form and the search results.

* Render the search form:
  `render_search_form`

* Render the search results:
  `render_search_results`

### Customize Views

If you want to override the search form and search result views please use this generator.

```shell
$ bin/rails g alchemy:pg_search:views
```

### Translating Views

The views are fully translatable. German and english translations are already provided with this gem.

If you want add your own translation, just place a locale file into your projects `config/locales` folder.

Here is the english example:

```yaml
en:
  alchemy:

    search_form:
      placeholder: 'Search query'
      submit: 'Search'

    search_result_page:
      result_page: Page
      no_results: "Your search for '%{query}' offers no result"
      result_heading: "Your search for '%{query}'"
      result_count:
        one: 'Offers one result'
        other: 'Offers %{count} results'
```

## Upgrading

If you are upgrading from v3.0.0 please run the install generator:

```shell
$ bin/rails g alchemy:pg_search:install
$ bin/rake db:migrate
```

and reindex your database in your Rails console

```rb
# rails console
$ Alchemy::PgSearch::Search.rebuild
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
