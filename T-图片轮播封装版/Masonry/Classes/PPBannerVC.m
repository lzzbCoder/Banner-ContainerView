
#import "PPBannerVC.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface PPBannerVC () {

    UIImageView         *_imageView;
    UIButton            *_btnTap;
    
}

@end




@implementation PPBannerVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    ///
    _btnTap = [UIButton new];
    [_btnTap addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnTap];
    [_btnTap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadImage];
}



#pragma mark -
-(void)tapped:(id)sender {

    if (_bannerTapHandler) {
        _bannerTapHandler(self.index);
    }
}


-(void)loadImage {
    if ([_image isKindOfClass:[NSString class]]) {
        
        [_imageView sd_cancelCurrentImageLoad];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_image]
                      placeholderImage:_placeHolder options:SDWebImageProgressiveDownload];
        
    } else if ([_image isKindOfClass:[UIImage class]]) {
        
        _imageView.image = _image;
        
    }
}


@end
