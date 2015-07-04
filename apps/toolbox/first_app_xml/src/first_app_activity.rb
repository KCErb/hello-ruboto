# Working on android style intents
require 'ruboto/package'

class FirstAppActivity
  TOAST = Java::android.widget.Toast

  def on_create(bundle)
    super
    self.content_view = R.layout.first_layout
    button = find_view_by_id(R.id.send_button)
    button.set_on_click_listener { howdy }
  end

  def howdy
    message = 'Howdy'
    duration = TOAST::LENGTH_SHORT
    toast = TOAST.make_text(self, message, duration)
    toast.show
  end
end
