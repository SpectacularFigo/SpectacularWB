

#import "HWStatusCell.h"
#import "HWStatus.h"
#import "HWUser.h"
#import "HWStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "HWPhoto.h"
#import "Method.h"
#import "HWStatusToolBar.h"
@interface HWStatusCell()
/* 原创微博 */

/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) UIImageView *photoView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;




/** 转发微博 */
/** 转发微博整体 */
@property(nonatomic, weak) UIView*retweetedView;
/** 转发微博内容 */
@property(nonatomic, weak) UILabel*retweetedContentLabel;
/** 转发微博配图 */
@property(nonatomic, weak) UIImageView*retweetedPhotoImageView;




/** 工具条 */
@property(nonatomic,weak)HWStatusToolBar * toolBar;
@end

@implementation HWStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    HWStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HWStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        /**
               原创微博子控件初始化
         */

        /** 原创微博整体 */
        UIView *originalView = [[UIView alloc] init];
        self.contentView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        /** 头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [originalView addSubview:iconView];
        self.iconView = iconView;
        
        /** 会员图标 */
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [originalView addSubview:vipView];
        self.vipView = vipView;
        
        /** 配图 */
        UIImageView *photoView = [[UIImageView alloc] init];
        [originalView addSubview:photoView];
        self.photoView = photoView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = HWStatusCellNameFont;
        [originalView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = HWStatusCellTimeFont;
        [originalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        sourceLabel.font = HWStatusCellSourceFont;
        [originalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 正文 */                        //需要告诉他最大的宽度，然后给他字体，他才能通过字体然后计算有多少段（换行）
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = HWStatusCellContentFont;
        contentLabel.numberOfLines = 0;
        [originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        

        
        /**
         *  转发微博子控件初始化
         */
    
        /** 转发微博整体 */
        UIView * retweetedView=[[UIView alloc]init];
        retweetedView.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.85];
        [self.contentView addSubview:retweetedView];
        self.retweetedView=retweetedView;
        
        
        /** 转发微博内容 */
        UILabel * retweetedContentLabel=[[UILabel alloc]init];
        [self.retweetedView addSubview:retweetedContentLabel];
        self.retweetedContentLabel=retweetedContentLabel;
        self.retweetedContentLabel.font=[UIFont systemFontOfSize:12];
        self.retweetedContentLabel.numberOfLines=0;
        
        /** 转发微博配图 */
        UIImageView * retweetedPhotoImageView=[[UIImageView alloc]init];
        [self.retweetedView addSubview:retweetedPhotoImageView];
        self.retweetedPhotoImageView=retweetedPhotoImageView;
       
        
        
        
        
        /**
         *  工具条的初始化
         */
        HWStatusToolBar * toolbar=[HWStatusToolBar toolBar];
        self.toolBar=toolbar;
        [self.contentView addSubview:toolbar];
        
        
    }
    return self;
}



- (void)setStatusFrame:(HWStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    HWStatus *status = statusFrame.status;
    
    HWUser *user = status.user;
    
    HWStatus * retweeted_Status=status.retweeted_status;
    
    HWUser * retweetedUser=status.retweeted_status.user;
    
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    
    
    
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    
    
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;  //cell 循环利用了必须写no
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }

    
    
    /** 配图 */   //这里呢只显示一张配图
    if (status.pic_urls.count) { //有配图
        self.photoView.hidden=NO;
        self.photoView.frame = statusFrame.photoViewF;
//           self.photoView.backgroundColor = [UIColor redColor];
        HWPhoto * photo=[status.pic_urls firstObject];      //pic_urls 这个属性是一个数组，存储着HWPhoto模型
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    }
    else{  // 如果没有配图
        
        
        self.photoView.hidden=YES;
        
    }
   
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;

    /** 时间 */
    self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.text = status.source;
    self.sourceLabel.frame = statusFrame.sourceLabelF;

    /** 正文 */
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    
    
    /**
     *  转发微博数据对cell进行赋值,对cell的子控件进行frame赋值
     */
    
    if (status.retweeted_status) {
        // 转发微博
        self.retweetedView.hidden=NO;
        self.retweetedView.frame=statusFrame.retweetedViewF;
        
        // 转发微博内容
        self.retweetedContentLabel.frame=statusFrame.retweetedContentLabelF;
        NSString * retweetedContent=[NSString stringWithFormat:@"@%@:,%@",retweetedUser.name,retweeted_Status.text];
        self.retweetedContentLabel.text=retweetedContent;
        
        // 转发微博配图
        if (status.retweeted_status.pic_urls.count) {
            self.retweetedPhotoImageView.hidden=NO; // 防止循环出现
            self.retweetedPhotoImageView.frame=statusFrame.retweetedPhotoImageViewF;
            HWPhoto * retweetedPhoto=[retweeted_Status.pic_urls firstObject];
            [self.retweetedPhotoImageView sd_setImageWithURL:[NSURL URLWithString:retweetedPhoto.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        } else {
             self.retweetedPhotoImageView.hidden=YES;
        }

    }
    else{
        self.retweetedView.hidden=YES;
    }
    
    self.toolBar.frame=statusFrame.toolBarF;
    
    if (status.reposts_count) {
     NSString * retweetedContent=[NSString stringWithFormat:@"%d",status.reposts_count];
        
        self.toolBar.retweetedButton.titleLabel.text=retweetedContent;
    }
}




@end
