require 'ruboto/widget'
ruboto_import_widgets :TextView

class DisplayMessageActivity
  def on_create(bundle)
    super
    message = intent.getExtra 'message'
    self.content_view = text_view text: message, text_size: 40
  end
end
