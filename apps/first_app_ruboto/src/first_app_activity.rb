require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :TextView

class FirstAppActivity
  def on_create(bundle)
    super
    layout = linear_layout orientation: :horizontal do
      @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      button text: "Send", on_click_listener: proc { send_message }
    end
    self.content_view = layout
  end

  def send_message
    message = @input_box.text

    # - Class Based Approach -
    start_ruboto_activity 'DisplayMessageActivity', extras: { message: message.to_s }

    # - Block Based Approach -
    # start_ruboto_activity do
    #   @@message = message
    #   def on_create(bundle)
    #     super
    #     self.content_view = text_view text: @@message
    #   end
    # end
  end
end
