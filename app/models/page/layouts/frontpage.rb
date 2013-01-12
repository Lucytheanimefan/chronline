class Page::Layouts::Frontpage < Layout

  def schema
    {
      'top_headline' => {
        'label' => 'Top Headline Story',
        'type' => 'object',
        'properties' => {
          'article' => {
            'label' => 'Article',
            'extends' => article_schema,
            'required' => true,
          },
          'breaking' => {
              'label' => 'Breaking?',
              'required' => true,
              'type' => 'boolean',
          }
        }
      },
      'slideshow' => {
        'label' => 'Slideshow Articles',
        'type'=> 'array',
        'required'=> true,
        'items'=> article_schema,
      },
      'headlines' => {
        'label' => 'Headlines',
        'type'=> 'object',
        'required'=> true,
        'properties'=> {
          'left'=> {
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          },
          'right' => {
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          }
        }
      },
      'news' => {
        'label' => 'News',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'sports' => {
        'label' => 'Sports',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'opinion' => {
        'label' => 'Opinion',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'recess' => {
        'label' => 'Recess',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'towerview' => {
        'label' => 'Towerview',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      }
    }
  end

end
