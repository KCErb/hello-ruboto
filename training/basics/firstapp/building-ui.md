# Building a Simple User Interface

In this lesson you'll create a simple user interface with a text field
and a button. In the following lesson, you'll respond when the button
is pressed by sending the content of the text field to another activity.


## Create a Linear Layout

Open the `new_demo_activity.rb` file from the `src/` directory. The template
that Ruboto beautifully generates for you is neat, but we're going to throw it
all away and start from scratch. So go ahead and replace the contents of the file
with the following:

```ruby
require 'ruboto/widget'

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view =
  end
end
```

Did you do it? Super!

Now the first thing we need to do is import the Linear Layout widget like so:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view =
  end
end
```
Now that it's imported we can use it. But hold on just a second, if you don't 
know what a layout is don't stress. It's just a container for the other widgets.
(What's a widget? Don't feel dumb, a widget is a general term for things like buttons
edit boxes, text boxes etc). A linear layout will either stack the widgets on top of 
each other (`orientation: vertical`) or it will have them flow side by side (`orientation:
horizontal`). 

OK, so let's just stick a blank one in there and go on from here:
```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        # The widgets, they go here
      end

  end
end
```

## Add a Text Field

So for our first widget, let's just do a simple happy little text field. Again
the first step is importing the text field widget called `EditText`:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text
      end

  end
end
```

Ta da. You did it! Now you have a working app. Go ahead and try it out!

(If you don't know how to try it out, go back and re-read 'Running Your Application'
super important)

You'll notice that the box starts out small and gets bigger as you type stuff in. Lets
make this thing a bit prettier by stating what its width should be ahead of time. The 
easiest way to do that is via the `weight` option.

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}
      end

  end
end
```
Hey nifty. We'll play with weight at the end to get a better idea of what it does
but for now, just think of it as something that assigns a weight to the widget. So
if I have two widgets each of weight 1 then they'll both get 50% of the screen. If
I have two objects of weight 1 and one object of weight 2 then that one will get 
1/2 the screen while the little weight 1s will get only 1/4 each.

Ok, the other thing making that thing look weird is that usually those things
don't start out blank. We call that text the "hint":

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      end

  end
end
```
If you're serious about learning this stuff from scratch, I highly highly recommend that you
run the app each time after you update a line of code. You'll get to see it in the flesh. Way
better than those wimpy screen shots.

Anyways, good job. Let's move on.

## Add a Button

OK, as you might be able to guess. Adding a button is as easy as

- Import `:Button`
- then put `button` in the layout

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class NewDemoActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send"
      end

  end
end
```

And that's it. Crazy simple! Now let's start talking to the button!

[Previous - Running Your App](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/firstapp/running-app.md) | 
[Next - Starting Another Activity](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/firstapp/starting-activity.md)
