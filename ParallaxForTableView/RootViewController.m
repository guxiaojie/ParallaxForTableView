//
//  RootViewController.m
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

#import "RootViewController.h"

@implementation RootViewController

- (id)init
{
    self = [super init ];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_refreshHeaderView == nil) {
        float delta = 0;
        CGRect tableRect = CGRectMake(0,delta,self.view.bounds.size.width,self.view.bounds.size.height - delta);
        tbView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        tbView.backgroundColor = [UIColor clearColor];
        tbView.delegate = self;
        tbView.dataSource = self;
        [(UIScrollView *)tbView setDelegate:self];
        tbView.layer.masksToBounds = NO;
        [self.view addSubview:tbView];

        float height = 150;
        CGRect frame = CGRectMake(0.0f, 0, self.view.frame.size.width, height);
		ImgRefreshTableHeaderView *view = [[ImgRefreshTableHeaderView alloc] initWithFrame:frame];
        [view setImagesHeight:height];
        [view setImages:[UIImage imageNamed:@"pig.jpg"]];
		view.delegate = self;
		_refreshHeaderView = view;
        tbView.tableHeaderView = view;
		[view release];

	}
	
	//  update the last update date

	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView bringSubviewToFront:cell];//only for iOS5, when refresh the parallax will show above cell
    [tableView sendSubviewToBack:tableView.tableHeaderView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.contentView.backgroundColor = [UIColor yellowColor];
    cell.textLabel.text = [NSString stringWithFormat:@"----%d",indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if (scrollView.contentOffset.y < -65) {
        CGPoint point = scrollView.contentOffset;
        point.y = -65;
        scrollView.contentOffset = point;
    }
	[_refreshHeaderView ImgRefreshScrollViewDidScroll:scrollView];
		
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView ImgRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark ImgRefreshTableHeaderDelegate Methods

- (void)ImgRefreshTableHeaderDidTriggerRefresh:(ImgRefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)ImgRefreshTableHeaderDataSourceIsLoading:(ImgRefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
    [super dealloc];
}


@end

