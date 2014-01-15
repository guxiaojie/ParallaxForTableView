//
//  ImgRefreshTableHeaderView.m
//  TableViewPull
//
//  Created by Vivian on 10/16/09October16.
//  Copyright Ku6. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
#import "ImgRefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface ImgRefreshTableHeaderView (Private)
@end

@implementation ImgRefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
    }
    return self;
}

#pragma mark -
#pragma mark Setters

-(void)setImagesHeight:(int)_imagesHeight{
    imagesHeight = _imagesHeight;
    
    imagesScrollStart = - imagesHeight/2-15;
    
    scrollingKoef = 0.2*imagesHeight/80.0;
}

-(void)setImages:(UIImage *)image
{    
    imagesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imagesScrollStart, self.frame.size.width, imagesHeight*2+20)];
    imagesScrollView.backgroundColor = [UIColor redColor];
    imagesScrollView.showsHorizontalScrollIndicator = NO;
    imagesScrollView.showsVerticalScrollIndicator = NO;
    imagesScrollView.bounces = YES;
    imagesScrollView.delegate = self;
    imagesScrollView.clipsToBounds = YES;
    imagesScrollView.scrollEnabled = NO;
    imagesScrollView.userInteractionEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, imagesScrollView.frame.size.width)];
    [imageView setImage:image];
    [imagesScrollView addSubview:imageView];
    [self addSubview:imagesScrollView];
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)ImgRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    float y = imagesScrollStart - scrollView.contentOffset.y*scrollingKoef;
    if (y < imagesScrollStart) {
        y = imagesScrollStart;
    }
   

    imagesScrollView.frame = CGRectMake(imagesScrollView.frame.origin.x, y, imagesScrollView.frame.size.width, imagesScrollView.frame.size.height);

	if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(ImgRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate ImgRefreshTableHeaderDataSourceIsLoading:self];
		}
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)ImgRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(ImgRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate ImgRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		if ([_delegate respondsToSelector:@selector(ImgRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate ImgRefreshTableHeaderDidTriggerRefresh:self];
		}
	}
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
    [imagesScrollView release];
    [super dealloc];
}


@end
