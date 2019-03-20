//
//  ViewController.m
//  ImageAndPdfDemo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "ViewController.h"

NSArray* imageNames() {
    static dispatch_once_t onceToken;
    static NSArray* _imageNames;
    dispatch_once(&onceToken, ^{
        _imageNames = [NSArray arrayWithObjects:
                       NSImageNameAddTemplate,
                       NSImageNameBluetoothTemplate ,
                       NSImageNameBonjour ,
                       NSImageNameBookmarksTemplate ,
                       NSImageNameCaution ,
                       NSImageNameComputer ,
                       NSImageNameEnterFullScreenTemplate ,
                       NSImageNameExitFullScreenTemplate ,
                       NSImageNameFolder ,
                       NSImageNameFolderBurnable ,
                       NSImageNameFolderSmart ,
                       NSImageNameFollowLinkFreestandingTemplate ,
                       NSImageNameHomeTemplate ,
                       NSImageNameIChatTheaterTemplate ,
                       NSImageNameLockLockedTemplate ,
                       NSImageNameLockUnlockedTemplate ,
                       NSImageNameNetwork ,
                       NSImageNamePathTemplate ,
                       NSImageNameQuickLookTemplate ,
                       NSImageNameRefreshFreestandingTemplate ,
                       NSImageNameRefreshTemplate ,
                       NSImageNameRemoveTemplate ,
                       NSImageNameRevealFreestandingTemplate ,
                       NSImageNameShareTemplate,
                       NSImageNameSlideshowTemplate ,
                       NSImageNameStatusAvailable ,
                       NSImageNameStatusNone ,
                       NSImageNameStatusPartiallyAvailable ,
                       NSImageNameStatusUnavailable ,
                       NSImageNameStopProgressFreestandingTemplate ,
                       NSImageNameStopProgressTemplate ,
                       NSImageNameTrashEmpty ,
                       NSImageNameTrashFull ,
                       nil];
    });
    return _imageNames;
}

@interface ViewController () <NSTableViewDelegate, NSTableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - NSTableViewDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [imageNames() count];
}

// view-base
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *cellIdentifier = @"PropertyCellID";
    NSString* text = [imageNames() objectAtIndex:row];
    NSTableCellView *cell = nil;
    if (tableColumn == tableView.tableColumns[0]) {
        cellIdentifier = @"cell.view.text";
        cell = [tableView makeViewWithIdentifier:cellIdentifier owner:self];
        cell.textField.stringValue = text;
    } else if (tableColumn == tableView.tableColumns[1]) {
        cellIdentifier = @"cell.view.image";
        NSImage* image = [NSImage imageNamed:text];
        cell = [tableView makeViewWithIdentifier:cellIdentifier owner:self];
        cell.imageView.image = image;
    }
    return cell;
}

// cell-based
//-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

//}

@end
