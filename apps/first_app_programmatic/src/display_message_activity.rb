# UNDER CONSTRUCTION
class DisplayMessageActivity
  TEXT_VIEW = Java::android.widget.TextView
  attr_accessor :text_view

  def onCreate(savedInstanceState)
    super
    create_text_view
    self.content_view = text_view
  end

  def create_text_view
    @text_view = TEXT_VIEW.new(self)
    # message = intent.getStringExtra('message')
    message = "Breadsticks, breadsticks!"
    text_view.textSize = 40
    text_view.text = message
  end
end
