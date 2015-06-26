---
layout: page
title: Creating an Android Project
category: first_app
order: 2
permalink: /first_app/setting-up/
---

# Setting up Ruboto

The first thing we'll do is install Ruboto and get everything set up:

```
$ gem install ruboto
$ ruboto setup -y
```

The `-y` option means you'll automatically accept all the license agreements that will come up.
This is convenient because `ruboto` will be downloading and installing lots of software and they all have a
yes/no pause for these agreements.

Once you have Ruboto set up we can move forward. Here's what my setup looks like now:

```
Java runtime             : Found
Java Compiler            : Found
Apache ANT               : Found
Android Package Installer: Found
Android Emulator         : Found
Intel HAXM               : Old   1.1.2/
Android SDK Command adb  : Found
Android SDK Command dx   : Found
Platform SDK android-16  : Found

    *** Ruboto setup is OK! ***

```

I don't mind the old HAXM stuff because I'm going to be using my phone. I'd like to
get us using [Genymotion](https://www.genymotion.com/) but that'll have to be on hold
until I figure out how to make it work.

If you're using a phone like me, be sure to enable debug mode on the phone, there
are nice instructions [here](http://www.kingoapp.com/root-tutorials/how-to-enable-usb-debugging-mode-on-android.htm).

If you don't have a phone, and you don't want to pioneer combining Genymotion with
Ruboto, then you'll need to use the native device emulator and I won't be able to help
you much. But [this wiki page](https://github.com/ruboto/ruboto/wiki/Setting-Up-a-Ruboto-Development-Environment#generate-an-avd) is the place to start.

One of the tools that this process downloaded is the SDK manager. It's not something that I've used much
since my initial install so I'm not an expert with it. But if you'd like to know more about it you can read [this article](https://developer.android.com/tools/help/sdk-manager.html).

## Using gen app to get started

1. Go to a new clean directory where you want to put some projects.

2. In the terminal run `$ ruboto gen app --package com.tutorials.quick_start`.

3. Go into the directory that Ruboto just created via: `$ cd quick_start`.

4. Build it by running `$ rake` (this generates an `apk` at `bin/QuickStart-debug.apk`).

OK so you have a working environment, you have an app, and you have either a device or a
virtual device. Now we just want to put the app onto the device and see it in action.

## Installing the app

When your device is running/connected you can type `rake install start` into the command line
and the demo app should spring to life.

If you haven't already downloaded the Ruboto core (and if you're new to this,
then you probably haven't), then you will be prompted to get it from
the app store. This app has the stuff Ruboto needs to do its magic.

## Done

If you see the following on your screen then all is well and you are ready to start your training!

{% include image.html width='250px' src='quick_start.png' page=page %}


If not, don't sweat it! Please email me so that I can make these instructions better. The startup
phase is the hardest part of this whole process and I want to make it awesome, so please contact me!
