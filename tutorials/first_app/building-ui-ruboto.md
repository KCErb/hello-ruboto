---
layout: page
title: Building a Simple User Interface The Ruboto Way
category: first_app
order: 5
permalink: /first_app/building-ui-ruboto/
---

OK champ, you've slugged through awkward programmatic interfaces like `Java::android.widget`;
you've written and loaded XML resources; you've been through the murky waters of Android app
development and come out on top a winner!

It's now time to stand on the shoulders of giants and use some fancy tools that Ruboto
is eager to provide.

## ruboto/widget

Inside of your `src` directory you'll see a directory called `ruboto`. Go ahead and open-up `widget.rb`.
This file does something really great, it allows us to create widgets by just

1. Importing them with the `ruboto_import_widgets` method
2. Calling a snake_case method name and passing a hash of parameters

It also allows us to add the widgets to a parent view (like a linear layout) by passing them
into a block for the view.

Our entire user-interface becomes:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def onCreate(savedInstanceState)
    super
    layout = linear_layout orientation: :horizontal do
      edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      button text: "Send"
    end
    setContentView(layout)
  end
end
```

{% include image.html width='250px' src='edit_text_and_button.png' page=page %}

## Syntactic Sugar

To help everything be very Ruby-like we are also allowed to change our syntax a bit:

* We can change camelCase methods and variables to snake_case
* We can replace `setSomething` with `something=`
* We can replace `getSomething` with just `something`

So for me the final layout is:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button

class FirstAppActivity
  def on_create(bundle)
    super
    layout = linear_layout orientation: :horizontal do
      edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      button text: "Send"
    end
    self.content_view = layout
  end
end
```

***
**Sidenote** - I changed the variable passed to `onCreate` back to the original `bundle` that
 the Ruboto demo called it to start with. That's because the `saved_instance_state` is of *type* bundle
 and bundle is shorter to type.
 ***

## XML and Resources

Having seen the above you may be thinking that you'll never use XML. And depending on your
application that might be true, but there are good reasons to use it and at the end of the day
you *will* find yourself using other resources (such as pictures or language support strings).

Ruboto has a nice accessor to the `R` package for us which is loaded when you load `ruboto/widget` and comes from the `ruboto/package` file.

This file defines a class `R` and hooks it up to behave like the Java package. So the XML version of this can now
look like this:


```ruby
require 'ruboto/package'

class FirstAppActivity
  def on_create(bundle)
    super
    self.content_view = R.layout.first_layout
  end
end
```

And that's all there is to it. Ruboto is awesome!
