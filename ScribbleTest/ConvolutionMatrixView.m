//
//  ConvolutionMatrixView.m
//  ConvolutionMatrixView
//
//  Created by Xcode Developer on 8/6/21.
//

#import "ConvolutionMatrixView.h"

@implementation ConvolutionMatrixView

static NSString * (^validateRecognizedText)(NSString *) = ^ (NSString * recognizedText) {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:recognizedText];
    
    if (!myNumber)
    {
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
            @"W": @"8",
            @"(": @"6",
            @"L": @"1",
            @"a": @"9",
            @"g": @"9",
            @"N": @"9",
            @"V": @"6",
            @"Z": @"0"
            
            
        };
        NSRange stringReplacementRange = NSMakeRange(0, 1);
        [[alphaNumericMap allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([validatedText replaceOccurrencesOfString:key withString:[alphaNumericMap valueForKey:key] options:NSLiteralSearch range:stringReplacementRange] > 0)
            {
                NSLog(@"Substituting %@ for %@", [alphaNumericMap valueForKey:key], key);
                *stop = TRUE;
            } else {
                NSLog(@"No occurrence of %@", key);
            }
            
            if (idx == ([alphaNumericMap count] - 1))
                NSLog(@"%@ invalid\n", validatedText);
        }];
        
        return validatedText;
    } else {
        NSLog(@"%@ valid\n", recognizedText);
        return (NSMutableString *)recognizedText;
    }
};

static NSString * (^imageNameForNumberString)(NSString *) = ^ NSString * (NSString * numberString)
{
    __block NSMutableString *imageName = [NSMutableString stringWithString:numberString];
    NSDictionary <NSString *, NSString *> * numericImageMap =
    @{
        @"0": @"0.circle",
        @"1": @"1.circle",
        @"2": @"2.circle",
        @"3": @"3.circle",
        @"4": @"4.circle",
        @"5": @"5.circle",
        @"6": @"6.circle",
        @"7": @"7.circle",
        @"8": @"8.circle",
        @"9": @"9.circle"
    };
    NSRange stringReplacementRange = NSMakeRange(0, 1);
    [[numericImageMap allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull numberString, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([imageName replaceOccurrencesOfString:numberString withString:[numericImageMap valueForKey:numberString] options:NSLiteralSearch range:stringReplacementRange] > 0)
            *stop = TRUE;
    }];
    
    return (NSString *)imageName;
};

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textRequest = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^ (UIImageView * imageView) {
        return ^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            if (!error)
            {
                NSArray<VNRecognizedText *> * topCandidates = [[request.results firstObject] topCandidates:10];
                NSMutableString * topCandidatesText = [[NSMutableString alloc] init];
                for (VNRecognizedText * recognizedText in topCandidates)
                {
                    NSString * validatedText = validateRecognizedText([recognizedText string]);
                    NSLog(@"Recognized text: %@", [recognizedText string]);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageView setImage:[UIImage systemImageNamed:imageNameForNumberString(validatedText)]];
                        [imageView setHidden:FALSE];
                        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                        f.numberStyle = NSNumberFormatterDecimalStyle;
                        NSNumber *myNumber = [f numberFromString:validatedText];
                        [self setElementValue:myNumber];
                    });
                    if ([validatedText rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length != 0)
                    {
                        break;
                    }
                }
            } else {
                NSLog(@"%@", error.description);
            }
            ////                    NSLog(@"%@\t%f\t%@", [recognizedText string], [recognizedText confidence], (r.length == 0) ? @"ALPHA" : @"NUMERIC");
        };
    }(self.imageView)];
    //    [_textRequest setRecognitionLevel:VNRequestTextRecognitionLevelAccurate];
    //    CGRect normalizedBounds = CGRectMake(0.0, 0.0, 1.0, 1.0);
    //    [_textRequest setRegionOfInterest:normalizedBounds];
}

// PKCanvasViewDelegate methods

- (void)canvasViewDidBeginUsingTool:(PKCanvasView *)canvasView
{
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView setHidden:TRUE];
    });
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
        @try {
            UIImage * drawingImage = (UIImage *)[canvasView.drawing imageFromRect:canvasView.bounds scale:0.33];
            CGImageRef drawingCGImage = drawingImage.CGImage;
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

@synthesize elementValue = _elementValue;

- (void)setElementValue:(NSNumber *)elementValue
{
    if ([elementValue.stringValue rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].length != 0)
    {
        _elementValue = elementValue;
    } else {
        _elementValue = [NSNumber numberWithUnsignedInt:1];
    }
    
    NSLog(@"Element value set to %@", _elementValue.stringValue);
    
}

- (NSNumber *)elementValue
{
    NSNumber * ev = _elementValue;
    if (!ev || ev == NULL)
    {
        ev = [[NSNumber alloc] initWithUnsignedInt:1];
        _elementValue = ev;
        
        return ev;
    } else {
        return _elementValue;
    }
}

@end
