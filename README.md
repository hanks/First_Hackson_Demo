First Hackson Demo
===========================

This is my first hackson demo, the idea is simple, use iBeacon device to notify customers by local push function of iPhone to show items basic information when customers get close to these items.

## Version History

###_VERSION_ 1.0 - 2015/05/27
+ First release upon the world 

## Why
Just want to demonstrate my idea with iBeacon usage, that is it.  

## Architecture
![alt text][architecture]

[architecture]:
https://raw.githubusercontent.com/hanks/First_Hackson_Demo/master/demo/design.png "architecture"
The core idea is to specify an ID for each item, and use iBeacon device to store the ID to communicate with app run on the iPhone, and then app uses the ID to fetch more detail information of the item from server to show them to users. 

## Demo 
![alt text][demo]

[demo]:
https://raw.githubusercontent.com/hanks/First_Hackson_Demo/master/demo/demo.gif "demo"

##Implementation 
![alt text][implementation]

[implementation]:
https://raw.githubusercontent.com/hanks/First_Hackson_Demo/master/demo/implementation.png "implementation"

How-to: 
 
* Server(Python)  
	* <a href='http://flask.pocoo.org/'>Flask</a>, use as API framework
	* <a href='http://redis.io/'>Redis</a>, use simple data storage
	* <a href='https://docs.docker.com/'>Docker</a> and <a href='https://docs.docker.com/compose/'>Docker Compose</a>, use to build environment
	* NAT, use to port forwarding between mac and iPhone when using vagrant
	* <a href='http://nginx.org/en/docs/'>Nginx</a>, use as simple reverse proxy and load balance
	* ...  
* Client(iOS)
	* <a href='https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html'>Local Notification</a>, use to push notification
	* <a href='https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/RegionMonitoring/RegionMonitoring.html'>CoreLocation</a>, use to communication with iBeacon device
	* <a href='https://github.com/AFNetworking/AFNetworking'>AFNetworking</a>, use to network accessing
	* <a href='https://github.com/erndev/EDStarRating'>EDStarRating</a>, a cool rating control lib
	* <a href='https://github.com/martinjuhasz/MJPopupViewController'>MJPopupViewController</a>, an awesome view pop-up animation lib
	* ...

## Contribution
**Waiting for your pull requests**

## License
MIT License