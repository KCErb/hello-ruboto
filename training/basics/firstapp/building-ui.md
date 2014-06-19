# Building a Simple User Interface

In this lesson you'll create a simple user interface with a text field
and a button.

## First some basics - Activities and Intents

Activities and Intents are two of the main components of an Android application. Activities generally correspond to a single screen on your device. Intents are fired to indicate what you want to do next (e.g., open another Activity).

So to get started with an app we

1. Go back to that nice directory that you are planning on sticking your apps in. And then
2. Type `ruboto gen app --package org.rubyandroid.first_app`.

`ruboto gen app` creates your whole project including `first_app/src/first_app_activity.rb` which is the only file you'll need to edit for these first few lessons.

(For more details on the files created, and other options (besides `--package`) that you can pass to `ruboto gen app` you should definitely read [this](https://github.com/ruboto/ruboto/wiki/How-Ruboto-Works))

## Create a Linear Layout

Open the `first_app_activity.rb` file from the `src/` directory. The template
that Ruboto beautifully generates for you is neat, but we're going to throw it
all away and start from scratch. So go ahead and replace the contents of the file
with the following:

```ruby
require 'ruboto/widget'

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view =
  end
end
```

Did you do it? Super! (If you want to read a bit more about this class, and how it fits into
the grand scheme of things, you may want to give [this](https://github.com/ruboto/ruboto/wiki/Using-Activities-and-Intents#activity-basics) 
a read.)

Now the first thing we need to do is import the Linear Layout widget like so:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view =
  end
end
```
Now that it's imported we can use it. But hold on just a second, if you don't 
know what a layout is don't stress. It's just a container for the other widgets.
(A widget is a general term for things like buttons, edit boxes, text boxes etc.)
A linear layout will either stack the widgets on top of each other 
(`orientation: vertical`) or it will have them flow side by side (`orientation: horizontal`). 

OK, so let's just stick a blank one in there and go on from here:
```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class FirstAppActivity
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

So for our first widget, let's just do a simple happy little text field (the thing that you type text into). Again
the first step is importing the text field widget called `EditText`:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text
      end

  end
end
```

Ta da. You did it! Now you have a working app. Go ahead and try it out by running `rake install start`. Or
if you already did this and just want to update your app to reflect the new changes run `rake update_scripts` and 
restart your app. As long as your changes are in your ruby files then `rake_update_scripts` will update your app.

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/firstapp/ex1.png" alt="Tiny EditText" width="250px" />


You'll notice that the box starts out small and gets bigger as you type stuff in. Lets
make this thing a bit prettier by stating what its width should be ahead of time. The 
easiest way to do that is via the `weight` option.

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}
      end

  end
end
```

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/firstapp/ex2.png" alt="Bigger EditText" width="250px" />


Hey nifty. Here's how weight works:
if I have two widgets each of `weight: 1` then they'll both get 50% of the screen. If
I have two objects of `weight: 1` and one object of `weight: 2` then that one will get 
1/2 the screen while the little `weight: 1`s will get only 1/4 each.

Ok, the other thing making the text field look weird is that usually those things
don't start out blank. They usually have some kind of faint gray text that disappears
when you click on them. That text is called the "hint":

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = 
      linear_layout orientation: :horizontal do
        edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      end

  end
end
```

Once again, run the program to see what it looks like.

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/firstapp/ex3.png" alt="I'll give you a hint." width="250px" />

(If you're serious about learning this stuff from scratch, I highly highly recommend that you
run the app each time after you update a line of code. You'll get to see it in the flesh and you'll
catch errors before they get to be too many.)

Anyways, good job. Let's move on.

## Add a Button

OK, as you might be able to guess. Adding a button is as easy as

- Import `:Button`
- then put `button` in the layout

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
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

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/firstapp/ex4.png" alt="ooh button" width="250px" />


And that's it. Crazy simple! Now let's start talking to the button!

[Previous - Running Your App](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/firstapp/running-app.md) | 
[Next - Starting Another Activity](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/firstapp/starting-activity.md)
