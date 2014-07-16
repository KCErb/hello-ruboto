# Adding Action Buttons

To add buttons to the action bar, all we need to do is use the 
`on_create_options_menu` method. 

(FYI, `on_create` is Java's way of saying `initialize`.)

## The Simplest Possible Button

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
  end

  def on_create_options_menu(menu)
    super
    menu_item = menu.add("Search")
    true 
  end
end
```

In the above example you added a button with the title "Search" to the options menu. The only weird thing
here is that `true` at the end of the method. Unless you want to dig deeper into the mysterious world of 
Java, then just take this as an axiom of the `options_menu` (and others as we'll see): no matter what
you do, you need to make sure that the method returns true at the end.

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/simple_search.png" alt="First step" width="250px" />

## Adding an Icon

First let's give the search bar an icon. You have two options. Many icons come with the SDK, so let's start by using one of those.


```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
  end

  def on_create_options_menu(menu)
    super
    menu_item = menu.add("Search")
    menu_item.set_icon R::drawable::ic_menu_search
    true 
  end
end
```

OK, easy enough. But what if we want to use a custom one? If you head over to the [Androidthis page](http://developer.android.com/design/downloads/index.html#action-bar-icon-pack) you can download the Action Bar Icon Pack. To use any of these files you need to copy the files to your application's `res/drawable/` folders. 

The drawable folders have names like 'drawable-hdpi' or 'drawable-xxhdpi' and they allow your application to use different images depending on the resolution of the device ([more info](http://stackoverflow.com/questions/11581649/about-android-image-size-and-assets-sizes)).

As an example, let's say I want to use the icon called `ic_action_search.png`. 

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
  end

  def on_create_options_menu(menu)
    super
    menu_item = menu.add("Search")
    menu_item.set_icon Ruboto::R::drawable::ic_action_search
    true 
  end
end
```

If you run the above, you'll see that there's no icon! That's because the menu item is not on the action bar, it's in the "overflow". By default that's where buttons go, but of course we can change that.


```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
  end

  def on_create_options_menu(menu)
    super
    menu_item = menu.add("Search")
    menu_item.set_icon Ruboto::R::drawable::ic_action_search
    menu_item.show_as_action = android.view.MenuItem::SHOW_AS_ACTION_IF_ROOM
    true 
  end
end
```


  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/search_icon.png" alt="First step" width="250px" />



[Prev - Setting Up the Action Bar](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/setting-up.md) | [Next - Responding to Buttons](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/responding.md)
