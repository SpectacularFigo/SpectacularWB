//
//  HWComposeToolBarView.m
//  SpectacularWB
//
//  Created by Figo Han on 2016-07-31.
//  Copyright © 2016 Figo Han. All rights reserved.
//

#import "HWComposeToolBarView.h"
#import "UIView+Extension.h"
@interface HWComposeToolBarView()
@property(nonatomic, weak) UIButton*button1;
@property(nonatomic, weak) UIButton*button2;
@property(nonatomic, weak) UIButton*button3;
@property(nonatomic, weak) UIButton*button4;
@property(nonatomic, weak) UIButton*button5;
@property(nonatomic, weak) UIButton*button6;
@end

@implementation HWComposeToolBarView
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        UIButton * button1 =[[UIButton alloc]init];
        
        [self setButton:button1 withNormalImage:@"compose_camerabutton_background" andHighlightedImage:@"compose_camerabutton_background_highlighted"];
        
        [self addSubview:button1];
        self.button1=button1;
        
        
        UIButton * button2 =[[UIButton alloc]init];
        [self setButton:button2 withNormalImage:@"compose_emoticonbutton_background" andHighlightedImage:@"compose_emoticonbutton_background_highlighted"];
        [self addSubview:button2];
        self.button2=button2;
        
        
        UIButton * button3 =[[UIButton alloc]init];
        [self setButton:button3 withNormalImage:@"compose_keyboardbutton_background" andHighlightedImage:@"compose_keyboardbutton_background_highlighted"];
        [self addSubview:button3];
        self.button3=button3;
        
        
        UIButton * button4 =[[UIButton alloc]init];
        [self setButton:button4 withNormalImage:@"compose_mentionbutton_background" andHighlightedImage:@"compose_mentionbutton_background_highlighted"];
        [self addSubview:button4];
        self.button4=button4;
        
        
        UIButton * button5 =[[UIButton alloc]init];
        [self setButton:button5 withNormalImage:@"compose_toolbar_picture" andHighlightedImage:@"compose_toolbar_picture_highlighted"];
        [self addSubview:button5];
        self.button5=button5;
        
        
        UIButton * button6 =[[UIButton alloc]init];
        [self setButton:button6 withNormalImage:@"compose_trendbutton_background" andHighlightedImage:@"compose_trendbutton_background_highlighted"];
        [self addSubview:button6];
        self.button6=button6;
        
        
    
    }
    
    
    return self;
    
    
}



-(void)setButton:(UIButton*) button withNormalImage:(NSString*)imageName andHighlightedImage:(NSString*)imageNameH
{
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNameH] forState:UIControlStateHighlighted];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<6; i++) {
        
        UIButton * button=self.subviews[i];
        button.x=self.width/6*i;
        button.y=0;
        button.width=self.width/6;
        button.height=self.height;
        
    }
    
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
