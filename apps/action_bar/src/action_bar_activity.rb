require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :LinearLayout, :TextView, :Button
java_import "android.graphics.drawable.ColorDrawable"
java_import "android.graphics.Color"


class ActionBarActivity
  def onCreate(bundle)
    super
    get_window.request_feature(android.view.Window::FEATURE_ACTION_BAR_OVERLAY)
    bar = get_action_bar

    self.content_view =
      linear_layout orientation: :vertical, set_padding: [0, 0, 0, 0] do

        text_view text: 'What hath Matz wrought?!',
                  layout: {width: :match_parent},
                  gravity: :center, text_size: 48.0

        button text: 'Hide',
               layout: {weight: 2},
               on_click_listener: proc { bar.hide }

        button text: 'Show',
               layout: {weight: 1},
               on_click_listener: proc { bar.show }
      end

    color = ColorDrawable.new(Color.parse_color("#FF6600"))
    bar.set_background_drawable(color)
    tv = android.util.TypedValue.new
    if theme.resolveAttribute(android.R.attr.actionBarSize, tv, true)
      actionBarHeight = android.util.TypedValue.complexToDimensionPixelSize(tv.data, resources.display_metrics)
    end
  end
end
