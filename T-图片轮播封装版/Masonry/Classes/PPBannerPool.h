
#import <Foundation/Foundation.h>

@class PPBannerVC;

/// The memory pool from which you dequeue a banner from
@interface PPBannerPool : NSObject
/// Initialize the pool with a size, the default & minimal size is 5
-(instancetype)initWithSize:(NSInteger)poolSize;
/// dequeue a banner for use, excluding banners which are current showing
-(PPBannerVC *)dequeueBannerExclude:(NSArray *)visibleVCs;

@end
