require 'set'

class Article::EmbeddedMedia

  def initialize(body)
    @body = body
    self.protected_methods.each do |op|
      send op
    end
  end

  def to_s
    @body
  end

  protected

  def render_images()
    ids = @body.scan(/{{Image:([0-9]*)}} ?/).to_set.to_a
    unless ids.empty?
      images_by_id = Hash[ Image.find_all_by_id(ids).map{ |img| [img.id, img] } ]
      # chomps space after tag
      @body.gsub!(/{{Image:([0-9]*)}} ?/) do |id|
        if images_by_id.has_key? $1.to_i
          %Q(<span class="embedded-image">
              <img src="#{images_by_id[$1.to_i].original.url(:thumb_rect)}" />
            </span>
          )
        else
          ""
        end
      end
    end
  end

end
