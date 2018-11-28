//
//  MainTableViewController.m
//  ZCircleSliderDemo
//
//  Created by ZhangBob on 01/06/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()
@property (nonatomic, strong) NSArray *datas;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Circle Slider";
    
    self.datas = @[@{@"name":@"圆环形Slider，重复拖动", @"class":@"FirstViewController"},
                   @{@"name":@"圆环形Slider，限定360度", @"class":@"SecondViewController"},
                   @{@"name":@"圆环形Slider", @"class":@"ThirdViewController"}];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = _datas[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller = [[NSClassFromString(_datas[indexPath.row][@"class"]) alloc] init];
    controller.title = _datas[indexPath.row][@"name"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
