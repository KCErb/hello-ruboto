# Other Features of the Action Bar

In this last lesson we'll learn how to change the color of the actionbar, overlay it, and how to stick an "Up Button" on it.

## Styling the Action Bar

If you want to know a lot more about styling your app go check out [the lesson on styling](), but right here, we'll just talk about a couple of quick tricks for changing simple aspects of the look and feel of the action bar programmatically.

For starters let's change the background color. If we look at the ActionBar API and look for methods relating to background, the following useful method comes up

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/background_api.png" alt="Background drawable" width="500px" />

This tells us that the action bar has a method for setting the background and that we need to hand that method a `Drawable`. In this lesson I'll show you how to create a solid color `Drawable` without much comment since I'd like to save the details of this beefy class for other lessons. Now scroll up to the top of the guide. Somewhere in there it should tell you that you can get an instance of `ActionBar` via `get_action_bar`.

Putting that all together we get

```ruby
require 'ruboto/widget'
require 'ruboto/util/toast'
 
ruboto_import_widgets :LinearLayout
java_import "android.view.MenuItem"
java_import "android.graphics.drawable.ColorDrawable"
java_import "android.graphics.Color"

 
class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end

    bar = get_action_bar
    color = ColorDrawable.new(Color.parse_color("#FF6600"))
    bar.set_background_drawable(color)

  end

  def on_create_options_menu(menu)
    super
    #get none constant. Call ni for not important
    ni = android.view.Menu::NONE

    #add search
    item = menu.add(ni, 1, ni, "Search")
    item.set_icon R::drawable::ic_menu_search
    item.show_as_action = MenuItem::SHOW_AS_ACTION_IF_ROOM 

    #add settings
    item = menu.add(ni, 2, ni, "Settings")
    item.show_as_action = MenuItem::SHOW_AS_ACTION_NEVER

    #return true
    true 
  end

  def on_options_item_selected(item)
    case item.get_item_id
    when 1
      toast 'Searching . . .'
    when 2
      toast 'Setting . . .'
    end
    true
  end
end
```

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/orange_action.png" alt="Mmm . . . Orange Bars" width="500px" />


## Overlaying the Action Bar

You can hide and show the action bar by calling hide and show on the bar. To demo this I'm going to get rid of the action buttons (less code) and add some content.

```ruby
require 'ruboto/widget'
 
ruboto_import_widgets :LinearLayout, :TextView, :Button
java_import "android.graphics.drawable.ColorDrawable"
java_import "android.graphics.Color"
 
class ActionBarActivity
  def onCreate(bundle)
    super
    bar = get_action_bar
    
    self.content_view =
      linear_layout orientation: :vertical do
        
        text_view text: 'What hath Matz wrought?!',
                  layout: {width: :match_parent},
                  gravity: :center, text_size: 48.0
         
        button text: 'Hide', 
               layout: {weight: 2},
               on_click_listener: proc {bar.hide}
         
        button text: 'Show', 
               layout: {weight: 1},
               on_click_listener: proc { bar.show }

      end

    color = ColorDrawable.new(Color.parse_color("#FF6600"))
    bar.set_background_drawable(color)
  end
end
```

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/hide_show.png" alt="2 parts hide, one part show. Shake well." width="250px" />


Now besides playing around with this and remembering how weight works (yes that's vertical weight here) I want you to notice something. Each time you show or hide the action bar the buttons change size and the text recenters itself.

For a big app, this could be a problem, and the solution is to overlay the action bar. When the action bar is in overlay mode then the contents of the app sit underneath it. That means they don't get repositioned / resized when the actionbar comes and goes.

If you check out the ActionBar API and look for "Overlay" you should be able to learn about `FEATURE_ACTION_BAR_OVERLAY`. The trick with this constant is that [the API](http://developer.android.com/reference/android/view/Window.html#FEATURE_ACTION_BAR_OVERLAY) says "if this feature is requested". When I first tried to use this I was using methods like `addFlag` and `setFlag` but I should have used `request_feature`:

```ruby
class ActionBarActivity
  def onCreate(bundle)
    super
    get_window.request_feature(android.view.Window::FEATURE_ACTION_BAR_OVERLAY)
    bar = get_action_bar
    
    self.content_view =
      linear_layout orientation: :vertical do
        
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
  end
end
```
  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/overlay.png" alt="Overlay" width="250px" />

The last thing to note here is that the action bar is now covering up the content. That seems like a bad idea.

There are two ways that are commonly used:

1. Make your action bar transparent. `Color.argb(128, 0, 0, 0)` 

2. Create a top margin.

. . . still working on this . . .

## Creating and Using the Up Button

The last thing that folks like to do with an Action Bar is put an "Up Button" on there.

 <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/actionbar-up.png" alt="Google is Creative Commons right?" width="250px" />

The up button is there so that users know where home is. Your interface should have a clear logical home, and whenever a user leaves home, you should provide a way back. To demo this feature, we're going to just paste in that code from the firstapp which used two activities.

. . . still working on this . . . 


[Prev - Responding to Buttons](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/responding.md) | [End of Lesson! Go back to Lessons List](https://github.com/KCErb/hello-ruboto/blob/master/README.md)
