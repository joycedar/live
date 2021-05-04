

#import <Foundation/Foundation.h>
@class CLLocation;
typedef void(^LocationBlock)(NSString * lat, NSString * lon);

@interface KKLLocationManager : NSObject
+ (instancetype)sharedManager;

- (void)getGps:(LocationBlock)block;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) NSString * lat;
@property (nonatomic, copy) NSString * lon;
@end
