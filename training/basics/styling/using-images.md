# Using Images

Let's start by learning how to reference external resources. Whether you're using stock icons from the android developer site, or your own background images you'll need to be able to tell ruboto where to find custom images.

## Changing the Launch Icon

The default launch icon is found in `res/drawable`, `res/drawable-ldpi`, `res/drawable-mdpi`, and `res/drawable-hdpi`. You can reference these folders via `Ruboto::R::drawable` or `$package::R::drawable`.

Now, note that `::drawable` references *all* of the folders. This is an important design concept in Android! We are developing an app for lots of screen sizes and densities and that means an image resource (like a bitmap) is going to be getting scaled up or down based on the screen. Based on the guidelines [here](http://developer.android.com/guide/practices/screens_support.html#support) Ruboto will intelligently choose which image resource to use based on the screen properites of the user's device!

So let's create a new launch icon for our app:

1. Read [this](http://developer.android.com/design/style/iconography.html) great guide.
2. Create a few PNGs of an icon (image size recommendations can be found in the [iconography style-guide](http://developer.android.com/design/style/iconography.html)).
3. Name them `ic_launcher.png` and put them in the appropriate folders.


I used [this](https://github.com/KCErb/hello-ruboto/blob/master/static/styling/ic_launcher.png) file, and resized it using (Apple's) Preview.

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/styling/launch_icon.png" width="250px" />



## Changing the Background

Depending on how you want to use images in your app there are a lot of different ways to think about and work with them. A good starting place for learning about these is [here](http://developer.android.com/guide/topics/graphics/2d-graphics.html#drawables).

In this example I'll use the simplest case: creating a background image.

### Create an ImageView

After reading up a bit on graphics from the API guides, I learned that a basic way to use my own images in an app is via the [ImageView](http://developer.android.com/reference/android/widget/ImageView.html) class. So how do we use it?

In the past I've just used classes like this correctly but in this tutorial let's figure it out. First, find the "Public Constructors" section of the` ImageView` reference.

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/styling/public-constructors.png" width="250px" />

This section tells us the different ways of creating an `ImageView`. The first argument (context) is passed in by default via ruboto. Since this class will take just context alone, that means we can create a blank `ImageView` without throwing any errors. Go ahead and try it. (Don't forget to import the `ImageView` widget!)

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :EditText, :Button, :ImageView

class ActionBarActivity
  def on_create(bundle)
    super
    self.content_view =
      linear_layout orientation: :horizontal do
        @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
        button text: "Send", on_click_listener: proc { send_message(@input_box.text) }
      end
      image_view

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
  end #send_message

end
```

### Set Attributes
Having created an `ImageView` we can now call its methods to set it up how we want.

The first attribute we'll want to set is the `android:src`. This is done via the "Related Method" `setImageResource(int)`. (Be sure you understand how I found that xml resource name and related method!). For this example I snatched a comic panel from the [Poignant Guide](https://www.google.com/#q=whys+poignant+guide), named it `foxes.png`, and put it in my `res/drawable/` directory.

Showing just the `on_create` method of `ActionBarActivity`:

```ruby
def on_create(bundle)
  super
  self.content_view =
    linear_layout orientation: :horizontal do
      @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      button text: "Send", on_click_listener: proc { send_message(@input_box.text) }
    end
    background_image = image_view
    background_image.set_image_resource Ruboto::R::drawable.foxes
end
```

  If you run that you'll see that nothing happened! Why is that?

  Because the ImageView isn't inside of a layout; it doesn't have anywhere to go. I want my image to be just beneath the input text bar, so I'll put my horizontal layout inside of a vertical one like so:

```ruby
def on_create(bundle)
  super
  self.content_view =
  linear_layout orientation: :vertical do
    linear_layout orientation: :horizontal do
      @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      button text: "Send", on_click_listener: proc { send_message(@input_box.text) }
    end

    background_image = image_view
    background_image.set_image_resource Ruboto::R::drawable.foxes
  end

end
```

and this time I get:

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/styling/background-ss.png" width="250px" />


### A Final Note on Construction

Take a look at the second constructor for the ImageView class. It says that we can pass in attributes during construction. In case it wasn't clear before, we can create the background image in one line like this:

```ruby
def on_create(bundle)
  super
  self.content_view =
  linear_layout orientation: :vertical do
    linear_layout orientation: :horizontal do
      @input_box = edit_text layout: {weight: 1.0}, hint: "Enter Some Text!"
      button text: "Send", on_click_listener: proc { send_message(@input_box.text) }
    end

    image_view image_resource: Ruboto::R::drawable.foxes
  end

end
```

You may notice that I used `image_resource` instead of `set_image_resource`. That's thanks to the interpretation stuff that JRuby does.
I don't know what all the accepted variations are, and sometimes they don't work (I recently ran into an issue where I had to use `set_padding` instead of `padding` because of a broken interpreter for example) but the general idea is you can drop set and get since in ruby we prefer language like `padding =` for a setter method and just `padding` for a getter method. Which means we could also have done

```ruby
background_image = image_view
background_image.image_resource = Ruboto::R::drawable.foxes
```

As you continue to explore Ruboto you'll find that between Java, Ruby and the very flexible Android API, there are lots of ways to write the same thing.


[Previous - Styling](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/styling/index.md) |
[Next - Using Colors](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/styling/using-colors.md)
