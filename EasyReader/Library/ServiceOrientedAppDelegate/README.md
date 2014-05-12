##SRVApplicationDelegate

 A service-oriented application delegate for use in iOS applications.


######Dependencies
This project currently relies upon [MAObjCRuntime](https://github.com/mikeash/MAObjCRuntime).  I'll be adding a demo project and podspec soon to make this more apparent, though I do plan on eventually the dependency entirely.  It's only used in one place and I think it could by handled simply without it, but it's what I know and easy to use so it's in place for now.

### Why?
Appdelegates are one of the most abused pieces of UIKit and tend to get crammed with tons of code.  With some Objective-C runtime techniques we can elegantly abstract out code into Service objects that function just like they were part of the delegate themselves.  This allows for smaller, more reusable, more testable classes and a much more readable appdelegate.

### How?
When a delegate method is to be called, the calling object always first checks if the delegate responds to that method.  By overriding `- (BOOL)respondsToSelector:(SEL)aSelector` we can tell the calling class that we respond to selectors that we don't actually implement.  Generally this would cause problems as you need to implement each method an object responds to, however `NSObject` also has the method `- (void)forwardInvocation:(NSInvocation *)anInvocation` which gets called every time an unknown selector is invoked on an object.  In this method we're tasked with forwarding the invocation of a method to a target that can receive it or raising an exception.

By overriding `- (void)forwardInvocation:(NSInvocation *)anInvocation` we can now use it to execute the given method invocation on each of our service objects without actually implementing *any* of the delegate methods.

### Shared singleton service objects
Since each service should only be registered with the AppDelegate once, we need to rely on methods that return singleton objects so that only one instance will ever be created.  Commonly this is done by creating a `shared` or `sharedInstance` method on the objects and using `dispatch_once`, but in a situation where you may have 10+ services, repeating all that code seems to be a waste.  

Creating a parent class for all the services is the obvious next step in improving things, but this now presents a tricky dillema.  Any static `dispatch_once_t` predicate defined by a parent class will be shared by the child classes, meaning that `shared` will only ever be executed once across any of the interiting objects and we'll only ever get one registered service.

To solve this problem I've created a singleton dictionary of dispatch predicates (actually it's a dictionary of NSNumbers holding the predicates memory addresses, because NSDictionary only supports NSObject instances), along with a singleton dictionary of class instances.  These dictionaries are keyed by the current class name ( `NSStringFromClass([self class])` ) and are used to tell which `dispatch_once` blocks have been executed for each class.

