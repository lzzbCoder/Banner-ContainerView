
#import <UIKit/UIKit.h>
#import "PPBannerVC.h"

/// The view controller which rolls a group of banner images
@interface PPRollingBannerVC : UIPageViewController
/// images for the rolling banner, can be a remote URL or UIImage
@property (nonatomic, copy)     NSArray                 *rollingImages;
/// time interval between the rolling
@property (nonatomic, assign)   NSTimeInterval          rollingInterval;


/// start rolling
-(void)startRolling;

/// stop rolling
-(void)stopRolling;

/// handler for banner tap event
-(void)addBannerTapHandler:(BannderTapHandler)handler;

@end

