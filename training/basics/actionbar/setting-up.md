# Setting Up the Action Bar

Seeing as how the action bar is to an app what water is to a fish, it comes
stock and standard with apps that are designed for Android API 11 and above.
So to get the action bar into our app we just need to tell Ruboto that we're 
building an app for API 11 or greater.

## Make a new app

We'll use `ruboto gen app` again to make our application. Only this time we'll give our command
line tool some options to specify which API levels we are developing for.

(If you're new to Android development, you may want to read some of [this](http://developer.android.com/guide/topics/manifest/uses-sdk-element.html#ApiLevels) to learn a bit more about the difference between an *API level* and a *version*.)


`ruboto gen app --package org.ruboto.action_bar --target=android-19 --min-sdk=android-15`.


This tells Ruboto that we want our app to be backwards compatible from API 19 all the way back
to 15. (Note: You should choose the API level that your emulator / device runs instead of 19 if
you're on something older than KitKat). 

(Also Note: if you want to use the action bar with API 10 or below. It is possible, but I shall not speak 
of such dark things in this happy place.)

Now do `cd action_bar` followed by `rake install start`.

(If you just did `rake`, the app would install but not start. I recommend `rake install start`
 because I like to see the app start, to prove that everything is working as expected.)

Next we'll just create our base app by replacing the contents of `/src/action_bar_activity.rb` with

```ruby
require 'ruboto/widget'

ruboto_import_widgets :LinearLayout

class ActionBarActivity
  def onCreate(bundle)
    super
    self.content_view =`
      linear_layout :orientation => :vertical do
      end
  end
end
```

If you run `rake update_scripts:restart` or `rake update_scripts start` then you should get the following

  <img src="https://raw.githubusercontent.com/KCErb/hello-ruboto/master/static/actionbar/empty_app.png" alt="An empty app, pure and undefiled." width="250px" />


## Changing the API level

So the above works great if you know right from the start what APIs you want to develop for.
But what if you need to change target and min SDK during development? (Take a look at [this](http://developer.android.com/about/dashboards/index.html#Platform)
neat graph that Android provides to get an idea of how many people in the world are on which
versions of Android.)

We won't do this often, but we'll need to edit the manifest file found in `\AndroidManifest.xml`.

There's a [line towards the bottom](https://github.com/KCErb/hello-ruboto/blob/master/static/actionbar/AndroidManifest.xml#L15) that says

```xml
  <uses-sdk android:minSdkVersion='10' android:targetSdkVersion='10'/>
```

change it to

```xml
 <uses-sdk android:minSdkVersion='11' android:targetSdkVersion='19'/>
```

Next go to your `project.properties` file and change the target sdk there as well. (I know it tells you not to, but
for now this seems to be the best way to alter your SDK targets after the fact.)

Now just run `rake update_scripts:restart` and Ruboto will notice the xml changes, and recompile.

[Previous - Adding the Action Bar](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/index.md) | [Next - Adding Action Buttons](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/adding-buttons.md)
