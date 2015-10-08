
#import "PPRollingBannerVC.h"
#import "PPBannerPool.h"
#import "Masonry.h"

@interface PPRollingBannerVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    
    NSTimer         *_timer;
    
    PPBannerPool   *_bannerPool;
    
    UIPageControl   *_pageControl;
}

/// handler block for banner tapping
@property (nonatomic, copy)     BannderTapHandler    bannerTapHandler;

@end

@implementation PPRollingBannerVC

-(NSTimeInterval)rollingInterval {
    if (_rollingInterval < 1) {
        _rollingInterval = 1;
    }
    
    return _rollingInterval;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    if (self) {
        [self _doInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _doInit];
    }
    return self;
}

-(void)_doInit {
    _bannerPool = [[PPBannerPool alloc] initWithSize:10];
    _pageControl = [[UIPageControl alloc] init];
}

-(void)setRollingImages:(NSArray *)rollingImages {
    
    _rollingImages = rollingImages;
    
    /// set page count
    _pageControl.numberOfPages = _rollingImages.count;
    
    /// init first view controller and show it
    PPBannerVC *vc = [_bannerPool dequeueBannerExclude:self.viewControllers];
    vc.bannerTapHandler = [self tapHandlerForVC];
    vc.image = _rollingImages.firstObject;
    
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.and.right.equalTo(self.view);
    }];
}




#pragma mark - rolling
-(void)startRolling {
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.rollingInterval target:self selector:@selector(doRolling) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)stopRolling {
    [_timer invalidate];
    _timer = nil;
}

-(void)pauseRolling {
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeRolling {
    [_timer setFireDate:[NSDate dateWithTimeInterval:self.rollingInterval sinceDate:[NSDate date]]];
}

-(void)doRolling {
    PPBannerVC *currentVC = (PPBannerVC *)self.viewControllers.firstObject;
    PPBannerVC *nextVC = [self vcNextTo:currentVC beforeOrAfter:NO];
    if (nextVC == nil) {
        nextVC = [_bannerPool dequeueBannerExclude:self.viewControllers];
        nextVC.bannerTapHandler = [self tapHandlerForVC];
        nextVC.image = _rollingImages.firstObject;
    }
    
    __weak typeof(self) weakSelf = self;
    [self setViewControllers:@[nextVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf->_pageControl.currentPage = nextVC.index;
        

        if(finished)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf setViewControllers:@[nextVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        });
        }
    }];
}


#pragma mark - banner tapping
-(void)addBannerTapHandler:(BannderTapHandler)handler {
    _bannerTapHandler = handler;
}


#pragma mark - helpers
-(NSInteger)cycleChangeIndex:(NSInteger)index delta:(NSInteger)delta maxIndex:(NSInteger)maxIndex {
    
    index += delta;
    
    if (index < 0) {
        index = maxIndex;
    } else if (index > maxIndex) {
        index = 0;
    }
    
    return index;
}

/// if beforeOrAfter == YES, find a vc 'Before' it, otherwise 'After' it
-(PPBannerVC *)vcNextTo:(UIViewController *)vc beforeOrAfter:(BOOL)beforeOrAfter {
    
    if (![vc isKindOfClass:[PPBannerVC class]]) {
        return nil;
    }
    
    PPBannerVC *nextVC = [_bannerPool dequeueBannerExclude:self.viewControllers];
    nextVC.bannerTapHandler = [self tapHandlerForVC];

    
    NSString *imageURL = ((PPBannerVC *)vc).image;
    NSInteger index = [_rollingImages indexOfObject:imageURL];
    if (index != NSNotFound) {
        NSInteger nextIndex = [self cycleChangeIndex:index delta:(beforeOrAfter ? -1 : 1) maxIndex:_rollingImages.count - 1];
        
        nextVC.image = _rollingImages[nextIndex];
        nextVC.index = nextIndex;
        
        return nextVC;
    }
    
    return nil;
}

-(BannderTapHandler)tapHandlerForVC {
    
    return ^void(NSInteger index) {
        if (_bannerTapHandler) {
            _bannerTapHandler(index);
        }
    };
}


#pragma mark -  UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {

    return [self vcNextTo:viewController beforeOrAfter:YES];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {

    return [self vcNextTo:viewController beforeOrAfter:NO];
}


#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    
    [self pauseRolling];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    [self resumeRolling];
    
    PPBannerVC *vc = pageViewController.viewControllers.firstObject;
    if ([vc isKindOfClass:[PPBannerVC class]]) {
        _pageControl.currentPage = vc.index;
    }
}

@end
