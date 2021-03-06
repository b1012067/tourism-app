//
//  CourseTableViewController.m
//  tourism-app
//
//  Created by 河辺雅史 on 2014/10/24.
//  Copyright (c) 2014年 myname. All rights reserved.
//

#import "CourseTableViewController.h"

@interface CourseTableViewController ()

@end

@implementation CourseTableViewController

@synthesize course_name;
@synthesize isSpringChecked;
@synthesize isSummerChecked;
@synthesize isAutumnChecked;
@synthesize isWinterChecked;
@synthesize isParkChecked;
@synthesize isSeaChecked;

NSString *sortedType;
int numberOfIndexPath_row; //タップされたセルのindexを記録

/**
 Courseクラスのインスタンスが格納された配列を引数に、カテゴリ画面でチェックマークがついている項目に対応するコースを検索する
 */
- (void) getSearchedbyCategoryMutableArray:(NSMutableArray *)course_table_datas {
    for(int i = 0;i < [course_table_datas count];i++){
        int count = (int)[course_table_datas count]; //既にi番目のCourseインスタンスが削除されているか確認するための変数
        Course *course = [course_table_datas objectAtIndex:i];
        
        //「春のおすすめ」にチェックマークがついていて、Courseインスタンスのタグ情報が格納された配列に
        //「春」が含まれていない場合、Courseインスタンスを格納している配列からそのCourseインスタンスを削除する
        if(isSpringChecked){
            if(![course.tag_name containsObject:@"春"]){
                [course_table_datas removeObjectAtIndex:i];
                i--; //削除後for文に移ると、1つ飛ばして参照されるため、i--;
            }
        }
        
        //まだi番目のCourseインスタンスが削除されてなく、
        //「夏のおすすめ」にチェックマークがついていて、Courseインスタンスのタグ情報が格納された配列に
        //「夏」が含まれていない場合、Courseインスタンスを格納している配列からそのCourseインスタンスを削除する
        if(count == [course_table_datas count]){
            if(isSummerChecked){
                if(![course.tag_name containsObject:@"夏"]){
                    [course_table_datas removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        
        //まだi番目のCourseインスタンスが削除されてなく、
        //「秋のおすすめ」にチェックマークがついていて、Courseインスタンスのタグ情報が格納された配列に
        //「秋」が含まれていない場合、Courseインスタンスを格納している配列からそのCourseインスタンスを削除する
        if(count == [course_table_datas count]){
            if(isAutumnChecked){
                if(![course.tag_name containsObject:@"秋"]){
                    [course_table_datas removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        
        //まだi番目のCourseインスタンスが削除されてなく、
        //「冬のおすすめ」にチェックマークがついていて、Courseインスタンスのタグ情報が格納された配列に
        //「冬」が含まれていない場合、Courseインスタンスを格納している配列からそのCourseインスタンスを削除する
        if(count == [course_table_datas count]){
            if(isWinterChecked){
                if(![course.tag_name containsObject:@"冬"]){
                    [course_table_datas removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        
        //まだi番目のCourseインスタンスが削除されてなく、
        //「公園」にチェックマークがついていて、Courseインスタンスのタグ情報が格納された配列に
        //「公園」が含まれていない場合、Courseインスタンスを格納している配列からそのCourseインスタンスを削除する
        if(count == [course_table_datas count]){
            if(isParkChecked){
                if(![course.tag_name containsObject:@"公園"]){
                    [course_table_datas removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        
        //まだi番目のCourseインスタンスが削除されてなく、
        //「海」にチェックマークがついていて、Courseインスタンスのタグ情報が格納された配列に
        //「海」が含まれていない場合、Courseインスタンスを格納している配列からそのCourseインスタンスを削除する
        if(count == [course_table_datas count]){
            if(isSeaChecked){
                if(![course.tag_name containsObject:@"海"]){
                    [course_table_datas removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

/**
 Viewが表示される直前に呼び出される
 タブ等の切り替え等により、画面に表示されるたびに呼び出される
 */
- (void)viewWillAppear:(BOOL)animated {
    //ローディング表示を止める処理
    [SVProgressHUD dismiss];
    
    course_table_model = [[CourseModel alloc]init];
    
    //SegmentedContrlの初期状態が「距離順」なので、距離を降順でソート
    [course_table_model getSortedbyDistanceMutableArray:course_table_model->course_table_data];
    
    //他の画面で「戻る」を選択し、本画面に戻ってきた場合でもSegmented Controlに
    //対応するソート結果を保持するために、sortedType毎にソートする
    if([sortedType isEqualToString:@"distance"]){
        [course_table_model getSortedbyDistanceMutableArray:course_table_model->course_table_data];
    }else if([sortedType isEqualToString:@"calorie"]){
        [course_table_model getSortedbyCaloryMutableArray:course_table_model->course_table_data];
    }else if([sortedType isEqualToString:@"time"]){
        [course_table_model getSortedbyTimeMutableArray:course_table_model->course_table_data];
    }
    
    //カテゴリ画面でチェックマークがついている項目に対応するコースを検索
    [self getSearchedbyCategoryMutableArray:course_table_model->course_table_data];
    
    [self.myTableView reloadData];
}

/**
 SegmentedControlが変更された時に呼び出される
 */
- (IBAction)mySegmentedControlAction:(id)sender {
    if(self.mySegmentedControl.selectedSegmentIndex == 0){
        NSLog(@"距離順");
        //カテゴリ検索によりCourseクラスのインスタンスが格納された配列が空ではない場合、距離を降順でソート
        if([course_table_model->course_table_data count] != 0){
            [course_table_model getSortedbyDistanceMutableArray:course_table_model->course_table_data];
            sortedType = @"distance";
        }
    }else if(self.mySegmentedControl.selectedSegmentIndex == 1){
        NSLog(@"カロリー順");
        //カテゴリ検索によりCourseクラスのインスタンスが格納された配列が空ではない場合、消費カロリー(男性消費カロリー)を降順でソート
        if([course_table_model->course_table_data count] != 0){
            [course_table_model getSortedbyCaloryMutableArray:course_table_model->course_table_data];
            sortedType = @"calorie";
        }
    }else if(self.mySegmentedControl.selectedSegmentIndex == 2){
        NSLog(@"時間順");
        //カテゴリ検索によりCourseクラスのインスタンスが格納された配列が空ではない場合、所要時間を降順でソート
        if([course_table_model->course_table_data count] != 0){
            [course_table_model getSortedbyTimeMutableArray:course_table_model->course_table_data];
            sortedType = @"time";
        }
    }
    
    //TableViewの更新
    [self.myTableView reloadData];
}

/**
 @return Cellの高さ
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/**
 ロード時に呼び出される
 
 @return セクションに含まれるCellの数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [course_table_model->course_table_data count];
}

/**
 ロード時に呼び出される
 
 @return セルの内容
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //タグアイコンの設定
    UIImage *spring_image = [UIImage imageNamed:@"spring.png"];
    UIImageView *spring_tag = [[UIImageView alloc]initWithImage:spring_image];
    spring_tag.frame = CGRectMake(131, 62, 15, 15);
    
    UIImage *spring_on_image = [UIImage imageNamed:@"spring_on.png"];
    UIImageView *spring_on_tag = [[UIImageView alloc]initWithImage:spring_on_image];
    spring_on_tag.frame = CGRectMake(131, 62, 15, 15);
    
    UIImage *summer_image = [UIImage imageNamed:@"summer.png"];
    UIImageView *summer_tag = [[UIImageView alloc]initWithImage:summer_image];
    summer_tag.frame = CGRectMake(151, 62, 15, 15);
    
    UIImage *summer_on_image = [UIImage imageNamed:@"summer_on.png"];
    UIImageView *summer_on_tag = [[UIImageView alloc]initWithImage:summer_on_image];
    summer_on_tag.frame = CGRectMake(151, 62, 15, 15);
    
    UIImage *autumn_image = [UIImage imageNamed:@"autumn.png"];
    UIImageView *autumn_tag = [[UIImageView alloc]initWithImage:autumn_image];
    autumn_tag.frame = CGRectMake(171, 62, 15, 15);
    
    UIImage *autumn_on_image = [UIImage imageNamed:@"autumn_on.png"];
    UIImageView *autumn_on_tag = [[UIImageView alloc]initWithImage:autumn_on_image];
    autumn_on_tag.frame = CGRectMake(171, 62, 15, 15);
    
    UIImage *winter_image = [UIImage imageNamed:@"winter.png"];
    UIImageView *winter_tag = [[UIImageView alloc]initWithImage:winter_image];
    winter_tag.frame = CGRectMake(191, 62, 15, 15);
    
    UIImage *winter_on_image = [UIImage imageNamed:@"winter_on.png"];
    UIImageView *winter_on_tag = [[UIImageView alloc]initWithImage:winter_on_image];
    winter_on_tag.frame = CGRectMake(191, 62, 15, 15);
    
    UIImage *park_image = [UIImage imageNamed:@"park.png"];
    UIImageView *park_tag = [[UIImageView alloc]initWithImage:park_image];
    park_tag.frame = CGRectMake(211, 62, 15, 15);
    
    UIImage *park_on_image = [UIImage imageNamed:@"park_on.png"];
    UIImageView *park_on_tag = [[UIImageView alloc]initWithImage:park_on_image];
    park_on_tag.frame = CGRectMake(211, 62, 15, 15);
    
    UIImage *sea_image = [UIImage imageNamed:@"sea.png"];
    UIImageView *sea_tag = [[UIImageView alloc]initWithImage:sea_image];
    sea_tag.frame = CGRectMake(231, 62, 15, 15);
    
    UIImage *sea_on_image = [UIImage imageNamed:@"sea_on.png"];
    UIImageView *sea_on_tag = [[UIImageView alloc]initWithImage:sea_on_image];
    sea_on_tag.frame = CGRectMake(231, 62, 15, 15);
    
    //UITableViewのCellの値がスクロールするごとに重なったり壊れる,UITableViewでCell再描画時に文字が重なる
    //などの問題を防ぐために、CellのsubViewを消去する
    //タグアイコンを表示する前に、以前のsubviewsを削除する
    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    
    Course *course = [course_table_model->course_table_data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //display size
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    //コース名をCellのViewに追加する
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        NSLog(@"iPhoneの処理");
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x + 130, cell.textLabel.frame.origin.y - 40, bounds.size.width - 170, 120)];
        textLabel.text = course.course_name;
        [cell.contentView addSubview:textLabel];
    }else{
        NSLog(@"iPadの処理");
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.textLabel.frame.origin.x + 130, cell.textLabel.frame.origin.y - 40, bounds.size.width, 120)];
        textLabel.text = course.course_name;
        [cell.contentView addSubview:textLabel];
    }
    
    //コース詳細の1行目をCellのViewに追加する
    UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, -25, cell.frame.size.width, 130)];
    detailTextLabel.font = [UIFont systemFontOfSize:12];
    detailTextLabel.text = [NSString stringWithFormat:@"所用時間:%d分 距離:%.1fkm", course.time, course.distance];
    [cell.contentView addSubview:detailTextLabel];
    
    //コース詳細の2行目をCellのViewに追加する
    UILabel *detailTextLabelCal = [[UILabel alloc] initWithFrame:CGRectMake(130, -11, cell.frame.size.width, 130)];
    detailTextLabelCal.font = [UIFont systemFontOfSize:12];
    detailTextLabelCal.text = [NSString stringWithFormat:@"平均消費カロリー:%.1dcal", (course.male_calories + course.female_calories) / 2];
    [cell.contentView addSubview:detailTextLabelCal];
    
    //コースの画像をCellのViewに追加する
    UIImage *image = [UIImage imageNamed:course.course_image_name];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(10, 0, 110.0f, 79.0f);
    [cell.contentView addSubview:imageView];
    
    
    //タグアイコンの表示
    for(int i = 0;i < [course_table_model->course_table_data count];i++){
        Course *tag_course = [course_table_model->course_table_data objectAtIndex:i];
        
        if(indexPath.row == i){
            if(![tag_course.tag_name containsObject:@"春"]){
                [cell.contentView addSubview:spring_tag];
            }else{
                [cell.contentView addSubview:spring_on_tag];
            }
            if(![tag_course.tag_name containsObject:@"夏"]){
                [summer_on_tag removeFromSuperview];
                [cell.contentView addSubview:summer_tag];
            }else{
                [cell.contentView addSubview:summer_on_tag];
            }
            if(![tag_course.tag_name containsObject:@"秋"]){
                [cell.contentView addSubview:autumn_tag];
            }else{
                [cell.contentView addSubview:autumn_on_tag];
            }
            if(![tag_course.tag_name containsObject:@"冬"]){
                [cell.contentView addSubview:winter_tag];
            }else{
                [cell.contentView addSubview:winter_on_tag];
            }
            if(![tag_course.tag_name containsObject:@"公園"]){
                [cell.contentView addSubview:park_tag];
            }else{
                [cell.contentView addSubview:park_on_tag];
            }
            if(![tag_course.tag_name containsObject:@"海"]){
                [cell.contentView addSubview:sea_tag];
            }else{
                [cell.contentView addSubview:sea_on_tag];
            }
        }
    }
    
    return cell;
}

/**
 セルタップ時に呼び出される
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //ローディング表示処理
    [SVProgressHUD showWithStatus:@"読み込み中"];
    
    //ハイライトを外す
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //セルがタップされたときに呼ばれるアクションの設定
    numberOfIndexPath_row = (int)indexPath.row;
    [self performSelector:@selector(modalImagePicker) withObject:nil afterDelay:0.1];
}

/**
 セルがタップされたときに呼ばれるアクションメソッド
 */
-(void)modalImagePicker{
    for(int i = 0;i < [course_table_model->course_table_data count];i++){
        if(numberOfIndexPath_row == i){
            Course *course = [course_table_model->course_table_data objectAtIndex:i];
            course_name = course.course_name;
            [self performSegueWithIdentifier:@"detail" sender:self];
        }
    }
}


/**
 Segueが実行されると、実行直前に自動的に呼び出される
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CourseTableViewController *nextViewController = (CourseTableViewController *)[segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"detail"]){
        nextViewController.course_name = course_name;
    }else if ([[segue identifier] isEqualToString:@"tableTocategory"]){
        nextViewController.isSpringChecked = isSpringChecked;
        nextViewController.isSummerChecked = isSummerChecked;
        nextViewController.isAutumnChecked = isAutumnChecked;
        nextViewController.isWinterChecked = isWinterChecked;
        nextViewController.isParkChecked = isParkChecked;
        nextViewController.isSeaChecked = isSeaChecked;
    }
}

///戻るボタンのアクション
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 Viewの表示が完了後に呼び出される
 画面に表示されるたびに呼び出される
 */
- (void)viewDidAppear:(BOOL)animated {
    //スクロールバーの点滅
    [self.myTableView flashScrollIndicators];
    //表示後の処理
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
