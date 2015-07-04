---
layout: page
title: Android Studio
category: toolbox
order: 3
permalink: /toolbox/android-studio/
---

The next tool I'm going to introduce you to is Android Studio. To be honest, I'm not sure how much I'll be using Android Studio in the coming tutorials! I've decided to include it because we can use it to build those layout XMLs instead of typing everything by hand. So let's explore around a little.

### Download

The first thing you've got to do is download Android Studio from the [Android developer's site](http://developer.android.com/sdk/index.html). While you're there, you might want to read around a little. In this lesson, I only plan to play with the GUI / XML features so don't get too hung up on the details here.

When you open the Android Studio for the first time, you'll be asked to install the SDK, agree to license agreements etc. If Ruboto is set up correctly, then you should already have a lot of the things it's downloading and installing. Oh well, put on a 5 minute Youtube video and wait it out.

### Open An Existing Android Studio Project

After opening Android Studio, click `Open an Existing Android Studio project` and point it at the root directory of your Ruboto project. (Note that doing so will create a `.idea` hidden folder in your project source, Android Studio uses this.)

{% include image.html width='400px' src='android_studio_dialog.png' page=page %}

In these examples, I'll be using the XML-based `first_app` we built [here](http://kcerb.github.io/hello-ruboto/first_app/building-ui-xml/).

At this point you should get a screen that looks like this:

{% include image.html width='' src='first_app_empty.png' page=page %}

The pop-up window on the right titled "Frameworks detected" needs to be taken care of. Go ahead and click Configure.
You don't really have a lot of options here so just press OK. This is just the IDE double-checking that it has found the right
`AndroidManifest.xml` files, and it has.

### Preview the Layout

With that done, we should see our `first_app_xml` folder on the left. If you open it, all you'll see is a folder that says `java`:

{% include image.html width='' src='first_app_java.png' page=page %}

If you single-click on the first "breadcrumb" that says `first_app_xml` you should get the following:

{% include image.html width='' src='breadcrumb.png' page=page %}

Now double-click that breadcrumb and your file structure will appear. Use it to navigate to the `first_layout.xml` file and double-click to open it.

You have arrived!

{% include image.html width='' src='lollipop.png' page=page %}

## Play Around

I may add more to this tutorial at a future date, but for now I want to end with my recommendation that you play around a bit. Add text, buttons, etc. The purpose of Android Studio (in Ruboto development anyways) is to give you a GUI that writes XML. So go have a ball!

As an example I just added a cancel button (not hooked up to anything):

{% include image.html width='' src='example.png' page=page %}

Things to note:

* I ran my app from the Android Studio terminal (lower-left corner) with `rake install start`. This isn't necessary, but I wanted to check it out.

Here's what the app looks like on my phone. I must say, it was kinda nice to just do a drag and drop after all that XML!

{% include image.html width='250px' src='cancel_too.png' page=page %}
