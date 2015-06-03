require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class FirstAppActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout :orientation => :vertical do
      end
  end
end
