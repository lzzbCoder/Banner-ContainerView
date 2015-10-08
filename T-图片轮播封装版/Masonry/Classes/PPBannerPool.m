
#import "PPBannerPool.h"
#import "PPBannerVC.h"

static const NSInteger  MIN_POOL_SIZE = 5;

@interface PPBannerPool () {
    NSMutableArray      *_banners;
}
@property(nonatomic, assign) NSInteger      poolSize;

@end

@implementation PPBannerPool


- (instancetype)init {
    self = [super init];
    if (self) {
        _poolSize = MIN_POOL_SIZE;
        [self doInit];
    }
    return self;
}

-(instancetype)initWithSize:(NSInteger)poolSize {
    self = [super init];
    if (self) {
        _poolSize = MIN(poolSize, MIN_POOL_SIZE);
        [self doInit];
    }
    return self;
}

-(void)doInit {
    
    _banners = [NSMutableArray arrayWithCapacity:_poolSize];
    
    for (NSInteger i = 0; i < _poolSize; i++) {
        PPBannerVC *vc = [PPBannerVC new];
        vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.98];
        [_banners addObject:vc];
    }
}

-(PPBannerVC *)dequeueBannerExclude:(NSArray *)visibleVCs {
    
    PPBannerVC *vc;
    
    for (PPBannerVC *candidateVC in _banners) {
        if ([visibleVCs indexOfObject:candidateVC] == NSNotFound) {
            vc = candidateVC;
            break;
        }
    }
    
    [_banners removeObject:vc];
    [_banners addObject:vc];
    
    return vc;
}

@end
