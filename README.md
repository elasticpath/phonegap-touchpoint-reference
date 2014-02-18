PhoneGap POC for Reference Storefront 
============
This is a Proof of Concept PhoneGap application to accompany <a href="https://github.elasticpath.net/cortex/ui-storefront">Elastic Path's HTML5 Reference Storefront</a>.

Prerequisites
============
The PhoneGap application requires the following installed:

* <a href="http://nodejs.org/">NodeJS</a>
* <a href="http://developer.android.com/sdk/index.html">Android SDK</a>
* <a href="http://ant.apache.org/">Apache Ant</a>
 
The installed locations of the Android SDK and Apache Ant must also be in your PATH variable (adjust the precise directory paths below according to their installed locations):

Windows
-----------
Append the following to your PATH variable:

<code>;C:\Development\adt-bundle\sdk\platform-tools;C:\Development\adt-bundle\sdk\tools;C:\Development\apache-ant\bin</code>

Mac
----------
Add the following line to your ~/.bash_profile file:

<code>export PATH=${PATH}:/Development/adt-bundle/sdk/platform-tools:/Development/adt-bundle/sdk/tools</code>

Installing and Running
=============

1. Checkout the POC application source from <a href="https://github.elasticpath.net/cortex/phonegap-poc">GitHub</a> to a local directory.
2. All further commands need to be executed at the command prompt while within this directory.
3. Install all required Node modules globally:
<pre>
<code>[sudo] npm install –g grunt-cli cordova phonegap</code>
</pre>
4. If you are on a Mac and want to run the app in an iOS simulator, you will need to:
<pre>
<code>[sudo] npm install –g ios-sim</code>
</pre>
5. Now install the required modules locally:
<pre>
<code>npm install</code>
</pre>
6. Delete any existing files (except .gitignore) from the ep-src folder and copy the latest <a href="https://github.elasticpath.net/cortex/ui-storefront">UI storefront code</a> into that folder.
7. Ensure <code>/ep-src/public/ep.config.json</code> has the correct values for <code>cortexApi.path</code> and <code>cortexApi.scope</code>.
8. Make the following file changes (where C:/Development/adt-bundle/sdk should be replaced with the path to your local Android SDK installation):
<p><code>/ep-mobile/platforms/android/build.xml</code> (line 90)</p>
<pre>
<code>&lt;import file="C:/Development/adt-bundle/sdk/tools/ant/build.xml" /&gt;</code>
</pre>
<hr/>
<p><code>/ep-mobile/platforms/android/local.properties</code> (line 10)</p>
<pre>
<code>sdk.dir=C:/Development/adt-bundle/sdk</code>
</pre>
<hr/>
<p><code>/ep-mobile/platforms/android/CordovaLib/local.properties</code> (line 10)</p>
<pre>
<code>sdk.dir=C:/Development/adt-bundle/sdk</code>
</pre>
9. Run: 
<pre>
<code>grunt dist</code>
</pre>
This copies the latest code from the ep-src folder into the PhoneGap project.
10. Build the app:
<pre>
<code>grunt build:android</code>
</pre>
11. Run the app on a directly connected device or in an emulator:
<pre>
<code>grunt run:android</code>
</pre>
<pre>
<code>grunt emulate:android</code>
</pre>
