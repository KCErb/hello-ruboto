require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class NewDemoActivity
  def on_create(bundle)
    super
    set_title "My First App"
    self.content_view = 
      linear_layout orientation: :horizontal do
        @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send", on_click_listener: proc { send_message(@input_box.text) }
      end
  end

  def send_message(text)
    ruboto_import_widgets :TextView

    start_ruboto_activity do
      @@text = text
      def on_create(bundle)
        super
        set_title "Hello Ruboto!"
        self.content_view =
          text_view text: @@text
      end
    end
  end
end

