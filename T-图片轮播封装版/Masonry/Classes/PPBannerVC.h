#import <UIKit/UIKit.h>


typedef void(^BannderTapHandler)(NSInteger whichIndex);


/// Banner view controller to show a banner image
@interface PPBannerVC : UIViewController

/// placeHolder for the banner image
@property (nonatomic, strong)                   UIImage                 *placeHolder;
/// image for the banner, can be a URL or UIImage
@property (nonatomic, copy)                     id                      image;
/// temporarily save the current index of the banner
@property (nonatomic, assign)                   NSInteger               index;

/// handler block for banner tapping
@property (nonatomic, copy)                     BannderTapHandler    bannerTapHandler;

@end
