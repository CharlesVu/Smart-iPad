# Smart-iPad

Smart-iPad (the name is lame) is an app for people who doesn't have the skill to do a full on smart mirror but have an iPad in their inventory somewhere.

## Right now it displays:
 - The Time
 - The Weather (can cycle throught several cities)
 - UK Train informations (via NRE) 
 - Room Lights status via HomeKit

## Relies on:
  - Dark Sky API for the weather 
  - Huxley proxy for the train information (proxy between you and the NRE, I was too lazy to implement a SOAP XML client in swift)
  - https://github.com/radex/SwiftyTimer (included) to have easy timers in Swift
  - https://github.com/miwand/Skycons-Swift (included) for the weather icons
  - http://ethanschoonover.com/solarized for the colour scheme
  - SWiftPM for dependecies
  
## To-do list:
 - [x] Have somewhere in the app to change the cities/stations
 - [ ] Add TFL (UK underground) informations
 - [ ] Add Dark Sky, Huxley, NRE, SwiftlyTimer, Skycons, solarized attributions in a legal screen (and everything this project uses)
 - [ ] Add some better transition animations
 - [x] Configuration file
 
## To Build

 ```bash
 $ carthage boostrap --platform iOS
 ``` 
 
## To Run
- Follow the steps https://github.com/jpsingleton/Huxley to get a proxy working and an API Key
- Get an API key from https://darksky.net/dev/
- Copy the config.sample.plist to config.plis and put your Huxley endpoint and both API Keys
- Run.
 
## Screenshots 
![alt text](https://github.com/CharlesVu/Smart-iPad/raw/master/Screenshots/content_dark.jpg "Screenshot Dark")

![alt text](https://github.com/CharlesVu/Smart-iPad/raw/master/Screenshots/content_light.jpg "Screenshot Light")

![alt text](https://github.com/CharlesVu/Smart-iPad/raw/master/Screenshots/content_mirror.jpg "Screenshot White on Black")
