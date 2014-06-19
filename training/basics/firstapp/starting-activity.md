# Starting Another Activity

So at this point you have an app that shows an activity (a single screen) with a text field and a button.
Now we'll add some code that starts a new activity (takes you to a new screen) when the user clicks the 
Send button. In non-Ruboto android development, the dogma is we always create an intent and then pass the
intent to the method that starts our activity.

But in Ruboto there are two ways to create and start a new activity without explicitily defining the intent.
Next we'll demonstrate both methods and then at the end, breifly discuss when in Ruboto we *do* need to explicitly
create the intent.

But first we need to

## Respond to the Send Button

When the button gets clicked we can tell Ruboto that we want a block or a proc to get called here's what that
looks like

- **Proc**

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send", on_click_listener: proc { send_message }
      end
  end

  def send_message
    # do something
  end

end
```
- **Block**

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        b = button text: "Send"
        b.set_on_click_listener do |view|
          send_message
        end
      end
  end

  def send_message
    # do something
  end

end
```

See, in the block we needed to use `set_on_click_listener` which we could also have typed as `setOnClickListener`
(thanks to JRuby we can swap camelCase and snake_case). Whereas in the proc we said `on_click_listener =`. Also you
may notice that I named the block variable view. We'll get more into views later, but for now suffice it to say
that they are containers for widgets and widgets inherit from them. In this example the view is the `content_view` and
it has a method called `set_on_click_listener` which button inherited from it.


## Starting A Block-based Activity

We'll want to start activites this way primarily when we want a small simple activity that
needs outside information (such as porting text typed into the Edit Text into a new view).

First we need to call `start_ruboto_activity` with a block. Here's the template from the [Ruboto Wiki](https://github.com/ruboto/ruboto/wiki/Using-Activities-and-Intents#block-based-activities) page on the subject:

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

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send", on_click_listener: proc { send_message }
      end
  end

  def send_message
    ruboto_import_widgets :TextView

    start_ruboto_activity do
      def on_create(bundle)
        super
        self.content_view =
          text_view text: "Testing test test. Breadsticks. Breadsticks. Breadsticks. Very good."
      end
    end
  end
end
```

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/firstapp/ex5.png" alt="Hmm . . . breadsticks" width="500px" />

Did it work on your device / emulator? Activitatious!

Now let's learn how to do it with

## Starting a Class-based Activity

From the aforementioned Ruboto Wiki:

> For most Activities, you'll create a Ruby class. RubotoActivity will find that class and create an 
> instance of it to associate it with the Java instance.

> ```ruby
> class MyActivity
>   def on_create(bundle)
>     super
>     set_content_view(text_view(:text => "Hello, World"))
>   end
> end
>
> 
> # To start MyActivity, call the following method from the context of an Activity.
> start_ruboto_activity "MyActivity"
> ```

For our little app it looks like this:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :TextView

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send", on_click_listener: proc { send_message }
      end
  end

  def send_message
    start_ruboto_activity "DisplayMessageActivity"
  end
end

class DisplayMessageActivity
  def on_create(bundle)
    super
    set_content_view(text_view(:text => "Testing test test. Breadsticks. Breadsticks. Breadsticks. Very good."))
  end
end
```

Note that in the above I demonstrate a little more flexibility (called `set_content_view` instead of `self.content_view=`
, imported the widget at the top of the file instead of in the `start_ruboto_activity`, and used other minor syntactical 
differences like parentheses).

## Send Info From One Activity to Another

The last thing we need in order to finish out this app is to get the text entered in the text field (EditText) and hand it
over to the new activity. This is easily done with a little trick.

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
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

Do you see the trick? First of all we needed the text from the edit box. So we named it `input_box` and called the `text` method on it (Java's method is getText so we could call `@input_box.get_text`, `@input_box.getText`, or `@input_box.text`), and then we passed it on to the `send_message` method. 

The trick is the use of the class variable `@@`. This was used since the variable passed into `send_message` (`text`) isn't
available in the `start_ruboto_activity` scope. 

You may also want to note that `@input_box` could also be just `input_box` since we aren't calling it elsewhere. But it's a good habit to get an instance variable for your widgets so that they are more widely accessible.

Here's the expected result

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/firstapp/ex6.png" alt="Hello Ruboto!" width="500px" />


## Some Final Goodies

1) Each activity can have it's own title via `set_title`

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
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
```

Go ahead and check it out on your own device!

2) Note that after you've displayed your message, you can go back and enter a new message via the back arrow. This functionality comes from the fact that the new activity is a child view of your orignal view. But we'll get more into views later. (There's a diagram and a few words on the concept at the top of [this page](http://developer.android.com/training/basics/firstapp/building-ui.html).

3) I said at the beginning that I'd give more info on when to use intents. I think examples are better than talking. So All I'll say now is you'll mainly want to explicitly define an intent when you are using an external activity like Maps, GPS, or Camera. (See [link](https://github.com/ruboto/ruboto/wiki/Using-Activities-and-Intents#opening-3rd-party-apps-called-in-the-context-of-an-activity))


Congratulations! You have finished the first lesson. You now officially know how to build a simple UI and have it create and talk to other activities.


[Previous - Building a Simple User Interface](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/firstapp/building-ui.md) | 
[End of Lesson! Go back to Lessons List](https://github.com/KCErb/hello-ruboto/blob/master/README.md)
