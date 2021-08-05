//
//  CanvasView.m
//  CanvasView
//
//  Created by Xcode Developer on 7/27/21.
//

#import "CanvasView.h"

@implementation CanvasView

@dynamic delegate;

- (id<PKCanvasViewDelegate>)delegate
{
    return super.delegate;
}

- (void)setDelegate:(id<PKCanvasViewDelegate>)delegate
{
    [super setDelegate:(id<PKCanvasViewDelegate>)delegate];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [super setScrollEnabled:FALSE];
    [super setDrawingPolicy:PKCanvasViewDrawingPolicyAnyInput];
    
//    PKInk * thickStrokeInk = [[PKInk alloc] initWithInkType:PKInkTypeMarker color:[UIColor whiteColor]];
//    NS_REFINED_FOR_SWIFT PKInkingTool * thickStrokeInkingTool = [[PKInkingTool alloc] initWithInkType:PKInkTypeMarker color:[UIColor whiteColor] width:6.0]; // [[PKInkingTool alloc] initWithInk:thickStrokeInk width:6.0];
//   
//    [self setTool:thickStrokeInkingTool];
    
    self.observationBoundsLayer = [[CALayer alloc] init];
    [self.layer addSublayer:self.observationBoundsLayer];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [self.layer setBorderColor:[borderColor CGColor]];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    [self.layer setBorderWidth:borderWidth];
}

@end
