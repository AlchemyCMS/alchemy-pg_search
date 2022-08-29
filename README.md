[![CI](https://github.com/AlchemyCMS/alchemy-pg_search/actions/workflows/ci.yml/badge.svg)](https://github.com/AlchemyCMS/alchemy-pg_search/actions/workflows/ci.yml)

# Alchemy CMS Postgresql Fulltext Search

This gem provides full text search for projects using postgresql databases to Alchemy CMS 6.0 and above.

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

## Usage

Every `EssenceText`, `EssenceRichtext` and `EssencePicture` will be indexed unless you tell Alchemy to not index a specific content.

### Disable Indexing

Simply pass `searchable: false` to your content definitions and Alchemy will not index results from that particular content.

```yaml
# elements.yml
- name: secrets
  contents:
  - name: passwords
    type: EssenceText
    searchable: false
    default: 'This is my secret password.'
```

### Rendering search results.

In order to render the search results, you'll need a page layout that represents the search result page. Simply mark a page layout as `searchresults: true`. The search form will pick this page as result page.

#### Search Results Page

```yaml
# page_layouts.yml
- name: search
  searchresults: true
  unique: true
```

Tip: For maximum flexibility you could also add an element that represents the search results. This lets your editors to place additional elements (maybe a header image or additional text blocks) on the search result page.

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
```

and then use the view helpers to render the search form on the page layout partial and the search results on the element view partial.

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

If you are upgrading from an old Alchemy < 4.0 based project that uses the ferret based full text search, please run this handy generator:

```shell
$ bin/rails g alchemy:pg_search:upgrade
$ bin/rake db:migrate
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
