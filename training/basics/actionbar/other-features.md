# Other Features of the Action Bar

In this last lesson we'll learn how to change the color of the actionbar, overlay it, and how to stick an "Up Button" on it. WARNING: some of these features are harder to do than I had at first anticipated. That means this lesson isn't actually finished and you may be dissatisfied with the answers I give. I recommend that you use the following as a launching point. I've left a lot of the nitty gritty for future lessons.

## Styling the Action Bar

If you want to know a lot more about styling your app go check out [the lesson on styling](https://github.com/KCErb/hello-ruboto/blob/master/training/aux/future_lesson.md), but right here, we'll just talk about a couple of quick tricks for changing simple aspects of the look and feel of the action bar programmatically.

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

You can hide and show the action bar by calling hide and show on the bar. To demo this, I'm going to get rid of the action buttons (less code) and add some content.

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

For a big app, this could be a problem, and the solution is to overlay the action bar. When the action bar is in overlay mode, the contents of the app sit underneath it. That means they don't get repositioned / resized when the action bar comes and goes.

If you check out the ActionBar API and look for "Overlay" you should be able to learn about `FEATURE_ACTION_BAR_OVERLAY`. The trick with this constant is that [the docs](http://developer.android.com/reference/android/view/Window.html#FEATURE_ACTION_BAR_OVERLAY) say "if this feature is requested". When I first tried to use this, I was using methods like `addFlag` and `setFlag` but I should have used `request_feature`:

```ruby
require 'ruboto/widget'
 
ruboto_import_widgets :LinearLayout, :TextView, :Button
java_import "android.graphics.drawable.ColorDrawable"
java_import "android.graphics.Color"


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

Two most commonly used ways to fix this are:

1. Make your action bar transparent. `Color.argb(128, 0, 0, 0)`. I'll let you play with this one. (Be sure to look it up in the documentation!) 

2. Create a top margin. This is a good time to learn about XML attributes and their corresponding methods!

So let's head on over to the API on Linear Layouts and look up padding. Towards the top of the page we see in the summary a list of XML Attributes and Inherited XML Attributes. The `LinearLayout` inherits padding attributes from `android.view.View`. One of the key features of Ruboto is that we do as much as possible without editing the XML. So the correct way to add padding to the LinearLayout is via the *Related Method* in the second column. For padding, the methods are `setPaddingRelative` and `setPadding`. So, with that information, here's just one way to get the desired effect.

```ruby
require 'ruboto/widget'
 
ruboto_import_widgets :LinearLayout, :TextView, :Button
java_import "android.graphics.drawable.ColorDrawable"
java_import "android.graphics.Color"


class ActionBarActivity
  def onCreate(bundle)
    super
    get_window.request_feature(android.view.Window::FEATURE_ACTION_BAR_OVERLAY)
    bar = get_action_bar

    self.content_view =
      linear_layout orientation: :vertical, set_padding: [0, 64, 0, 0] do
        
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

In the above example I found that 64 gave me the size I wanted. But what if instead of hard coding a padding, you want to have the API figure out the actual size of the Action Bar and use that? That would actually be the better approach! Since your app will be displayed on lots of different screen sizes and resolutions, you can expect the action bar to be a different size on each device. Since that's kind of a big topic and since it's actually pretty klunky in Ruboto it gets its own lesson: [Using Units and Attributes with Ruboto](https://github.com/KCErb/hello-ruboto/blob/master/training/aux/future_lesson.md).


(NOTE: You may have noticed that in the above example I used `set_padding` instead of just `padding`. Normally JRuby helps convert language like this, so you *would* expect `padding` to call the `setPadding` method. Unfortunately, at the time of this writing, there seems to be a glitch. So the moral of the story is: if using the ruby version of a method doesn't work, try java version.)


## Creating and Using the Up Button

Another thing that folks like to do with an Action Bar is put an "Up Button" on there.

 <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/actionbar-up.png" alt="Google is Creative Commons right?" width="250px" />

The up button is there so that users know where home is. Your interface should have a clear logical home, and whenever a user leaves home, you should provide a way back. To demo this feature, we're going to just paste in that code from the `firstapp` which used two activities. Here's what that looks like without the Up button as a reminder.

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class ActionBarActivity
  def on_create(bundle)
    super
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
        self.content_view =
          text_view text: @@text
      end
    end
  end
end
```

The first thing we'll do is add a dead Up button to the new activity. Before looking at the solution below, you should really take a moment to search the documentation and try to figure out how to do this. There's a function for it and the answer is only one line of code! You can do it, go search, then come back!

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class ActionBarActivity
  def on_create(bundle)
    super
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
        self.content_view =
          text_view text: @@text

        get_action_bar.set_display_home_as_up_enabled(true)
      end
    end
  end
end
```

Now all that's left is to tell the button what to do when it is pressed. If you weren't using Ruboto's convenient `start_ruboto_activtiy` you would declare the parent of the activity in the XML and the Up Button would do the right thing. But since we *are* using this nice method, we can't tell the new activity who it's parent is. Instead we must simply tell the button what to do. 

There are a lot of options here, and I would recommend reading [this](http://developer.android.com/training/implementing-navigation/ancestral.html) to get an idea of all the different things you could tell that button to do which would amount to what I've done here:

```ruby
# Sorry, this is still getting debugged. For the purposes
# of the tutorials I'll move on. But until then let this
# be a lesson: some things that are easy on the Java side
# are hard on the Ruboto side.
```


[Prev - Responding to Buttons](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/responding.md) | [End of Lesson! Go back to Lessons List](https://github.com/KCErb/hello-ruboto/blob/master/README.md)
