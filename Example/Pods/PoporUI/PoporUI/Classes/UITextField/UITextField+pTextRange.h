//
//  UITextField+pTextRange.h
//  PoporUI
//
//  Created by popor on 01/03/2019.
//  Copyright (c) 2019 popor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (pTextRange)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;

@end
