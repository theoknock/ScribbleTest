//
//  ViewController.h
//  ScribbleTest
//
//  Created by Xcode Developer on 7/25/21.
//

#import <UIKit/UIKit.h>
@import Vision;
#import <PencilKit/PencilKit.h>

#import "CanvasView.h"
@class CanvasView;

@interface ViewController : UIViewController <PKCanvasViewDelegate>

@property (weak, nonatomic) IBOutlet CanvasView *canvasView;
@property (strong, nonatomic) VNRecognizeTextRequest * textRequest;
@property (weak, nonatomic) IBOutlet UILabel *recognizedTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *validatedTextLabel;

@end

