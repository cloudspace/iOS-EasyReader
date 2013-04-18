//
//  CSAutoCompleteViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/16/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSAutoCompleteViewController.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "CSStyledTableView.h"
#import "CSStyledTableViewCell.h"
#import "CSStyledTableViewHeaderFooterView.h"
#import "CSStyledTableViewStyleDark.h"

@implementation CSAutoCompleteViewController



#pragma mark - Overridden UIViewController methods
/**
 * Sets up the search bar and data connections
 */
- (void)viewDidLoad
{
  
  self.hasNavigationBar = NO;
  
  [super viewDidLoad];
  
  self.tableView_results.tableViewStyle = [[CSStyledTableViewStyleDark alloc] init];
  
  // Enable cancel button
  // This stupidly enables all controls on the bar but that's all we can do unless
  // Apple exposes a reference to the button specifically
  for (UIView *v in _searchBar.subviews) {
    if ([v isKindOfClass:[UIControl class]]) {
      ((UIControl *)v).enabled = YES;
    }
  }
  
  // Change the back button to say cancel (handle event manually since it's a new button)
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Cancel"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(handleBack)
                                 ];
  
  self.navigationItem.leftBarButtonItem = backButton;
  
  // Change back button from other screens to say Back instead of Search
  self.navigationItem.backBarButtonItem =
  [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                   style:UIBarButtonItemStyleBordered
                                  target:nil
                                  action:nil];
  
  
  // Set delegates for search bar and table view
  _searchBar.delegate = self;
  _tableView_results.delegate = self;
  _searchTerm = !$exists(_searchTerm) ? @"" : _searchTerm;

  
  [self searchBar:_searchBar textDidChange:_searchTerm];
  [self addObserver:self forKeyPath:@"autoCompleteData" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"autoCompleteData"])
  {
    [_tableView_results reloadData];
  }
}

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"autoCompleteData"];
}
/**
 * Sets the cursor by default onto the search bar
 */
- (void)viewDidAppear:(BOOL)animated {
  [_searchBar becomeFirstResponder];
  

  [super viewDidAppear:animated];
}


#pragma mark - General instance methods



/**
 * Loads the default list from the delegate into the form
 */
- (void) loadDefaultList
{
  if ([self.delegate respondsToSelector:@selector(autoComplete:loadDefaultList:)])
  {
    [MBProgressHUD hideAllHUDsForView:self.tableView_results animated:YES];
    
    [self.delegate autoComplete:self loadDefaultList:^(NSArray *autoCompleteData) {
      self.autoCompleteData = autoCompleteData;
      [self.tableView_results reloadData];
    }];
  }
}


#pragma mark - Properties
/**
 * Returns the current search term
 */
- (NSString *) searchTerm:(NSString *)searchTerm
{
  return _searchTerm;
}

/**
 * Sets the search term
 */
- (void) setSearchTerm:(NSString *)searchTerm
{
  _searchTerm = searchTerm;
  
  [self setTitle:_searchTerm];
  [_searchBar setText:_searchTerm];
  [self searchBar:_searchBar textDidChange:_searchTerm];
}


#pragma mark - UISearchBarDelegate methods
/**
 * Fires when the search button (on the keyboard) is clicked
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  if ([self.delegate respondsToSelector:@selector(autoComplete:didPressSearchWithTerm:)])
  {
    [self.delegate autoComplete:self didPressSearchWithTerm:_searchBar.text];
  }
}

/**
 * Fires when the search bar text changes
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  // Update internal search term
  _searchTerm = searchText;
  
  
  if ([searchText length] == 0)
  {
    // Load the default list when no text is available
    [self loadDefaultList];
  }
  else
  {
    // Get the results from the delegate and update the form
    [self.delegate autoComplete:self didChangeSearchTerm:_searchTerm onComplete:^(NSArray *autoCompleteData) {
      self.autoCompleteData = autoCompleteData;
    }];
  }
}

/**
 * Fires when the cancel button is pressed
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  if ([self.delegate respondsToSelector:@selector(didPressCancelbuttonForAutoComplete:)])
  {
    [self.delegate didPressCancelbuttonForAutoComplete:self];
  }
}


#pragma mark - Event Methods
/**
 * Goes to the previous screen
 */
- (void) handleBack
{
  // pop to root view controller
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource Methods
/**
 * Determines the number of sections in the table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.autoCompleteData count];
}

/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.autoCompleteData[section][@"items"] count];
}



// Height of the header in each section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 26;
}

// Height of all the cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}



// Generates a view for the header in each section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  //
  // Dequeue the header view
  //
  CSStyledTableViewHeaderFooterView *header = [self.tableView_results dequeueReusableHeaderFooterViewWithIdentifier:@"feedSearchHeader"];
  
  NSString *text = self.autoCompleteData[section][@"title"];
  
  // Set label
  [header.titleLabel setText:text];
  
  // Return the header
  return header;
}

/**
 * Determines the header title for each section
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return @"MY FEEDS";
}

/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Dequeue a styled cell
  CSStyledTableViewCell *cell = [self.tableView_results dequeueReusableCellWithIdentifier:@"feedSearchCell"];
  
  NSString *text = self.autoCompleteData[indexPath.section][@"items"][indexPath.row];
  
  if (self.autoCompleteData[indexPath.section][@"image"])
  {
    [cell.imageView setImage:self.autoCompleteData[indexPath.section][@"image"]];
    
    //
    // Add tap recognizer
    //
    if ([self.delegate respondsToSelector:@selector(autoComplete:didSelectImageAtIndexPath:)])
    {
      UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapRow:)];
      tapRecognizer.numberOfTapsRequired = 1;
      [cell.imageView addGestureRecognizer:tapRecognizer];
      tapRecognizer.delegate = self;
      cell.imageView.userInteractionEnabled = YES;
    }
  }
  
  [cell.textLabel setText:text];
    
  return cell;
}

#pragma mark - Actions
- (void) didTapRow:(id)sender
{
  UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
  CSStyledTableViewCell *cell = (CSStyledTableViewCell *)[[tapRecognizer.view superview] superview];
  NSIndexPath *indexPath = [self.tableView_results indexPathForCell:cell];

  
  [self.delegate autoComplete:self didSelectImageAtIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate Methods
/**
 * Fires the autoCompleteDidSelectItem delegate method on row click
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(autoComplete:didSelectRowAtIndexPath:)])
  {
    [self.delegate autoComplete:self didSelectRowAtIndexPath:indexPath];
  }
}



@end
