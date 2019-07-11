# SCIOH

<p float="middle">
  <img src="/images/loading.png" width="200" />
  <img src="/images/map.png" width="200" />
</p>

*SCIOH* was an iOS app made in 2016 by students to help students plan a night out on the town. The project has since been heavily rebranded/reworked, and this Xcode project represents the state of the app when I left the team in 2017 (plus a few bug fixes and improvements). It is by no means complete, but some important components are functional (see **Features**), and you should be able to easily demo the app on your own iPhone (see **Installation**).

## Features
* Sign in, sign up, and login persistence
* Map that displays the user's current location, as well as nearby points of interest (limited to a few demo venues in Montreal, QC)
  * The plan was for these POIs to be annotated with live information about how many users were active at that location, and with photos taken by other users of what was happening at that POI
* Search for other users by username and view their profiles
* Follow other users
* Profile page for yourself, with an editable first and last name
  * The plan was for the user to be able to set a profile picture and view their venue photos
* Camera view that lets you save photos to your *SCIOH* account
  * The plan was for these photos to be made viewable on the user's profile page and, with the user's permission, on the pages of appropriate venues
  
## Installation
**Requirements**: macOS, Xcode, [Cocoapods](https://cocoapods.org/)

**Warning**: Do **NOT** input any sensitive information into this app (i.e., your email, your real name, personal photos, etc.). The current state of this app does not implement any significant security or privacy measures.

1. Download the repository.
2. Run `pod install` in the directory containing the file named **Podfile**.
3. Open **SCIOH.xcworkspace** in Xcode.
4. Build and run on your Mac or on your connected iPhone.
5. Enjoy!

## Credits
* **Project Lead**: Valentin Lehericy
* **Project Lead**: Théo Klein
* **Developer**: Romain Boudet
* **Developer**: Sakib Rasul (me!)
* Cocoapods
* Alamofire
* Mapbox
* Google Firebase
* Google Maps
* SwiftyJSON
