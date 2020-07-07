#line 1 "Tweak.x"






#define PLIST_PATH @"/var/mobile/Library/Preferences/com.wrp1002.truedateprefs.plist"

bool GetPrefsBool(NSString *key) {
	return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}


int rolloverHour = 5;
int rolloverMinute = 0;



long GetHour() {
	NSDate *date = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents* components = [cal components:NSCalendarUnitHour|NSCalendarUnitMinute|NSWeekdayCalendarUnit fromDate:date];

	long hour = [components hour];

	return hour;
}

long GetMinute() {
	NSDate *date = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents* components = [cal components:NSCalendarUnitMinute fromDate:date];

	long minute = [components minute];

	return minute;
}

long GetWeekday() {
	NSDate *date = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents* components = [cal components:NSWeekdayCalendarUnit fromDate:date];

	long weekday = [components weekday];

	return weekday;
}

long GetDay() {
	NSDate *date = [NSDate date];
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents* components = [cal components:NSDayCalendarUnit fromDate:date];

	long day = [components day];

	return day;
}

bool ShouldRollover() {
	return (GetHour() >= rolloverHour && GetMinute() >= rolloverMinute);
}

void ShowAlert(NSString *msg) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
	message:msg
	delegate:nil
	cancelButtonTitle:@"Cool!"
	otherButtonTitles:nil];
	[alert show];
}



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class NSDateFormatter; @class SpringBoard; @class NSDateComponents; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static long long (*_logos_orig$_ungrouped$NSDateComponents$weekday)(_LOGOS_SELF_TYPE_NORMAL NSDateComponents* _LOGOS_SELF_CONST, SEL); static long long _logos_method$_ungrouped$NSDateComponents$weekday(_LOGOS_SELF_TYPE_NORMAL NSDateComponents* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$NSDateFormatter$stringFromDate$)(_LOGOS_SELF_TYPE_NORMAL NSDateFormatter* _LOGOS_SELF_CONST, SEL, id); static id _logos_method$_ungrouped$NSDateFormatter$stringFromDate$(_LOGOS_SELF_TYPE_NORMAL NSDateFormatter* _LOGOS_SELF_CONST, SEL, id); 

#line 73 "Tweak.x"


	static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
		_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);

		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		
		
		
		

		
		long weekday = GetWeekday();
		long hour = GetHour();
		

		bool active = GetPrefsBool(@"kActive");
		

		NSString *msg = [NSString stringWithFormat:@"Weekday:%ld  Hour:%ld  Active: %s", weekday, (long)hour, active ? "true" : "false"];

		ShowAlert(msg);
	}




	static long long _logos_method$_ungrouped$NSDateComponents$weekday(_LOGOS_SELF_TYPE_NORMAL NSDateComponents* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
		long day = _logos_orig$_ungrouped$NSDateComponents$weekday(self, _cmd);

		if (!ShouldRollover()) {
			day--;
			if (day < 0)
				day += 7;
		}

		return day;
	}




	static id _logos_method$_ungrouped$NSDateFormatter$stringFromDate$(_LOGOS_SELF_TYPE_NORMAL NSDateFormatter* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
		long weekdayNum = GetWeekday() - 1;
		
		NSString *format = [self dateFormat];
		[self setDateFormat:[format stringByReplacingOccurrencesOfString:@"E" withString:@"$"]];

		NSString *formattedDate = _logos_orig$_ungrouped$NSDateFormatter$stringFromDate$(self, _cmd, arg1);
		[self setDateFormat:format];

		int weekdayLength  = 0;
		for (int i = 0; i < formattedDate.length; i++) {
			if ([formattedDate characterAtIndex:i] == '$')
				weekdayLength++;
		}

		NSString *weekday;

		
		
		if (weekdayLength <= 3)
			weekday = [self shortWeekdaySymbols][weekdayNum];
		else
			weekday = [self weekdaySymbols][weekdayNum];

		NSString *result = [formattedDate stringByReplacingOccurrencesOfString:@"$" withString:weekday];

		return result;
	}



static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);}Class _logos_class$_ungrouped$NSDateComponents = objc_getClass("NSDateComponents"); { MSHookMessageEx(_logos_class$_ungrouped$NSDateComponents, @selector(weekday), (IMP)&_logos_method$_ungrouped$NSDateComponents$weekday, (IMP*)&_logos_orig$_ungrouped$NSDateComponents$weekday);}Class _logos_class$_ungrouped$NSDateFormatter = objc_getClass("NSDateFormatter"); { MSHookMessageEx(_logos_class$_ungrouped$NSDateFormatter, @selector(stringFromDate:), (IMP)&_logos_method$_ungrouped$NSDateFormatter$stringFromDate$, (IMP*)&_logos_orig$_ungrouped$NSDateFormatter$stringFromDate$);}} }
#line 147 "Tweak.x"
