##APIKit
Making interfacing with APIs easier

### Features
---
##### Named Routes
You can register named routes with the `APIRouter` class

    [[APIRouter shared] registerRoute:@"feedDefaults" path:@"/feeds/default/"  requestMethod:kAPIRequestMethodGET];
    [[APIRouter shared] registerRoute:@"feedCreate"   path:@"/feeds/"          requestMethod:kAPIRequestMethodPOST];
    [[APIRouter shared] registerRoute:@"feedSearch"   path:@"/feeds/search/"   requestMethod:kAPIRequestMethodGET];
    [[APIRouter shared] registerRoute:@"feedItems"    path:@"/feed_items/"     requestMethod:kAPIRequestMethodGET];

And then use `APIClient` to call those routes without having to care about the URL or request method.

    [[APIClient shared] requestRoute:@"feedCreate"
                          parameters:params
                             success:
     ^(id responseObject, NSInteger httpStatus) {
         [self saveParsedResponseData:responseObject];
         if(successBlock) successBlock(responseObject, httpStatus);
     }
                             failure:failureBlock];
##### Mocked API Data
During development it is often useful to use fake API data, as the front end team may not move at the same rate as the API team.    With the `APIMockedDataClient` class you can easily have certain build schemes load JSON fixtures while others hit the actual appropriate API.  Simple by defining the preprocessor macro `MOCKED`, `APIClient` will automatically use an `APIMockedDataClient` class to handle all requests.

`APIMockedDataClient` loads any `.json` file in the main bundle and attempts to parse out request/response data and store them in `APIMockRequest` and `APIMockResponse` objects.  

An example fixture from EasyReader is seen here:

    {
      "/feeds/default/": [ 
        {
          "request": {
            "method": "GET",
          },
          "response": {
            "status": 200,
            "body": {
              "feeds": [
                {
                  "id": 1,
                  "name": "Cloudspace Feed",
                  "url": "http://www.engadget.com/rss.xml",
                  "icon": "http://s3.amazonaws.com/rss.cloudspace.com/feed/1/icon.png"
                }
              ]
            }
          }
        }
      ]
    }
 
The main hash key is the requestable path, with it's value being an array of request/response objects.  With each request to `APIMockedDataClient`, it will compre the path and all specified parameters in `request`, and if one matches, return the paired response.

This allows for rapid frontend development, with the possibility of even completely developing a front end prototype without any existing API interface.

##### Object mapping
Object mapping is coming. There will be both automatic mapping with inflectors and fixed mapping objects.  It needs to be extracted out and perfected a bit first.