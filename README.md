PhoneGap Touchpoint for Reference Storefront
============
This is a PhoneGap application to accompany <a href="https://github.elasticpath.net/cortex/ui-storefront">Elastic Path's HTML5 Reference Storefront</a>.

Prerequisites
============
The PhoneGap application requires the following installed:

* <a href="http://nodejs.org/">NodeJS</a>

######Android only:######

* <a href="http://developer.android.com/sdk/index.html">Android SDK</a>
* <a href="http://ant.apache.org/">Apache Ant</a>
 
The installed locations of the Android SDK and Apache Ant must also be in your PATH variable (adjust the precise directory paths below according to their installed locations):

On Windows, append the following to your PATH variable:
```
;C:\Development\adt-bundle\sdk\platform-tools;C:\Development\adt-bundle\sdk\tools;C:\Development\apache-ant\bin
```
On Mac, add the following line to your ~/.bash_profile file:
```
export PATH=${PATH}:/Development/adt-bundle/sdk/platform-tools:/Development/adt-bundle/sdk/tools
```
Building the Apps
=============

1. Checkout the PhoneGap application source from <a href="https://github.elasticpath.net/cortex/phonegap-poc">GitHub</a> to a local directory.
2. **All further commands need to be executed at the command prompt while within this directory.**
3. Install all required Node modules globally:
<pre>
<code>[sudo] npm install –g grunt-cli cordova phonegap</code>
</pre>
4. Install the required modules locally:
<pre>
<code>npm install</code>
</pre>
5. Delete any existing files (except .gitignore) from the ep-src folder and copy the latest <a href="https://github.elasticpath.net/cortex/ui-storefront">HTML5 reference storefront code</a> into that folder.
6. Ensure `/ep-src/public/ep.config.json` has the correct values for `cortexApi.path` and `cortexApi.scope`.
7. **(Android)** Make the following file changes (where C:/Development/adt-bundle/sdk should be replaced with the path to your local Android SDK installation):
<p><code>/ep-mobile/platforms/android/build.xml</code> (line 90)</p>
<pre>
<code>&lt;import file="C:/Development/adt-bundle/sdk/tools/ant/build.xml" /&gt;</code>
</pre>
<hr/>
<p><code>/ep-mobile/platforms/android/CordovaLib/build.xml</code> (line 90)</p>
<pre>
<code>&lt;import file="C:/Development/adt-bundle/sdk/tools/ant/build.xml" /&gt;</code>
</pre>
<hr/>
<p>`/ep-mobile/platforms/android/local.properties` (line 10)</p>
<pre>
<code>sdk.dir=C:/Development/adt-bundle/sdk</code>
</pre>
<hr/>
<p>`/ep-mobile/platforms/android/CordovaLib/local.properties` (line 10)</p>
<pre>
<code>sdk.dir=C:/Development/adt-bundle/sdk</code>
</pre>
8. Run: 
<pre>
<code>grunt dist</code>
</pre>
This copies the latest code from the ep-src folder into the PhoneGap project.
9. Build the app:
<p>**Android**</p>
<pre>
<code>grunt build:android</code>
</pre>
<p>**iOS**</p>
<pre>
<code>grunt build:ios</code>
</pre>

Running in an Emulator
=============
######Android######
Start an [Android Virtual Device](http://developer.android.com/tools/help/emulator.html) and run:

`grunt emulate:android`

######iOS######
Run the app with device simulators from Xcode using the project at `/ep-mobile/platforms/ios/HTML5 Storefront.xcodeproj`


Installing to a Device
=============
######Android######
The Android package file will be generated at `/ep-mobile/platforms/android/bin/ElasticPathMobile-debug.apk`
######iOS######
Using the Xcode project at `/ep-mobile/platforms/ios/HTML5 Storefront.xcodeproj`, the iOS app can be deployed to a registered device using a valid Apple Developer provisioning profile, see [this article](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/TestingYouriOSApp/TestingYouriOSApp.html) for further instructions.
Known Issues
=============
######Localized strings in the iOS simulator######
Some localized strings do not not load when the iOS app is run in the iOS simulator. Instead, the tokens used to identify the strings will appear e.g. the profile link will display the text 'auth.profile' instead of 'Profile'.
Troubleshooting
=============
######Missing store categories######
If the store categories do not appear in the menu, check that:

1. the `INTEGRATOR_URL` variable in `Gruntfile.js` references a valid Cortex deployment
2. the `cortexApi.path` and `cortexApi.scope` settings are correct in the `/ep-mobile/www/ep-config.json` JSON file that is generated during the build task

<br/>
######Building the apps with HTML5 Reference Storefront version 1.9 and earlier######
In order to work with these versions of the reference storefront, the following code change is required:

In `ui-storefront/public/ep.client.js`, the following line in the `ep.io.getApiContext` function:

<pre>
<code>retVal = '/' + config.cortexApi.path;</code>
</pre>

should be replaced with:

<pre>
<code>if (/^http/.test(config.cortexApi.path)) {
  retVal = config.cortexApi.path;
} else {
  retVal = '/' + config.cortexApi.path;
}</code>
</pre>
