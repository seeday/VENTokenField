//
//  VENAutocompleteTableViewManager.m
//  Pods
//
//  Created by bnicholas on 8/8/14.
//
//

#import "VENAutocompleteTableViewManager.h"
#import "VENTokenField.h"

@interface VENAutocompleteTableViewManager ()

@property (nonatomic, strong) NSArray *options;

@end

@implementation VENAutocompleteTableViewManager

- (instancetype)initWithTokenField:(VENTokenField *)tokenField
{
    self = [super init];
    if (self) {
        self.tokenField = tokenField;
    }
    return self;
}

- (NSString *)valueForIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource tokenField:self.tokenField suggestionTitleForPartialText:self.tokenField.inputText atIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource tokenField:self.tokenField numberOfSuggestionsForPartialText:self.tokenField.inputText];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"autocompleteCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"autocompleteCell"];
    }
    
    cell.textLabel.text = [self valueForIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate autocompleteManagerDidSelectValue:[self valueForIndexPath:indexPath]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tokenField resignFirstResponder];
}

- (void)displayTableView
{
    [self.tableView reloadData];
    [self.tokenField.window addSubview:self.tableView];
}

- (void)hideTableView
{
    [self.tableView removeFromSuperview];
}

- (UITableView *)tableView
{
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.tokenField.frame),
                                 CGRectGetMaxY(self.tokenField.frame),
                                 CGRectGetWidth(self.tokenField.frame),
                                 CGRectGetHeight(self.tokenField.window.frame) - CGRectGetMaxY(self.tokenField.frame));
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:newFrame
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    } else {
        _tableView.frame = newFrame;
    }
    return _tableView;
}

@end
