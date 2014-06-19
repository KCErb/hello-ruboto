# Setting Up the Action Bar

Seeing as how the action bar is to an app what water is to a fish, it comes
stock and standard with apps that are designed for Android API 11 and above.
So to get the action bar into our app we just need to tell Ruboto that we're 
building an app for API 11 or greater.

## Make a new app

First, we'll make a practice app to play with for this tutorial. In case you've forgotten
how to do that here are the steps:

1. `ruboto gen app --package org.ruboto.example.action_bar`.

2. `cd action_bar`.

3. `rake install start`

(If you just did `rake` in step 3 there the app would be install but not start. I recommend `rake install start`
because I like to see the app start to prove that everything is working as expected.)

Now clear out the base app that Ruboto generates by replacing the contents of `/src/action_bar_activity.rb` with

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =
      linear_layout :orientation => :vertical do
      end
  end
end
```

## Change the API level

If you're new to Android development you may want to read some of [this](http://developer.android.com/guide/topics/manifest/uses-sdk-element.html#ApiLevels) to learn a bit more about the difference between an *API level* and a *version*.

Now we won't do this often, but today we need to edit the manifest file found in
`\AndroidManifest.xml`.

There's a [line towards the bottom](https://github.com/KCErb/hello-ruboto/blob/master/static/actionbar/AndroidManifest.xml#L15) that says
```xml
<uses-sdk android:minSdkVersion='10' android:targetSdkVersion='10'/>
```

change it to

```xml
<uses-sdk android:minSdkVersion='11' android:targetSdkVersion='19'/>
```

This tells Ruboto that we want our app to be backwards compatible from API 19 all the way back
to 11. (Note: You should choose the API level that your emulator / device runs instead of 19 if
you're on something older than KitKat). 

(Also Note: if you want to use the action bar with API 10 or below. It is possible, but I shall not speak
of such dark things in this happy place.)

## Re-install

Once you've done this you'll need to run `rake install start` again. A simple `rake update_scripts start` won't 
cut it this time because we edited a non-ruby script!

If you did it right you should get this:

<img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/empty_app.png" alt="An empty app, pure and undefiled." width="250px" />


[Previous - Adding the Action Bar](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/index.md) | 
[Next - Adding Action Buttons](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/adding-buttons.md)
