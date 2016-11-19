# Smart-iPad

Smart-iPad (the name is lame) is an app for people who doesn't have the skill to do a full on smart mirror but have an iPad in their inventory somewhere.

## Right now it displays:
 - The Time
 - The Weather (can cycle throught several cities)
 - UK Train informations (via NRE) 
 
## Relies on:
  - Dark Sky API for the weather 
  - Huxley proxy for the train information (proxy between you and the NRE, I was too lazy to implement a SOAP XML client in swift)
  - https://github.com/radex/SwiftyTimer (included) to have easy timers in Swift
  - https://github.com/miwand/Skycons-Swift (included) for the weather icons
  - http://ethanschoonover.com/solarized for the colour scheme
  - carthage for dependecies
  
## To-do list:
 [ ] Have somewhere in the app to change the cities/stations
 [ ] Add TFL (UK underground) informations
 [ ] Add Dark Sky, Huxley, NRE, SwiftlyTimer, Skycons, solarized attributions in a legal screen (and everything this project uses)
 [ ] Add some better transition animations
 [ ] Configuration file
 
## To Build

 ```bash
 $ carthage boostrap --platform iOS
 ``` 
 
 
