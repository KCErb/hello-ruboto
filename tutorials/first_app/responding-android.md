---
layout: page
title: Responding to Input Android Way
category: first_app
order: 6
permalink: /first_app/responding-android/
---

OK, so one way or another we have a text field and a button on the screen. To round off the section that showed how to build a user-interface the Android way, I'll show you how to respond to the button and get the text from the `EditText`.

The Android way is slightly different if you built the UI programmatically or using XML so I'll need to show you both ways. Also, there's a mixed way to do it that we'll look at too.

## Respond to the Send Button

### The XML way
<hr>
**Warning** as of right now the "XML way" doesn't work!
I'll go ahead and write this section as if it works but be warned: it doesn't!
<hr>
According to the `Button` docs, our button inherited an `android:onClick` XML attribute from `android.view.View`. If you're like me, you'll be alarmed to note that this is one of those rare XML attributes that doesn't have a 'Related Method'!

To use this attribute, we just specify the name of a method in the activity that we want to call like this:

```xml
<Button
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@string/button_send"
    android:onClick="sendMessage" />
```

Then all we need to do is add the `sendMessage` method to the activity:

```ruby
def sendMessage(view)
end
```

As an easy way to test that our button is hooked up as expected, we'll have it create a [toast](http://developer.android.com/guide/topics/ui/notifiers/toasts.html) like so:

```ruby
def sendMessage(view)
  message = 'Howdy'
  duration = Java::android.widget.TOAST::LENGTH_SHORT
  toast = Java::android.widget.TOAST.makeText(self, message, duration)
  toast.show()
end
```

And that's all there is to it!

### The Programmatic Way

Let's pretend like XML doesn't exist and go back to our old app. It's just one file, which I've prettied up a bit since you last saw it:

```ruby
class FirstAppActivity
  LAYOUT = Java::android.widget.LinearLayout
  EDIT_TEXT = Java::android.widget.EditText
  BUTTON = Java::android.widget.Button

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
  end
end
```

Please note that in the above I used the same substitutions as the Ruboto way (`setHint` became `hint=` and `getLayoutParams` became `layout_params`). As it turns out, you don't need Ruboto to get these conversions. They come from JRuby too! Neat! It's also important that in the above I call `self.content_view=` instead of `content_view=`.

To respond to click events programmatically, we just need to set the `onClickListener` for the button. The way this works out in the wash is pretty interesting. Take a look:

```ruby
TOAST = Java::android.widget.Toast

def create_button
  @button = BUTTON.new(self)
  button.text = 'Send'
  layout.add_view button
  button.on_click_listener = proc { howdy }
end

def howdy
  message = 'Howdy'
  duration = TOAST::LENGTH_SHORT
  toast = TOAST.make_text(self, message, duration)
  toast.show
end
```

The docs will tell you that the `setOnClickListener` method is just looking for a callback. In Ruby one way to do that is to set the listener to a `proc` like the above, then whatever is in the proc will get called when the button gets clicked.

Another way is to use the `set` form of the method and hand it a `block`:

```ruby
button.set_on_click_listener { howdy }
```

### A Blended Approach

The last approach that I'll explore, is one where we still declare our UI over in the XML, but instead of attaching an `onClick` directly, we'll fetch the object from the XML and work with it programmatically. From what I've seen so far, this approach is pretty common to a lot of problem solving in Android land, so let's take a look.

First, we need to fetch the button from the XML. We can get views (which the button is) via the `Activity` class's `findViewById` method. This method just needs an identifier integer which we can access again via our resources package `R`. If we give our button an id like so:

```xml
<Button android:id="@+id/send_button"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@string/button_send" />
```

then the integer can be retrieved from the id package. Using the `ruboto/package` we can get a reference to the button as `R.id.send_button`. We can use that id to retrieve the view with the `findViewById` method available to our activity.

Altogether that's:

```ruby
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
```

{% include image.html width='250px' src='howdy.png' page=page %}
