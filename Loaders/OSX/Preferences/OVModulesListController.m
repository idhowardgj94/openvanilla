//
//  OVIMListController.m
//  OpenVanilla
//
//  Created by zonble on 2008/7/4.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OVModulesListController.h"


@implementation OVModulesListController

- (void)awakeFromNib
{
	if (m_inputMethods == nil)
		m_inputMethods = [NSMutableArray new];
	if (m_ouputFilters == nil)
		m_ouputFilters = [NSMutableArray new];
	
	[u_outlineView setDelegate:self];
	[u_outlineView setDataSource:self];
	[u_outlineView expandItem:m_inputMethods];
	[u_outlineView expandItem:m_ouputFilters];
	[u_outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

- (void) dealloc
{
	[m_inputMethods release];
	[m_ouputFilters release];
	[super dealloc];
}


- (NSView *)view
{
	return u_mainView;
}
- (void)reload;
{
	[u_outlineView reloadData];
}

- (void)addInputMethod:(id)inputMethod
{
	if (m_inputMethods == nil) {
		m_inputMethods = [NSMutableArray new];
	}
	[m_inputMethods addObject:inputMethod];
}
- (void)addOutputFilter:(id)outputFilter
{
	if (m_ouputFilters == nil) {
		m_ouputFilters = [NSMutableArray new];
	}	
	[m_ouputFilters addObject:outputFilter];
}


- (void)switchToView: (NSView *)view
{
	if ([[u_settingView subviews] count]) {
		[[[u_settingView subviews] objectAtIndex:0] removeFromSuperview];
	}
	if (view) {
		NSRect frame = [view frame];
//		frame.origin.y = [u_settingView frame].size.height - frame.size.height;
		frame.size.height = [u_settingView frame].size.height;
		frame.size.width = [u_settingView frame].size.width;
		[view setFrame:frame];
		[u_settingView addSubview:view];
	}
}


#pragma mark outlineView delegate methods.

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil) {
		return 2;
	}	
	else if (item == m_inputMethods) {
		return [m_inputMethods count];
	}
	else if (item == m_ouputFilters) {
		return [m_ouputFilters count];
	}
	return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item
{
	return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if (item == nil || item == m_inputMethods || item == m_ouputFilters) {
		return YES;
	}
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView
			child:(int)index
		   ofItem:(id)item
{
	if (item == nil) {
		if (index == 0) {
			return m_inputMethods;
		}
		else if (index == 1) {
			return m_ouputFilters;
		}
	}
	else if (item == m_inputMethods) {
		return [m_inputMethods objectAtIndex:index];
	}
	else if (item == m_ouputFilters) {
		return [m_ouputFilters objectAtIndex:index];
	}
	
	return nil;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectTableColumn:(NSTableColumn *)tableColumn
{
	return NO;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
	if (item == m_inputMethods || item == m_ouputFilters) {
		return YES;
	}	
	return NO;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if ([[tableColumn identifier] isEqualToString:@"enabled"]) {
		return YES;
	}
	return NO;
}
- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if ([[tableColumn identifier] isEqualToString:@"enabled"]) {
		if (item == nil || item == m_inputMethods || item == m_ouputFilters) {
			return [[[NSCell alloc] initTextCell:@""] autorelease];
		}
	}
	return [tableColumn dataCell];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if ([[tableColumn identifier] isEqualToString:@"localizedName"]) {
		if (item == nil) {
			return @"/";
		}
		else if (item == m_inputMethods) {
			return @"Input Methods";
		}
		else if (item == m_ouputFilters) {
			return @"Output Filters";
		}
		else {			
			return [item localizedName];;
		}
	}
	else if ([[tableColumn identifier] isEqualToString:@"enabled"]) {
		if (item == nil || item == m_inputMethods || item == m_ouputFilters) {
			return nil;
		}
		else {
			BOOL enabled = [item isEnabled];
			return [NSNumber numberWithBool:enabled];
		}
	}
	return nil;
}

- (void)setCurrentItem:(id)item
{
	id tmp = _currentItem;
	_currentItem = [item retain];
	[tmp release];	
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	if (item == nil || item == m_inputMethods || item == m_ouputFilters) {
		return NO;
	}
	[self setCurrentItem:item];
	return YES;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[self switchToView:[_currentItem view]];
}

- (CGFloat)indentationPerLevel
{
	return 0;
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if (item == nil || item == m_inputMethods || item == m_ouputFilters) {
		return;
	}	
	if ([[tableColumn identifier] isEqualToString:@"enabled"]) {
		BOOL enabled = [object boolValue];
		[item setEnabled:enabled];
		NSString *identifier = [item moduleIdentifer];
		NSLog(identifier);
		if (m_preferenceController) {
			if (enabled == YES) {
				[m_preferenceController removeFromExcludeList:identifier];
			}
			else {
				[m_preferenceController addToExcludeList:identifier];
			}

		}		
	}
}

@end
