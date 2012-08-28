//
//  TWLottoRandomSecondViewController.m
//  TWLottoRandom
//
//
//  Copyright (c) 2012 Wei-Chen Ling.
// 
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//



#import "TWLottoRandomSecondViewController.h"

@interface TWLottoRandomSecondViewController (PrivateMethods)

- (void)animatePickerTimer:(NSTimer *)timer;
- (void)showNumbersLabel;
- (void)enabledGoButton;
- (void)randomLottoNumber;

@end


@implementation TWLottoRandomSecondViewController

@synthesize picker;
@synthesize goButton;
@synthesize label;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    label.text = @"";
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [goButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    column = [[NSArray alloc] initWithObjects:@"--", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", 
               @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", 
               @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", 
               @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", 
               @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", nil];
    
    nums = [[NSMutableArray alloc] init];
        
    for (int i = 0; i <= 5; i++) {
        [picker selectRow:50 inComponent:i animated:NO];
    }
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    picker = nil;
    goButton =nil;
    label = nil;
    nums = nil;
    column = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)pressGoButton:(id)sender
{
    label.alpha = 0;
    pickerRow = 0;
    countingSeconds = 0;
    lastComponent = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(animatePickerTimer:) userInfo:nil repeats:YES];
    [goButton setEnabled:NO];
}


- (void)animatePickerTimer:(NSTimer *)timer
{
    for (int i = lastComponent; i <= 5; i++) {
        [picker selectRow:pickerRow inComponent:i animated:NO];
    }
    
    pickerRow++;
    countingSeconds++;
    
    if (pickerRow >= ([column count] * 7)) {
        pickerRow = 0;
    }
    
    if (countingSeconds == 160) {
        // 8s
        // geting random number
        [self randomLottoNumber];
        // stop component0
        lastComponent++;
        [picker selectRow:50 inComponent:0 animated:NO];
        int row = [[nums objectAtIndex:0] intValue] + [column count];
        [picker selectRow:row inComponent:0 animated:YES];
    }
    else if (countingSeconds == 180) {
        // +1s
        // stop component1
        lastComponent++;
        [picker selectRow:50 inComponent:1 animated:NO];
        int row = [[nums objectAtIndex:1] intValue] + [column count];
        [picker selectRow:row inComponent:1 animated:YES];
    }
    else if (countingSeconds == 200) {
        // +1s
        // stop component2
        lastComponent++;
        [picker selectRow:50 inComponent:2 animated:NO];
        int row = [[nums objectAtIndex:2] intValue] + [column count];
        [picker selectRow:row inComponent:2 animated:YES];
    }
    else if (countingSeconds == 220) {
        // +1s
        // stop component3
        lastComponent++;
        [picker selectRow:50 inComponent:3 animated:NO];
        int row = [[nums objectAtIndex:3] intValue] + [column count];
        [picker selectRow:row inComponent:3 animated:YES];
    }
    else if (countingSeconds == 240) {
        // +1s
        // stop component4
        lastComponent++;
        [picker selectRow:50 inComponent:4 animated:NO];
        [picker reloadComponent:4];
        int row = [[nums objectAtIndex:4] intValue] + [column count];
        [picker selectRow:row inComponent:4 animated:YES];
    }
    else if (countingSeconds == 260) {
        // +1s
        // stop component5
        lastComponent++;
        [picker selectRow:50 inComponent:5 animated:NO];
        int row = [[nums objectAtIndex:5] intValue] + [column count];
        [picker selectRow:row inComponent:5 animated:YES];

        // stop timer
        [timer invalidate];
        [self performSelector:@selector(showNumbersLabel) withObject:nil afterDelay:1];
    }
}


- (void)showNumbersLabel
{
    [UIView animateWithDuration:1.0 animations:^{
        [nums sortUsingSelector:@selector(compare:)];
        label.text = [[NSString alloc] initWithFormat:@"Numbers :  %@", [nums componentsJoinedByString:@", "]];
        label.alpha = 1.0;
    }];
    [nums removeAllObjects];
    //NSLog(@"nums (remove all objects): %@", nums);
    
    [self performSelector:@selector(enabledGoButton) withObject:nil afterDelay:1];
}


- (void)enabledGoButton
{
    [goButton setEnabled:YES];
}


- (void)randomLottoNumber
{
    NSMutableArray *tempColumn = [column mutableCopy];
    [tempColumn removeObjectAtIndex:0];
    
    NSMutableString *numsString = [[NSMutableString alloc] init];
    
    for (int i = 0; i <= 5; i++) {
        int randomNum = arc4random() % [tempColumn count];
        [numsString appendFormat:@"%@\n", [tempColumn objectAtIndex:randomNum]];
        
        //NSLog(@"%d => %@", i, [tempColumn objectAtIndex:randomNum]);
        
        [tempColumn removeObjectAtIndex:randomNum];
    }
    //NSLog(@"column count: %d", [column count]);
    //NSLog(@"tempColumn count: %d", [tempColumn count]);
    
    NSArray *tempNums = [numsString componentsSeparatedByString:@"\n"];
	[nums addObjectsFromArray:tempNums];
    [nums removeLastObject];
    //NSLog(@"nums: %@", nums);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    NSInteger num = [column count] * 7;
    return num;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [column objectAtIndex:(row % [column count])];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < [column count] || row >= (2 * [column count])) {
        row = row % [column count];
        row += [column count];
        [picker selectRow:row inComponent:component animated:NO];
    }
}

@end
