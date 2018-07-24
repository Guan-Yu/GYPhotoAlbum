//
//  GYCollectionListView.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/9.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYCollectionListView.h"
#import "GYAsset.h"
#import "GYCollectionCell.h"

@interface GYCollectionListView()
<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation GYCollectionListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.hidden = true;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = true;
    [self initTableView];
}

- (void)setBrowser:(GYPhotoBrowser *)browser {
    _browser = browser;
    
    [_tableView reloadData];
}

- (void)initTableView {
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    tableview.rowHeight = 95;
    [self addSubview:tableview];
    _tableView = tableview;
}

- (void)show {
    self.hidden = false;
    _tableView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self->_tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)hide {
    _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self->_tableView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = true;
        }
    }];
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:GYCollectionCell_ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:GYCollectionCell_ID owner:nil options:nil] objectAtIndex:0];
    }
    cell.collection = _browser.assetCollections[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _browser.assetCollections.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _browser.currentCollection = _browser.assetCollections[indexPath.row];
    [self hide];
    if ([_delegate respondsToSelector:@selector(collectionListView:selectedAssetCollection:)]) {
        [_delegate collectionListView:self selectedAssetCollection:_browser.currentCollection];
    }
}

@end
