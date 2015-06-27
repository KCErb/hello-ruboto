---
layout: page
title: Starting Another Activity
category: first_app
order: 7
permalink: /basics/firstapp/starting-activity/
---

So at this point you have an app that shows an activity (a single screen) with a text field and a button.
Now we'll add some code that starts a new activity (takes you to a new screen) when the user clicks the
Send button. In non-Ruboto android development, the dogma is we always create an [intent](https://developer.android.com/guide/components/intents-filters.html) and then pass the
intent to the method that starts our activity.

At first I tried to write a tutorial showing how to do this in Ruboto without using Ruboto's helpers, but I kept hitting dead-ends. From what I can tell, because of the way Ruboto is set up, you're better off just doing this the Ruboto way!

First let's look at the Ruboto way to respond to that send button and then we'll talk all about starting a new activity in Ruboto.

## Respond to the Send Button

As before, when the button gets clicked we can tell Ruboto that we want a block or a proc to get called, here's what that looks like

- **Proc**

```ruby
require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    layout = linear_layout orientation: :horizontal do
      edit_text layout: { weight: 1.0 }, hint: 'Enter Some Text!'
      button text: 'Send', on_click_listener: proc { howdy }
    end
    self.content_view = layout
  end

  def howdy
    toast 'Howdy!'
  end
end

```
- **Block**

```ruby
require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    layout = linear_layout orientation: :horizontal do
      edit_text layout: { weight: 1.0 }, hint: 'Enter Some Text!'
      b = button text: 'Send'
      b.set_on_click_listener { howdy }
    end
    self.content_view = layout
  end

  def howdy
    toast 'Howdy!'
  end
end
```

Pretty simple isn't it? You may also notice that this time I used a convenience accessor
to `Toast`ing that Ruboto comes with. Pretty slick!


## Starting A New Activity

First of all, there's a nice Wiki write-up on the subject of Intents and Activities over on the [Ruboto Wiki](https://github.com/ruboto/ruboto/wiki/Using-Activities-and-Intents#block-based-activities), you should give that a look. It explains that we have two basic ways to start a new activity if we're using an internal activity (for external activities like Maps or the Camera see the Wiki page). Let's take a look at each of them:

### Block-based

We'll want to start activities this way primarily when we want a small simple activity that
needs outside information (such as porting text typed into the Edit Text into a new view).

First we need to call `start_ruboto_activity` with a block. Here's the template from the  page on the subject:

> ```ruby
> # start_ruboto_activity is a method on Activity, so it must be called in that context
> start_ruboto_activity do
>   def on_create(bundle)
>     super
>     ## Set up the activity
>   end
>
> ## Other unique activity code
> end
> ```

And here's how that looks in our code:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :TextView

class FirstAppActivity
  def on_create(bundle)
    super
    layout = linear_layout orientation: :horizontal do
      edit_text layout: { weight: 1.0 }, hint: 'Enter Some Text!'
      button text: 'Send', on_click_listener: proc { send_message }
    end
    self.content_view = layout
  end

  def send_message
    start_ruboto_activity do
      def on_create(bundle)
        super
        message = 'Testing test test. Breadsticks. Breadsticks. Breadsticks. Very good.'
        self.content_view = text_view text: message
      end
    end
  end
end
```

{% include image.html width='250px' src='breadsticks.png' page=page %}

Did it work on your device / emulator? Activitatious!
I love the smell of breadsticks in my phone!

Now let's learn how to do it with

## Starting a Class-based Activity

From the aforementioned Ruboto Wiki:

> For most Activities, you'll create a Ruby class. RubotoActivity will find that class and create an
> instance of it to associate it with the Java instance.

> ```ruby
> class MyActivity
>   def on_create(bundle)
>     super
>     set_content_view(text_view(:text => 'Hello, World'))
>   end
> end
>
>
> # To start MyActivity, call the following method from the context of an Activity.
> start_ruboto_activity 'MyActivity'
> ```

For our little app it looks like this:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view =
      linear_layout orientation: :horizontal do
        edit_text layout: { weight: 1.0 }, hint: 'Enter Some Text!'
        button text: 'Send', on_click_listener: proc { send_message }
      end
  end

  def send_message
    start_ruboto_activity 'DisplayMessageActivity'
  end
end

# => Meanwhile over in display_message_activity.rb  . . .
require 'ruboto/widget'
ruboto_import_widgets :TextView

class DisplayMessageActivity
  def on_create(bundle)
    super
    message = 'Testing test test. Breadsticks. Breadsticks. Breadsticks. Very good.'
    self.content_view = text_view text: message
  end
end
```

## Send Info From One Activity to Another

The last thing we need in order to finish out this app is to get the text entered in the text field (EditText) and hand it over to the new activity.

### Block-based

The block based approach might be a little surprising:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :TextView

class FirstAppActivity
  def on_create(bundle)
    super
    layout = linear_layout orientation: :horizontal do
      @input_box = edit_text layout: { weight: 1.0 }, hint: 'Enter Some Text!'
      button text: 'Send', on_click_listener: proc { send_message }
    end
    self.content_view = layout
  end

  def send_message
    message = @input_box.text

    start_ruboto_activity do
      @@message = message
      def on_create(bundle)
        super
        self.content_view = text_view text: @@message
      end
    end
  end
end
```

First of all we needed the text from the edit box. So we named it `@input_box` and called the `text` method on it. So far so good.

Next we need to handle the special scoping that goes on here. The trouble is that an instance variable like `@input_box` isn't available in the scope of the `start_ruboto_activity` block, but a regular variable (like `message` above) *is* available. So we stash `@input_box.text` onto `message`.

Now `message` *is* available inside of the block, but it's not available inside the `on_create`. This is one of those rare cases where a class-variable is not a bad idea. The class variable **is** available inside of `on_create` so we stash the contents of `message` into `@@message` and set *that* as the TextView.

The final result (if you edit the size of the text, I'll leave that to you as an exercise!) is:

{% include image.html width='500px' src='hello_ruboto.png' page=page %}

## Class-based

If the new activity is sitting in its own class, then any data you want passed on should be passed into `start_ruboto_activity` in an `extras` field like this:

```ruby
def send_message
  message = @input_box.text
  start_ruboto_activity 'DisplayMessageActivity', extras: { message: message.to_s }
end
```

and then the extra is retrieved in the other class like this:

```ruby
def on_create(bundle)
  super
  message = intent.getExtra 'message'
  self.content_view = text_view text: message
end
```

An `extra` in Android is like a hash in Ruby. Extras are used to pass information around in Intents just like you see in the above example. If you look at the [Intent documentation](https://developer.android.com/reference/android/content/Intent.html) you'll see lots of methods for putting information into the Intent (`put` methods) and lots of methods for getting the information back out. Internally, `start_ruboto_activity` stores the hash you give it as a list of `StringExtra`s. That means you can access values here as `getStringExta` or `getExtra` followed by the key from the hash as shown above.

***
**Gotcha** - One gotcha from above is that I needed to call `message.to_s` but I didn't need the `to_s` for the block-based. That's because the `getText` method from an `EditText` doens't return a string! The block-based approach didn't notice because we set the text of the text-view using some Ruby tricks that did the `to_s` along the way. But in the class-based approach. If we don't append `to_s` then the `Extra` will pass a non-string onto the next activity and you'll run into some issues.
***

## Conclusion

OK, did you follow all of that?!

We covered how to build a UI programmatically, using XML, and the Ruboto way. We also learned how to set-up callbacks, start new activities and pass information to them. This last part about starting new activities and passing data around is a little heavy!

There's A LOT more to learn, but this is a good start. If you are reading this, and realize looking back that you didn't absorb very much then I encourage you to take a break, get some sleep and review this all tomorrow. The Android API mixed with Ruboto will take some getting used to (I'm still working on it!) so don't get frustrated. Just patiently keep coming back to it until it's second nature.
