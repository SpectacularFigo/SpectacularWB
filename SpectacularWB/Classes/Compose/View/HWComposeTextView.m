
#import "HWComposeTextView.h"

@implementation HWComposeTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:self];
    }

    return self;

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
-(void)textDidChanged
{
    
    [self setNeedsDisplay];   // This method is called in the next runloop in NSRunloop rather than right away.
    
    
    
}
- (void)drawRect:(CGRect)rect {
    
    //if there is text , it will return without showing placeholder text.
    if (self.hasText) return;
    
    NSMutableDictionary * attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=self.font;
    attrs[NSForegroundColorAttributeName]=self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    CGFloat x=5;
    CGFloat w=rect.size.width-2*x;
    CGFloat  y=8;
    CGFloat  h=rect.size.height-2*y;
    CGRect  placeholderRect=CGRectMake(x, y, w, h);
 
    [self.placeholder drawWithRect:placeholderRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    
}
@end
