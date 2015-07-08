//
//  DMAboutViewController.m
//  DMDrogerie
//
//  Created by Vlada on 3/16/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMAboutViewController.h"

@interface DMAboutViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray* dataSource;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;

@end

@implementation DMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [btn setImage:[UIImage imageNamed:@"dmLogo_header.png"] forState:UIControlStateDisabled];
    [btn setTitle:@"  INFO" forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithRed:58.0/255.0 green:38.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [btn setEnabled:NO];
    [self.navigationItem setTitleView:btn];


    NSDictionary *attributes1 = @{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]};
    NSDictionary *attributes2 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : [UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]};
    NSMutableAttributedString* str1 = [[NSMutableAttributedString alloc] init];
    [str1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"dm mobilna aplikacija – nova unapređena verzija!\ndm aplikacija za smart telefone i tablet računare, u svakom trenutku pruža sve potrebne informacije o dvonedeljnim akcijskim ponudama, aktuelnim popustima i novim proizvodima u dm drogeriama u BiH.\nOmiljeni deo aplikacije je novi" attributes:attributes1]];
    [str1 appendAttributedString:[[NSAttributedString alloc] initWithString:@" dm Hair Color Expert " attributes:attributes2]];
    [str1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"koji Vam u svakom trenutku pruža mogućnost testiranja novih boja za kosu. Sve što treba da uradite jeste da se fotografišete i odaberete nijansu koju želite da probate. Pomaže Vam da odaberete novu boju kose bolje od kataloga farbi za kosu. dm aplikacija pomoći će Vam da odaberete onu nijansu koja najbolje pristaje mom stilu. Potrebno je da odvojite samo 5 minuta vrijemena za sebe i da istražite novu paletu boja svakog meseca. Sada tačno možete videti kako Vam boja kose, koju toliko dugo želite, zapravo pristaje.\n\nU delu" attributes:attributes1]];
    [str1 appendAttributedString:[[NSAttributedString alloc] initWithString:@" dm Nail Salon " attributes:attributes2]];
    [str1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"možete videti aktuelnu ponudu lakova za nokte omiljenih brendova.\n\nPomoću dm aplikacije informišite se o svim aktuelnim promocijama koje se u održavaju dm drogeriama, a ona takođe omogućava i lako pronalaženje najbliže dm prodavnice uz pomoć GPS-a i Google mapa, kao i informacije (broj telefona, adresa, radno vrijeme,...) o svim prodavnicama u BiH. Kreiranje šoping liste će značajno olakšati kupovinu svaki put kada ste u drogeriji.\nAplikacija zahteva postojanje aktivne Internet konekcije bilo putem WiFi-a ili mobilne mreže. Za preciznije pozicioniranje na mapi i prikaz najbližih lokacija dm prodavnica preporučujemo aktiviranje GPS senzora." attributes:attributes1]];
    
    
//    Dobrodošli!
//    
//    dm Hair Color Expert aplikacija Vam omogućava da na zabavan način testirate različite nijanse boja za kosu ukoliko želite promenu, prije nego što donesete konačnu odluku i uzmete farbu u ruke.
//    Ističemo da slika obojene kose ne odgovara originalnoj farbi, već predstavlja vizualni prikaz kako bi Vaša nova boja kose približno izgledala.
//    Stručnjaci preporučuju da prilikom farbanja birate boje za jednu ili dve nijanse svetlije ili tamnije od Vaše prirodne kose, kao i da se u slučaju većih promjena konsultujete sa Vašim frizerom. Prije donošenja odluke uzmite u obzir kvalitet Vaše kose, osnovnu boju kose i hemijske tretmane koje ste radile prije novog farbanja.
    
    NSMutableAttributedString* str2 = [[NSMutableAttributedString alloc] init];
    
    [str2 appendAttributedString:[[NSAttributedString alloc] initWithString:@"Dobrodošli!\n" attributes:attributes2]];
    [str2 appendAttributedString:[[NSAttributedString alloc] initWithString:@"\ndm Hair Color Expert aplikacija Vam omogućava da na zabavan način testirate različite nijanse boja za kosu ukoliko želite promenu, prije nego što donesete konačnu odluku i uzmete farbu u ruke.\nIstičemo da slika obojene kose ne odgovara originalnoj farbi, već predstavlja vizualni prikaz kako bi Vaša nova boja kose približno izgledala.\nStručnjaci preporučuju da prilikom farbanja birate boje za jednu ili dvije nijanse svetlije ili tamnije od Vaše prirodne kose, kao i da se u slučaju većih promjena konsultujete sa Vašim frizerom. Prije donošenja odluke uzmite u obzir kvalitet Vaše kose, osnovnu boju kose i hemijske tretmane koje ste radile pre novog farbanja." attributes:attributes1]];
    
    
    self.dataSource = @[@{@"isOpen": [NSNumber numberWithBool:NO], @"title": @"O aplikaciji", @"text": str1},
                        @{@"isOpen": [NSNumber numberWithBool:NO], @"title": @"Uslovi korišćenja", @"text": str2}];
    
    [self.tableView reloadData];
    
    [self.btnShare setTitleColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0] forState:UIControlStateNormal];
    [self.btnRate setTitleColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sectionClicked:(UIButton *)sender{
    
    NSLog(@"Section %d clicked", sender.tag);
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[self.dataSource objectAtIndex:sender.tag]];
    [dict setObject:[NSNumber numberWithBool:![[dict objectForKey:@"isOpen"] boolValue]] forKey:@"isOpen"];
    
    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.dataSource];
    [arr replaceObjectAtIndex:sender.tag withObject:dict];
    self.dataSource = [NSArray arrayWithArray:arr];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];

    
    
}

- (IBAction)btnShareClicked:(id)sender {
    
    NSURL* URL = [NSURL URLWithString:@"https://itunes.apple.com/app/dm-drogerie-markt-bih/id883163015"];
    
    
    
//    NSString* shareText = NSLocalizedString(@"share_text", @"");
    
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"DM BiH", URL] applicationActivities:nil];
    [activityVC setValue:NSLocalizedString(@"DM BiH", @"") forKey:@"subject"];
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
//        if (completed) {
//            if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
//                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"sharing" action:@"facebook" label:@"application" value:@1] build]];
//            }
//            else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
//                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"sharing" action:@"twitter" label:@"application" value:@1] build]];
//            }
//            else if ([activityType isEqualToString:UIActivityTypeMail]) {
//                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"sharing" action:@"mail" label:@"application" value:@1] build]];
//            }
//            else if ([activityType isEqualToString:UIActivityTypeMessage]) {
//                [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"sharing" action:@"message" label:@"application" value:@1] build]];
//            }
//            else{
//                
//            }
//        }
    }];
    
    
    
    NSArray* exclude = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    [activityVC setExcludedActivityTypes:exclude];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)btnRateClicked:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/dm-drogerie-markt-bih/id883163015"]];
    
}

#pragma mark - TableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary* dict = [self.dataSource objectAtIndex:section];
    
    if ([[dict objectForKey:@"isOpen"] boolValue]) {
        return 1;
    }
    else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView* hdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    [hdView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 50)];
    [imgView setContentMode:UIViewContentModeCenter];
    [imgView setTag:10];
    
    
    
    UILabel* lblText = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, hdView.frame.size.height)];
    [lblText setTextColor:[UIColor colorWithRed:21.0/255 green:7.0/255 blue:77.0/255 alpha:1.0]];
    [lblText setFont:[UIFont boldSystemFontOfSize:18]];
    
    NSDictionary* dict = [self.dataSource objectAtIndex:section];
    [lblText setText:[dict objectForKey:@"title"]];
    
    
    UIButton* btn = [[UIButton alloc] initWithFrame:hdView.frame];
    [btn setTag:section];
    [btn addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    
    [hdView addSubview:lblText];
    [hdView addSubview:imgView];
    [hdView addSubview:btn];
    
    
    if ([[dict objectForKey:@"isOpen"] boolValue]) {
        [imgView setImage:[UIImage imageNamed:@"arrow_down.png"]];
    }
    else{
        [imgView setImage:[UIImage imageNamed:@"arrow_right.png"]];
    }
    
    return hdView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dict = [self.dataSource objectAtIndex:indexPath.section];
    
    NSAttributedString *attrStr = [dict objectForKey:@"text"];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return rect.size.height + 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [Helper getStringFromStr:@"AboutCellIdentifier"];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        
        UILabel* lblText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.tableView.frame.size.width - 40, 0)];
        [lblText setTextColor:[UIColor blackColor]];
        [lblText setNumberOfLines:0];
        [lblText setTag:1];
        
        [cell addSubview:lblText];
    }
    
    UILabel* lblText = (UILabel *)[cell viewWithTag:1];
    NSDictionary* dict = [self.dataSource objectAtIndex:indexPath.section];
    
    NSAttributedString *attrStr = [dict objectForKey:@"text"];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGRect lblRct = lblText.frame;
    lblRct.size.height = rect.size.height;
    [lblText setFrame:lblRct];
    [lblText setAttributedText:attrStr];
    
    
    
    return cell;
    
}

@end
