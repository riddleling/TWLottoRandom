//
//  TWLottoRandomFirstViewController.m
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



#import "TWLottoRandomFirstViewController.h"

@interface TWLottoRandomFirstViewController (PrivateMethods)

- (void)animatePickerTimer:(NSTimer *)timer;
- (void)showNumbersLabel;
- (void)enabledGoButton;
- (void)randomLottoNumber;

@end


@implementation TWLottoRandomFirstViewController

@synthesize picker;
@synthesize goButton;
@synthesize labelA1;
@synthesize labelA2;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    labelA1.text = @"";
    labelA2.text = @"";
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [goButton setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    
    column1 = [[NSArray alloc] initWithObjects:@"A1", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", 
               @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", 
               @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", 
               @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", nil];
    
    column2 = [[NSArray alloc] initWithObjects:@"A2", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", nil];
    nums = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= 5; i++) {
        [picker selectRow:39 inComponent:i animated:NO];
    }
    [picker selectRow:9 inComponent:6 animated:NO];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    picker = nil;
    goButton = nil;
    labelA1 = nil;
    labelA2 = nil;
    column1 = nil;
    column2 = nil;
    nums = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)pressGoButton:(id)sender
{
    labelA1.alpha = 0;
    labelA2.alpha = 0;
    pickerRowColumn1 = 0;
    pickerRowColumn2 = 0;
    countingSeconds = 0;
    lastComponent = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(animatePickerTimer:) userInfo:nil repeats:YES];
    [goButton setEnabled:NO];
}


- (void)animatePickerTimer:(NSTimer *)timer
{
    for (int i = lastComponent; i <= 5; i++) {
        [picker selectRow:pickerRowColumn1 inComponent:i animated:NO];
    }
    
    [picker selectRow:pickerRowColumn2 inComponent:6 animated:NO];
    
    pickerRowColumn1++;
    pickerRowColumn2++;
    countingSeconds++;
    
    if (pickerRowColumn1 >= ([column1 count] * 7)) {
        pickerRowColumn1 = 0;
    }
    
    if (pickerRowColumn2 >= ([column2 count] * 7)) {
        pickerRowColumn2 = 0;
    }
    
    
    if (countingSeconds == 160) {
        // 8s
        // geting random number
        [self randomLottoNumber];
        // stop component0
        lastComponent++;
        [picker selectRow:39 inComponent:0 animated:NO];
        int row = [[nums objectAtIndex:0] intValue] + [column1 count];
        [picker selectRow:row inComponent:0 animated:YES];
    }
    else if (countingSeconds == 180) {
        // +1s
        // stop component1
        lastComponent++;
        [picker selectRow:39 inComponent:1 animated:NO];
        int row = [[nums objectAtIndex:1] intValue] + [column1 count];
        [picker selectRow:row inComponent:1 animated:YES];
    }
    else if (countingSeconds == 200) {
        // +1s
        // stop component2
        lastComponent++;
        [picker selectRow:39 inComponent:2 animated:NO];
        int row = [[nums objectAtIndex:2] intValue] + [column1 count];
        [picker selectRow:row inComponent:2 animated:YES];
    }
    else if (countingSeconds == 220) {
        // +1s
        // stop component3
        lastComponent++;
        [picker selectRow:39 inComponent:3 animated:NO];
        int row = [[nums objectAtIndex:3] intValue] + [column1 count];
        [picker selectRow:row inComponent:3 animated:YES];
    }
    else if (countingSeconds == 240) {
        // +1s
        // stop component4
        lastComponent++;
        [picker selectRow:39 inComponent:4 animated:NO];
        [picker reloadComponent:4];
        int row = [[nums objectAtIndex:4] intValue] + [column1 count];
        [picker selectRow:row inComponent:4 animated:YES];
    }
    else if (countingSeconds == 260) {
        // +1s
        // stop component5
        lastComponent++;
        [picker selectRow:39 inComponent:5 animated:NO];
        int row = [[nums objectAtIndex:5] intValue] + [column1 count];
        [picker selectRow:row inComponent:5 animated:YES];
    }
    else if (countingSeconds == 280) {
        // +1s
        // stop component6
        lastComponent++;
        [picker selectRow:9 inComponent:6 animated:NO];
        // stop timer
        [timer invalidate];
        
        int row = [[nums objectAtIndex:6] intValue] + [column2 count];
        [picker selectRow:row inComponent:6 animated:YES];
        [self performSelector:@selector(showNumbersLabel) withObject:nil afterDelay:1];
        
    }
}


- (void)showNumbersLabel
{
    [UIView animateWithDuration:1.0 animations:^{
        labelA2.text = [[NSString alloc] initWithFormat:@"A2 :  %@", [nums objectAtIndex:6]];
        [nums removeLastObject];
    
        [nums sortUsingSelector:@selector(compare:)];
        labelA1.text = [[NSString alloc] initWithFormat:@"A1 :  %@", [nums componentsJoinedByString:@", "]];
        
        labelA1.alpha = 1.0;
        labelA2.alpha = 1.0;
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
    NSMutableArray *tempColumn1 = [column1 mutableCopy];
    [tempColumn1 removeObjectAtIndex:0];
    
    NSMutableString *numsString = [[NSMutableString alloc] init];
    
    for (int i = 0; i <= 5; i++) {
        int randomNumA1 = arc4random() % [tempColumn1 count];
        [numsString appendFormat:@"%@\n", [tempColumn1 objectAtIndex:randomNumA1]];
        
        //NSLog(@"%d => %@", i, [tempColumn1 objectAtIndex:randomNumA1]);
        
        [tempColumn1 removeObjectAtIndex:randomNumA1];
    }
    
    int randomNumA2 = (arc4random() % ([column2 count]-1)) + 1;
    
    [numsString appendFormat:@"%@\n", [column2 objectAtIndex:randomNumA2]];
    //NSLog(@"6 => %d", randomNumA2);
    
    NSArray *tempNums = [numsString componentsSeparatedByString:@"\n"];
	[nums addObjectsFromArray:tempNums];
    [nums removeLastObject];
    //NSLog(@"nums: %@", nums);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 7;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    if (component < 6) {
        NSInteger num = [column1 count]*7;
        return num;
    }
    else {
        NSInteger num = [column2 count]*7;
        return num;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component < 6) {
        return [column1 objectAtIndex:(row % [column1 count])];
    }
    else {
        return [column2 objectAtIndex:(row % [column2 count])];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component < 6) {
        if (row < [column1 count] || row >= (2 * [column1 count])) {
            row = row % [column1 count];
            row += [column1 count];
            [picker selectRow:row inComponent:component animated:NO];
        }
    }
    else {
        if (row < [column2 count] || row >= (2 * [column2 count])) {
            row = row % [column2 count];
            row += [column2 count];
            [picker selectRow:row inComponent:component animated:NO];
        }
    }
    
}

@end
