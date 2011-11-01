//
//  KalLargeViewController.h
//  Kal
//
//  Modified by Andrew Shepard on 5/18/11.
//

// original work by
// https://github.com/dirkx/Kal
// https://github.com/dirkx/Kal/blob/master/src/KalPlainViewController.m

#import "KalLargeViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"

NSString *const KalPlainDataSourceChangedNotification = @"KalPlainDataSourceChangedNotification";

@interface KalLargeViewController ()
- (KalView*)calendarView;
@end

@implementation KalLargeViewController

@synthesize dataSource, delegate;
@synthesize initialSelectedDate;

- (id)initWithSelectedDate:(NSDate *)selectedDate withSize:(CGSize)_size
{
	size = _size;
	
	if ((self = [super init])) {
		logic = [[KalLogic alloc] initForDate:selectedDate];
		self.initialSelectedDate = [KalDate dateFromNSDate:selectedDate];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KalPlainDataSourceChangedNotification object:nil];
	}
	return self;
}

- (id)initWithSelectedDate:(NSDate *)selectedDate
{
	return [self initWithSelectedDate:selectedDate withSize:[[UIScreen mainScreen] applicationFrame].size];
}

- (id)initWithFrame:(CGSize)_size
{
	return [self initWithSelectedDate:[NSDate date] withSize:(CGSize)_size];
}

- (id)init
{
	return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
	if (dataSource != aDataSource) {
		[dataSource release];
		[aDataSource retain];
		dataSource = aDataSource;
	}
}

- (void)reloadData
{
	[dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
	[[self calendarView] jumpToSelectedMonth];
	[self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
	NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
	NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
	[dataSource loadItemsFromDate:from toDate:to];

	[delegate didSelectDate:date];
}

- (void)showPreviousMonth
{
	[logic retreatToPreviousMonth];
	[[self calendarView] slideDown];
	[self reloadData];

	[delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
	[logic advanceToFollowingMonth];
	[[self calendarView] slideUp];
	[self reloadData];

	[delegate showFollowingMonth];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
	NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
	NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
	for (int i=0; i<[dates count]; i++)
		[dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
	
	[[self calendarView] markTilesForDates:dates];
    
    // Initialize myself with the actual date as shown.
	[self didSelectDate:self.calendarView.selectedDate];    
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
	if ([[self calendarView] isSliding])
		return;
	
	[logic moveToMonthForDate:date];
	
	[[self calendarView] jumpToSelectedMonth];
	
	[[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
	[self reloadData];
}

// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)loadView
{
	CGRect frame;
	frame.origin.x = 0.0;
	frame.origin.y = 0.0;
	frame.size = size;
	
	KalLargeView *kalView = [[KalLargeView alloc] initWithFrame:frame delegate:self logic:logic];
	self.view = kalView;
	
	[kalView selectDate:initialSelectedDate];
	[kalView release];
	
	[self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [(KalLargeView *)self.view adjustForOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"didRotate:");
}

#pragma mark -

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:KalPlainDataSourceChangedNotification object:nil];
	[initialSelectedDate release];
	[logic release];
	[super dealloc];
}

@end
