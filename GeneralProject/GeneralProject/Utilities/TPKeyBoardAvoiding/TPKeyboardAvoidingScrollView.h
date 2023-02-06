
//MARK: GITHUB Source URL: https://github.com/michaeltyson/TPKeyboardAvoiding

#import <UIKit/UIKit.h>
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

@interface TPKeyboardAvoidingScrollView : UIScrollView <UITextFieldDelegate, UITextViewDelegate>
- (void)contentSizeToFit;
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end
