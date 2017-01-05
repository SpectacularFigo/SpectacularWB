

#import "HWStatusToolBar.h"
#import "UIView+Extension.h"
@implementation HWStatusToolBar
+(instancetype)toolBar
{
    
    return [[self alloc]init];
    
    
    
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    
    
    self=[super initWithFrame:frame];
    
    if (self) {
//           self.backgroundColor=[UIColor blackColor];
        
        UIButton*attitudeButton=[[UIButton alloc]init];
        self.attitudeButton=attitudeButton;
        [self addSubview:attitudeButton];
        [attitudeButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
        [attitudeButton setTitle:@"Like" forState:UIControlStateNormal];
        [attitudeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        attitudeButton.titleLabel.font=[UIFont systemFontOfSize:13];
        attitudeButton.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        
        
        UIButton*retweetedButton=[[UIButton alloc]init];
        self.retweetedButton=retweetedButton;
        [self addSubview:retweetedButton];
        [retweetedButton setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
        [retweetedButton setTitle:@"Repost" forState:UIControlStateNormal];
        [retweetedButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        retweetedButton.titleLabel.font=[UIFont systemFontOfSize:13];
        retweetedButton.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        
        UIButton*commentButton=[[UIButton alloc]init];
        self.commentButton=commentButton;
        [self addSubview:commentButton];
        [commentButton setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font=[UIFont systemFontOfSize:13];
        commentButton.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i=0; i<3; i++) {
        CGFloat buttonX=i*self.width/3;
        CGFloat buttonY=0;
        CGFloat buttonW=self.width/3;
        CGFloat buttonH=self.height;
        if (i==0) {
            self.retweetedButton.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        } else if (i==1)
        {
            self.commentButton.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        }
        else
        {
            
            self.attitudeButton.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
        }
    }
    
    
}

-(void)setToolBarButtonWithButton:(UIButton*)button andImageName:(NSString*)imageName andTile:(NSString*)title
{
    
    button=[[UIButton alloc]init];
    [self addSubview:button];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
}
@end
