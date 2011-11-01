//
//  KalLargeView.m
//  Kal
//
//  Created by Andrew Shepard on 5/18/11.
//

#import "KalLargeView.h"


static const CGFloat kHeaderHeight = 44.f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalLargeView

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
	const CGFloat kChangeMonthButtonWidth = 46.0f;
	const CGFloat kChangeMonthButtonHeight = 30.0f;
	const CGFloat kMonthLabelWidth = 200.0f;
	const CGFloat kHeaderVerticalAdjust = 3.f;
	
	// Header background gradient
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kal.bundle/kal_grid_background.png"]];
	CGRect imageFrame = headerView.frame;
	imageFrame.origin = CGPointZero;
	backgroundView.frame = imageFrame;
	[headerView addSubview:backgroundView];
	[backgroundView release];
	
	// Create the previous month button on the left side of the view
	CGRect previousMonthButtonFrame = CGRectMake(self.left,
												 kHeaderVerticalAdjust,
												 kChangeMonthButtonWidth,
												 kChangeMonthButtonHeight);
	UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:previousMonthButtonFrame];
	[previousMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_left_arrow.png"] forState:UIControlStateNormal];
	previousMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	previousMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[previousMonthButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
	[headerView addSubview:previousMonthButton];
	[previousMonthButton release];
	
	// Draw the selected month name centered and at the top of the view
	CGRect monthLabelFrame = CGRectMake((self.width/2.0f) - (kMonthLabelWidth/2.0f),
										kHeaderVerticalAdjust,
										kMonthLabelWidth,
										kMonthLabelHeight);
	headerTitleLabel = [[UILabel alloc] initWithFrame:monthLabelFrame];
	headerTitleLabel.backgroundColor = [UIColor clearColor];
	headerTitleLabel.font = [UIFont boldSystemFontOfSize:22.f];
	headerTitleLabel.textAlignment = UITextAlignmentCenter;
	headerTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Kal.bundle/kal_header_text_fill.png"]];
	headerTitleLabel.shadowColor = [UIColor whiteColor];
	headerTitleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
	[self setHeaderTitleText:[logic selectedMonthNameAndYear]];
	[headerView addSubview:headerTitleLabel];
	
	// Create the next month button on the right side of the view
	CGRect nextMonthButtonFrame = CGRectMake(self.width - kChangeMonthButtonWidth,
											 kHeaderVerticalAdjust,
											 kChangeMonthButtonWidth,
											 kChangeMonthButtonHeight);
	UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:nextMonthButtonFrame];
	[nextMonthButton setImage:[UIImage imageNamed:@"Kal.bundle/kal_right_arrow.png"] forState:UIControlStateNormal];
	nextMonthButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	nextMonthButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[nextMonthButton addTarget:self action:@selector(showFollowingMonth) forControlEvents:UIControlEventTouchUpInside];
	[headerView addSubview:nextMonthButton];
	[nextMonthButton release];
	
	// Add column labels for each weekday (adjusting based on the current locale's first weekday)
	NSArray *weekdayNames = [[[[NSDateFormatter alloc] init] autorelease] shortWeekdaySymbols];
	NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
	NSUInteger i = firstWeekday - 1;
	for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 110.f, i = (i+1)%7) {
		CGRect weekdayFrame = CGRectMake(xOffset, 30.f, 110.f, kHeaderHeight - 29.f);
		UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
		weekdayLabel.backgroundColor = [UIColor clearColor];
		weekdayLabel.font = [UIFont boldSystemFontOfSize:16.f];
		weekdayLabel.textAlignment = UITextAlignmentCenter;
		weekdayLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f];
		weekdayLabel.shadowColor = [UIColor whiteColor];
		weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
		weekdayLabel.text = [weekdayNames objectAtIndex:i];
		[headerView addSubview:weekdayLabel];
		[weekdayLabel release];
	}
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
	// Both the tile grid and the list of events will automatically lay themselves
	// out to fit the # of weeks in the currently displayed month.
	// So the only part of the frame that we need to specify is the width.
	CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);
	
	// specify tile size for large devices
    
	CGSize largeTileSize = CGSizeMake([self tileSizeHeight], [self tileSizeWidth]);
	
	NSLog(@"%f, %f", largeTileSize.width, largeTileSize.height);
	
	// The tile grid (the calendar body)
	gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame tileSize:largeTileSize logic:logic delegate:delegate];
	[gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
	[contentView addSubview:gridView];
	
	// The list of events for the selected day
	tableView = [[UITableView alloc] initWithFrame:fullWidthAutomaticLayoutFrame style:UITableViewStylePlain];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[contentView addSubview:tableView];
	
	// Drop shadow below tile grid and over the list of events for the selected day
	shadowView = [[UIImageView alloc] initWithFrame:fullWidthAutomaticLayoutFrame];
	shadowView.image = [UIImage imageNamed:@"Kal.bundle/kal_grid_shadow.png"];
	shadowView.height = shadowView.image.size.height;
	[contentView addSubview:shadowView];
	
	// Trigger the initial KVO update to finish the contentView layout
	[gridView sizeToFit];
}

- (void)adjustForOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        NSLog(@"portrait");
    }
    else {
        NSLog(@"landscape");
        // [self setBounds:CGRectMake(0, 0, 100, 100)];
    }
    
    [gridView adjustForOrientation:orientation];
    [gridView sizeToFit];
}

#pragma mark - Kal Dimensions Helpers

- (CGFloat)tileSizeHeight {
    return 110.0f;
}

- (CGFloat)tileSizeWidth {
    return 110.0f;
}


@end
