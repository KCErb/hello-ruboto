---
layout: page
title: Using Colors
category: styling
order: 3
permalink: /basics/styling/using-colors/
---
Over in the Action Bar lesson, I briefly [demoed]({{ site.baseurl }}/basics/actionbar/other-features/#styling-the-action-bar) how to set the background color of the action bar. In this lesson we'll take a closer look at what happened there and experiment a little more with Drawables.

To demo the use of colors, we'll give the second activity of the Action Bar app a background color and a text color. Here's a reminder of what that app looks like:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :ImageView

class ActionBarActivity
  def on_create(bundle)
    super
    self.content_view =
    linear_layout orientation: :vertical do
      linear_layout orientation: :horizontal do
        @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send", on_click_listener: proc { send_message(@input_box.text) }
      end

      background_image = image_view
      background_image.image_resource = Ruboto::R::drawable.foxes
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

For the purposes of this demo, I'll just focus on the code inside of `on_create`, and the first thing I'll change is setting the `content_view` to be a `linear_layout` instead of a `text_view`:

```ruby
def on_create(bundle)
  super
  self.content_view =
    linear_layout orientation: :vertical do
      text_view text: @@text
    end
end
```

## Setting Text and Background Colors

Looking through the TextView and View classes we see a few different methods associated with backgrounds:
* `setBackground` takes a `color int`
* `setBackgroundColor` takes a `Drawable`

So colors come in two flavors: as a color int or a color drawable. The same goes for TextView methods like `setTextColor` (which takes a color int as well).


## The Graphics Package

Have a look [here](http://developer.android.com/reference/android/graphics/package-summary.html). Graphics are sort of a big deal and colors are just a tiny piece of the bigger picture. The Graphics package is the first place we can get colors from. They're a class inside of the graphics package (see [graphics.Color]( http://developer.android.com/reference/android/graphics/Color.html)).

The Color class is what methods like `setBackground` are looking for when they ask for an `int color`. This class provides several method for creating color ints. I'll demo a few.

### argb

Let's use the `argb` method to set the text color to a shade of hot pink.

```ruby
def on_create(bundle)
  super
  self.content_view =
  linear_layout orientation: :vertical do
    text_view text: @@text,
              text_color: android.graphics.Color.argb(255,255,0,153)
  end
end
```

{% include image.html width='250px' src='pink.png' page=page %}

(Remember: You can always skip the `android.package` portion of a method call by importing the package with a line at the top of your file. If this is a new idea to you see [this]({{site.baseurl}}/basics/actionbar/responding/#let-me-introduce-you-to-the-docs) lesson.)

### Constants

Another option is to use a named color like CYAN

```ruby
def on_create(bundle)
  super
  self.content_view =
  linear_layout orientation: :vertical do
    text_view text: @@text,
              text_color: android.graphics.Color::CYAN
  end
end
```

{% include image.html width='250px' src='cyan.png' page=page %}

### Ints

The last option I'll demo is creating the ints directly. The format is standard [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal#Representation) with the first two digits being `0x` to indicate hexadecimal, the next two being alpha and then the rest being red, green and blue. So for example. A fully opaque green would be `0xff00ff00`.

```ruby
def on_create(bundle)
  super
  self.content_view =
  linear_layout orientation: :vertical do
    text_view text: @@text, text_color: 0xff00ff00
  end
end
```

{% include image.html width='250px' src='green.png' page=page %}

(If creating these by hand appeals to you, you should see [this](http://stackoverflow.com/questions/15852122/hex-transparency-in-colors) handy stackoverflow post.)

## The Drawable Package

To quote from [here](http://developer.android.com/reference/android/graphics/drawable/package-summary.html) this package . . .
> Provides classes to manage a variety of visual elements that are intended for display only, such as bitmaps and gradients. These elements are often used by widgets as background images or simply as indicators (for example, a volume level indicator).

In other words, there are certain contexts where we need to convert a simple graphics color, into a drawable object. To do this we use the [ColorDrawable](http://developer.android.com/reference/android/graphics/drawable/ColorDrawable.html) class.

This is a very basic class which more or less converts a simple graphics color into a drawable like so:

```ruby
ColorDrawable color: Color.rgb(117,100,55)
```

## Conclusion

Now, I'd like to end this lesson with a challenge and an example. The challenge is for you to play around with setting various colors on `content_view`s, `linear_layout`s, and the like. Setting the background color on a view or layout can be a good way to find out what its bounds are.

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :ImageView
java_import "android.graphics.Color"

class ActionBarActivity
  def on_create(bundle)
    super
    self.content_view =
    linear_layout orientation: :vertical,
                  background_color: Color.rgb(190,80,60) do

      linear_layout orientation: :horizontal do
        @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!",
                               text_color: Color::WHITE,
                               hint_text_color: Color::WHITE
        button text: "Send",
               on_click_listener: proc { send_message(@input_box.text) },
               background_color: Color.rgb(0,120,140)
      end

      background_image = image_view
      background_image.image_resource = Ruboto::R::drawable.foxes
    end

  end

  def send_message(text)
    ruboto_import_widgets :TextView

    start_ruboto_activity do
      @@text = text
      def on_create(bundle)
        super
        self.content_view =
        linear_layout orientation: :vertical, background_color: Color::WHITE do
          text_view text: @@text, text_color: Color.rgb(110,155,35),
                    gravity: :center, text_size: 48.0,
                    background_color: Color.rgb(200,160,60)
        end
      end
    end
  end
end
```

{% include image.html width='250px' src='colors1.png' page=page %}
{% include image.html width='250px' src='colors2.png' page=page %}
