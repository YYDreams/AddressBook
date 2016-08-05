//
//  ContactTableController.m
//  AddressBook
//
//  Created by LOVE on 16/8/4.
//  Copyright © 2016年 LOVE. All rights reserved.
//

#import "ContactTableController.h"
#import "ChineseString.h"

#define kScreenWidth [[UIScreen mainScreen]applicationFrame].size.width
#define kScreenHeight [[UIScreen mainScreen]applicationFrame].size.height

#define kAlertWidth 88
#define kAlertHeight 88
#define kAlertFont 50
@interface ContactTableController ()

/* NSArray/NSMutableArray:一般使用strong修饰*/
@property(nonatomic,strong)NSMutableArray *indexArray; //右边的索引
/* <#注释#>*/
@property(nonatomic,strong)NSMutableArray *sotredArr;//联系人

/* <#注释#>*/
@property(nonatomic,weak)UILabel *alertLabel; //提示

/* <#注释#>*/
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ContactTableController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通讯录";

    [self RequestData];
    
    [self setupTableSeparator];

}

#pragma mark - RequestData
-(void)RequestData{

    NSArray *listArray = [NSArray arrayWithObjects:@"123",@"2342231",@"如果",@"一个",@"view内部的子控件",
                          @"比较多",@"一般会考虑自定义一个view",@"把它内部子",@"控件的创建屏蔽起来",@"不让外界关心",
                          @"外界",@"可以传入",@"对应的模型数据",@"给view",
                          @"封装控件的基本步骤",
                          @"在",@"initWithFrame",@"方法中添加",@"子控件",@"提供便利构造方法",
                          @"在1",@"layoutSubviews",@"方法中设置子控件的frame",@"（一定要调用",@"super的layoutSubviews)",
                          @"增加模型属性",@"在模型属性",@"set方法中",@"设置数据到子控件上",  @"￥h123$",@" $$￥flowerwer",nil];
    
    self.indexArray = [ChineseString IndexArray:listArray];
    self.sotredArr = [ChineseString LetterSortArray:listArray];
    
}

#pragma mark - OBJMethods
//设置taleView分割线
- (void)setupTableSeparator{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    
    //使分割线左边不留间距，需与willDisplayCell中的方法配合使用，或者在cellForRowAtIndexPath中使用也行
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

#pragma mark - SELMethods
-(void)showSelectedTitle:(NSString*)title{

    [self.alertLabel setText:title];
    self.alertLabel.hidden = NO;
    self.alertLabel.alpha = 1.0;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAnimation:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

-(void)timerAnimation:(NSTimer *)timer{

dispatch_async(dispatch_get_main_queue(), ^{
   
    [UIView animateWithDuration:0.25 animations:^{
        self.alertLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.alertLabel.hidden = YES;
    }];
});
    

}
#pragma mark - <UITableViewDelegate>

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{


    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *label =[[UILabel alloc]init];
    label.backgroundColor = [UIColor purpleColor];
    label.text = [self.indexArray objectAtIndex:section];
    
    label.textColor = [UIColor yellowColor];
    return label;

}

#pragma mark - <UITableViewDataSource>
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{


    return self.indexArray;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.indexArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{



    return [self.sotredArr[section] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    static NSString *const ContactID = @"ContactID";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ContactID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactID];
        
    }
    
    cell.textLabel.text =self.sotredArr[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    NSLog(@"%@",self.sotredArr[indexPath.section][indexPath.row]);
    
    NSString *message =[NSString stringWithFormat:@"%@",self.sotredArr[indexPath.section][indexPath.row]];
    UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:@"点击了" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertVC addAction:cancel];
    [alertVC addAction:OK];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    


}

//组头title
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString *headertitlestr = self.indexArray[section];
    
    return headertitlestr;


}

//点击右边索引的方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
  
    [self showSelectedTitle:title];
    return index;

}
#pragma mark - Setter&&Getter
//设置提示的Label
-(UILabel *)alertLabel{
    
    if (!_alertLabel) {
        
        UILabel *alertLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kAlertWidth, kAlertWidth)];
        
        alertLabel.center = self.view.center;
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.textColor = [UIColor redColor];
        alertLabel.font =[UIFont systemFontOfSize:kAlertFont];
        alertLabel.backgroundColor =[UIColor whiteColor];
        alertLabel.layer.cornerRadius = 10;
        alertLabel.layer.masksToBounds =YES;
        alertLabel.layer.borderWidth = 5.0f;
        alertLabel.layer.borderColor =[UIColor grayColor].CGColor;
        [self.navigationController.view addSubview:alertLabel];
        _alertLabel = alertLabel;
        self.alertLabel.hidden = YES;
        
    }
    
    return _alertLabel;
}
-(NSMutableArray *)indexArray{
    
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    
    return _indexArray;
}

-(NSMutableArray *)sotredArr{
    
    if (!_sotredArr) {
        _sotredArr =[NSMutableArray array];
    }
    return _sotredArr;
    
}
@end
