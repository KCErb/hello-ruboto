class FirstAppActivity
  LAYOUT = Java::android.widget.LinearLayout
  EDIT_TEXT = Java::android.widget.EditText
  BUTTON = Java::android.widget.Button
  TOAST = Java::android.widget.Toast
  INTENT = Java::android.content.Intent

  attr_accessor :layout, :edit_text, :button

  def on_create(bundle)
    super
    create_layout
    create_edit_text
    create_button
    self.content_view = layout
  end

  def create_layout
    @layout = LAYOUT.new(self)
  end

  def create_edit_text
    @edit_text = EDIT_TEXT.new(self)
    edit_text.hint = 'Enter Some Text!'
    layout.add_view edit_text
    layout_params = edit_text.layout_params
    layout_params.weight = 1
  end

  def create_button
    @button = BUTTON.new(self)
    button.text = 'Send'
    layout.add_view button
    button.set_on_click_listener { howdy }
  end

  def howdy
    message = 'Howdy'
    duration = TOAST::LENGTH_SHORT
    toast = TOAST.make_text(self, message, duration)
    toast.show
  end
end
