//
//  CanvasViewController.h
//  CanvasViewController
//
//  Created by Xcode Developer on 8/6/21.
//

#import <UIKit/UIKit.h>
#import <PencilKit/PencilKit.h>
#import <Vision/Vision.h>

#import "CanvasView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanvasViewController : UIViewController <PKCanvasViewDelegate>

@property (strong, nonatomic) IBOutletCollection(CanvasView) NSArray * canvasViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray * imageViews;


@property (weak, nonatomic) IBOutlet UIImageView *numberImageView;
@property (weak, nonatomic) IBOutlet UILabel *topCandidatesLabel;

@property (strong, nonatomic) VNRecognizeTextRequest * textRequest;

@end

NS_ASSUME_NONNULL_END
