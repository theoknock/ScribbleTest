//
//  ViewController.m
//  ScribbleTest
//
//  Created by Xcode Developer on 7/25/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString * (^validateRecognizedText)(NSString *) = ^ (NSString * recognizedText) {
    __block NSMutableString *validatedText = [NSMutableString stringWithString:recognizedText];
    NSDictionary <NSString *, NSString *> * alphaNumericMap =
    @{
        @"s": @"5",
        @"S": @"5",
        @"o": @"0",
        @"Q": @"0",
        @"O": @"0",
        @"i": @"1",
        @"I": @"1",
        @"l": @"1",
        @"B": @"8",
        @"b": @"6",
        @"q": @"9",
        @"T": @"1",
        @"C": @"8",
        @"e": @"8",
        @"W": @"8"
    };
    NSRange stringReplacementRange = NSMakeRange(0, 1);
    [[alphaNumericMap allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([validatedText replaceOccurrencesOfString:key withString:[alphaNumericMap valueForKey:key] options:NSLiteralSearch range:stringReplacementRange] > 0)
        {
            NSLog(@"%@:\t\tSubstituting %@ for %@", validatedText, [alphaNumericMap valueForKey:key], key);
        } else {
            NSLog(@"Validated %@ as %@ (no occurrences of %@)", validatedText, [alphaNumericMap valueForKey:key], key);
        }
    }];
    
    NSLog(@"Validated text\t\t%@", validatedText);
    
    return validatedText;
};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textRequest = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^ (CALayer * canvasViewObservationBoundsLayer, UILabel * recognizedTextLabel, UILabel * validatedTextLabel) {
        return ^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            if (!error)
            {
                //                NSArray <VNTextObservation *> * observations = request.results;
                //                NSArray <VNRectangleObservation *> * rectangles = [((VNTextObservation *)observations.firstObject) characterBoxes];
                //                CGRect observationBounds = rectangles.firstObject.boundingBox;
                //                dispatch_async(dispatch_get_main_queue(), ^{
                //                    [canvasViewObservationBoundsLayer setBounds:observationBounds];
                //                    [canvasViewObservationBoundsLayer setBorderWidth:1.0];
                //                    [canvasViewObservationBoundsLayer setBorderColor:[UIColor redColor].CGColor];
                //                });
                
                NSArray<VNRecognizedText *> * topCandidates = [[request.results firstObject] topCandidates:10];
                for (VNRecognizedText * recognizedText in topCandidates)
                {
                    NSString * validatedText = validateRecognizedText([recognizedText string]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [recognizedTextLabel setText:[recognizedText string]];
                        [validatedTextLabel setText:validatedText];
                    });
                    if ([validatedText rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length != 0)
                    {
                        break;
                    } else {
                        [validatedTextLabel setText:@""];
                    }
                }
            } else {
                NSLog(@"%@", error.description);
            }
            ////                    NSLog(@"%@\t%f\t%@", [recognizedText string], [recognizedText confidence], (r.length == 0) ? @"ALPHA" : @"NUMERIC");
        };
    }(self.canvasView.observationBoundsLayer, self.recognizedTextLabel, self.validatedTextLabel)];
    //    [_textRequest setRecognitionLevel:VNRequestTextRecognitionLevelAccurate];
    //    CGRect normalizedBounds = CGRectMake(0.0, 0.0, 1.0, 1.0);
    //    [_textRequest setRegionOfInterest:normalizedBounds];
}

// PKCanvasViewDelegate methods

- (void)canvasViewDidBeginUsingTool:(PKCanvasView *)canvasView
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)canvasViewDidEndUsingTool:(PKCanvasView *)canvasView
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)canvasViewDrawingDidChange:(PKCanvasView *)canvasView
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (canvasView.drawing.strokes.count != 0)
    {
        UIImage * drawingImage = (UIImage *)[canvasView.drawing imageFromRect:canvasView.bounds scale:0.33];
        CGImageRef drawingCGImage = drawingImage.CGImage;
        @try {
            __autoreleasing NSError * error = nil;
            VNImageRequestHandler * imageRequestHandler =
            [[VNImageRequestHandler alloc] initWithCGImage:drawingCGImage orientation:kCGImagePropertyOrientationUp options:@{}];
            [imageRequestHandler performRequests:@[_textRequest] error:&error];
            if (error)
                NSLog(@"Error performing text analysis request:\t%@", error.description);
        } @catch (NSException *exception) {
            NSLog(@"Error performing requests:\n\n%@", exception.debugDescription);
        } @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.drawingImageView setImage:drawingImage];
                [canvasView setDrawing:[PKDrawing new]];
            });
        }
    }
}

- (void)canvasViewDidFinishRendering:(PKCanvasView *)canvasView
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!canvasView.drawing || canvasView.drawing == nil)
        {
            return;
        }
    });
}

@end
