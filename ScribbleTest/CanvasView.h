//
//  CanvasView.h
//  CanvasView
//
//  Created by Xcode Developer on 7/27/21.
//

#import <UIKit/UIKit.h>
#import <PencilKit/PencilKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface CanvasView : PKCanvasView

@property (nonatomic, copy) IBInspectable UIColor * borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, weak, nullable) IBOutlet id<PKCanvasViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
