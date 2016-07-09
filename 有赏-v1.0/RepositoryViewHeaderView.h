//
//  RepositoryViewHeaderView.h
//  有赏-v1.0
//
//  Created by xfy on 16/1/12.
//  Copyright © 2016年 xfy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepositoryViewHeaderView : UIView<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *search;
+(RepositoryViewHeaderView*)getRepositoryViewHeaderView;
@end
