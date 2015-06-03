# Accessing Attributes

Your app has many attributes which are either set by the system (such as the [actionBarSize](http://developer.android.com/reference/android/R.attr.html#actionBarSize)) or are set by the developer (like gradient [angle](http://developer.android.com/reference/android/R.attr.html#angle)). Either way, you may find yourself needing to access these values and respond accordingly. A full list of them is sitting here: http://developer.android.com/reference/android/R.attr.html.

The trick is that these are intended for use in the XML which we would like to avoid with Ruboto. As noted in the lesson on [overlaying the action bar](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/actionbar/other-features.md#overlaying-the-action-bar), things get a little clunky here.

## Resolving Attributes

Android stores attributes (like the action bar height) as a Constant Value (sort of like an id). For example, if I look at the reference for [actionBarSize](http://developer.android.com/reference/android/R.attr.html#actionBarSize), I see that the Constant Value is 16843499 and if all I do is call `android.R.attr.actionBarSize`, then this is exactly the value that will be returned.

So how do I 'dereference' this value and get the real deal?

Well that depends on where you're getting the value from. According to the developer tutorial this demo is based on ([Overlaying the Action Bar](https://developer.android.com/training/basics/actionbar/overlaying.html#TopMargin)) we are looking for the *theme* attribute (marked by a `?` in the XML) so we will need to use the [Theme resource](https://developer.android.com/reference/android/content/res/Resources.Theme.html).

This resource gives us a method for turning a constant value like 16843499 into a measured size like '52px':
[resolveAttribute](https://developer.android.com/reference/android/content/res/Resources.Theme.html#resolveAttribute).

This method is a little weird to work with because it requires three inputs:
* a `resid` *int*
* an *outValue* (of type `TypedValue`)
* and a *resolveRefs* boolean

The first one is just the Constant Value (16843499) we've been talking about. The second is a type of object just for this purpose (holding onto resource values). And the third we'll set to true to make sure we get the value (though in this simple example it probably isn't necessary).

Putting that together looks like this:

```
tv = android.util.TypedValue.new
theme.resolv_attribute(android.R.attr.actionBarSize, tv, true)
```


[Previous - Using Colors Project](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/styling/using-colors.md) |
[Next - Using Units](https://github.com/KCErb/hello-ruboto/blob/master/training/basics/styling/using-units.md)
