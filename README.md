
instagram4iPad
--------------

The universal application demonstrates, how you can work with the instagram API, featuring a custom fullscreen UI.  
The code is written with ARC and iOS 5.0 support, but also uses some old classes without ARC.

### Class structure: ###############

*Model:*

- `UserInfoDataProvider` - gets the user info from the Instagram API
- `ImageListDataProvider` - loads a list of images from the Instagram API
- `Photo` - stores a single Photo json entry and provides a simple interface to access the most used keys

*View:*

- `HeaderView` - displays the login button. After login, the user info is displayed here.
- `ContentView` - represents the area, where you can see your photos.
- `ThumbnailView` - represents a single thumbnail

*Controller:*

- `MainViewController` - as the name states, this is the main / starting screen
- `FullscreenViewController` - this represents the detail view of a single photo
- `WebViewController` - as the name states, this wraps a webview into a controller. **this class also handles the oauth callback**


### What could be done better: ##############

- JSON Parsing should be done asynchronous in the background
- The GridView should use a system with reusable imageviews for better performance
- You could generate Retina thumbnails from bigger sizes for better visuals on the new iPad


### References: ###############

This project uses:

- The keychain wrapper [SFHFKeychainUtils] by ldandersen.
- The [DataProvider] by jaydee3.
- The [json-framework] by stig.

File created using [markdowneditor].





[SFHFKeychainUtils]: https://github.com/ldandersen/scifihifi-iphone/tree/master/security
[DataProvider]: https://github.com/jaydee3/DataProvider
[json-framework]: https://github.com/stig/json-framework
[markdowneditor]: http://www.ctrlshift.net/project/markdowneditor/