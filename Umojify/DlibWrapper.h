//
//  DlibWrapper.h
//  Umojify
//
//  Created by Jacob Silverstein on 8/5/16.
//  Copyright © 2016 Umojify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>


@interface DlibWrapper : UIViewController
- (instancetype)init;
-(void)doWorkOnSampleBuffer:(CMSampleBufferRef)sampleBuffer inRects:(NSArray<NSValue *> *)rects;
- (void)prepare;
-(long)getPointForIndex:(int)x Coord:(int)coord;

@end
