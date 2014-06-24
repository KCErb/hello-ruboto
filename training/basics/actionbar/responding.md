# Responding to Buttons

Now that your app has a search button let's learn how to get the app to do something if the user actually decided to click it. But first . . . 


## A Quick Note on Syntax

If you're like me, then when you saw `SHOW_AS_ACTION_IF_ROOM` on the previous page you thought "How would I know about that constant without a tutorial"? Where can I look that sort of stuff up? The answer is the [API guides](http://developer.android.com/guide/index.html). Translating the API guides into ruboto is a key skill which you will need to develop in order to master development for Android via ruboto. As we go along I'll start pointing you to the API guides. I highly recommend that you go check them out so that you get used to reading them alongside these tutorials.

For starters let's talk about the MenuItem class. 

When you want to use a Java class like `MenuItem` you have two options

1) Use the full name of the class. In the example on the previous page that's `android.view.MenuItem`. Go ahead and search for `MenuItem` over at the API website I just linked to. Without even going to the results, the first item in the drop down list should be `android.view.MenuItem`. 


  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/api_guides_search.png" alt="Don't click yet!" width="500px" />


That tells you the name of the class. Now go ahead and click on that search result to have a look at the API for that class. You can see if you scroll down a bit a list of constants that this class gives you access to such as `SHOW_AS_ACTION_IF_ROOM`. You can also see methods it has such as `add`.

2) It's not convenient to always address your `MenuItem` by its full name `android.view.MenuItem` so Ruboto gives you a better way: just use `java_import` to import the class:

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout
java_import "android.view.MenuItem"


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
    menu_item.show_as_action = MenuItem::SHOW_AS_ACTION_IF_ROOM
    true 
  end
end
```

## Responding to Buttons - The Method

When one of your options is selected the `on_options_item_selected` callback gets called. Let's take a look at the API to see how this thing should work. Go on over to the [API guides](http://developer.android.com/guide/index.html) and search for 'onOptionsItemSelected'. You won't get a quick result this time, but if you press enter the first result should be the API for `android.app.Activity`. This is a big fat important class. To find out why the search tool brough you here use your browser's find tool (usually command+f or ctrl+f) to find it on the page.

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/onoptions_api.png" alt="Read carefully" width="500px" />

The field at left that says `boolean` tells us that the method should return either true or false. At right we see that `onOptionsItemSelected` (which we interpret as `on_options_item_selected`) is called whenever an options item is selected, and it makes that menuitem available.

So here's how we use it (note that as a bonus I added a settings menu item. It'll be nice as an example to have more than one action bar item in a minute).

```ruby
require 'ruboto/widget'
 
ruboto_import_widgets :LinearLayout
java_import "android.view.MenuItem"
 
class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
  end
 
  def on_create_options_menu(menu)
    super
    
    #add search
    item = menu.add("Search")
    item.set_icon Ruboto::R::drawable::ic_action_search
    item.show_as_action = MenuItem::SHOW_AS_ACTION_IF_ROOM 
 
    #add settings
    item = menu.add("Settings")
    item.show_as_action = MenuItem::SHOW_AS_ACTION_NEVER
 
    #return true
    true 
  end
  
  def on_options_item_selected(item)
    #do stuff with item 
    true
  end
end
```
Don't forget to return true!


# Responding to Buttons - Setting ID

The best thing to do with the item once you've got it inside of the `on_options_item_selected` callback is to have that method figure out which item it is and behave appropriately like so:
```ruby
  def on_options_item_selected(item)
    case item.get_item_id
    when 1
      # do something
    when 2
      # do something
    end
    true
  end
```

But in order to use that, we need to give each of our menu items an id. It was actually kind of hard for me to figure out how to do this. So I'll walk you through my process so that you can solve tough problems too.

* First I tried things like `item.set_id = 1` or `item.id = 1` (I would place that in `on_create_options_menu`). But those failed, and if you look at the [MenuItem API](http://developer.android.com/reference/android/view/MenuItem.html) you'll see that a MenuItem doesn't have a setID method.

* Next I googled around for "how to set menu item id android" and found [this answer](http://stackoverflow.com/questions/8386790/setting-itemid-in-options-menu).

* In the [article](http://developer.android.com/reference/android/view/Menu.html#add(int, int, int, int)) that stackoverflow references, we see that the `android.view.Menu` class has an `add` method (in fact, that's the method we used to create the menu items!). This method can be called a few different ways (see [method overloading](http://en.wikipedia.org/wiki/Method_overloading)). When we used it the first time we just gave it a string. But now we need to give it some id numbers so that the `on_options_item_selected` hook can do the right thing.

* We don't actually need to set the `groupId` or `order` for this example so we could just use `(0, 1, 0, "Search")` as arguments, but android recommends using `NONE` if we don't actually care what the id number is (instead of 0 or some other arbitrary number).

* So next I clicked on the link for `NONE` to see what it's full name is so that I can use it. The answer is `android.view.Menu::NONE`

* Finally I gave my buttons ids!

```ruby
require 'ruboto/widget'
 
ruboto_import_widgets :LinearLayout
java_import "android.view.MenuItem"
 
class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
  end
 
  def on_create_options_menu(menu)
    super
    #get none constant. Call it ni for not important
    ni = android.view.Menu::NONE

    #add search
    item = menu.add(ni, 1, ni, "Search")
    item.set_icon R::drawable::ic_menu_search
    item.show_as_action = MenuItem::SHOW_AS_ACTION_IF_ROOM 
 
    #add settings
    item = menu.add(ni, 2, ni, "Settings")
    item.show_as_action = android.view.MenuItem::SHOW_AS_ACTION_NEVER
 
    #return true
    true 
  end
  
  def on_options_item_selected(item)
    case item.get_item_id
    when 1
      # call your search method
    when 2
      # call your settings method
    end
    true
  end
end
```

# Let's Close With a Toast 

Hopefully by now you know how to add buttons, give them id numbers, use the APIs a bit, and that's great. But how can you test something as you go? There are a few tools (most notably IRB which we'll get to in another lesson), but right now I'll show you a kind of cute one that I like to use sometimes. I won't explain much on this one both because it is simple and because I want you to get in the habit of looking things up.

```ruby
require 'ruboto/widget'
require 'ruboto/util/toast'
 
ruboto_import_widgets :LinearLayout
java_import "android.view.MenuItem"
 
class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout orientation: :vertical do
      end
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
    item.show_as_action = android.view.MenuItem::SHOW_AS_ACTION_NEVER
 
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

If all is well, you should see the screenshot below when selecting the search icon from the action bar.

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/searching.png" alt="Get it? Setting?!" width="250px" />





[Prev - Adding Action Buttons](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/adding-buttons.md) | [Next - Other Features of the Action Bar](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/other-features.md)
