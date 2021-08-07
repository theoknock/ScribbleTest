//
//  ConvolutionMatrixView.h
//  ConvolutionMatrixView
//
//  Created by Xcode Developer on 8/6/21.
//

#import <UIKit/UIKit.h>
#import <PencilKit/PencilKit.h>
#import <Vision/Vision.h>

#import "CanvasView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConvolutionMatrixView : UIView <PKCanvasViewDelegate>

@property (weak, nonatomic) IBOutlet CanvasView * canvasView;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;

@property (strong, nonatomic) VNRecognizeTextRequest * textRequest;

@property (assign, nonatomic, getter=elementValue, setter=setElementValue:) NSNumber * elementValue;


@end

NS_ASSUME_NONNULL_END
