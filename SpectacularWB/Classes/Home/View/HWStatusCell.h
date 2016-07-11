

#import <UIKit/UIKit.h>
@class HWStatusFrame;

@interface HWStatusCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) HWStatusFrame *statusFrame;
@end
