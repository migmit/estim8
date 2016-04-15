// Generated by Apple Swift version 2.2 (swiftlang-703.0.18.1 clang-703.0.29)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import ObjectiveC;
@import Foundation;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;
@class NSURL;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;
@class NSManagedObjectContext;

SWIFT_CLASS("_TtC6Estim811AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
@property (nonatomic, strong) NSURL * _Nonnull applicationDocumentsDirectory;
@property (nonatomic, strong) NSManagedObjectModel * _Nonnull managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator * _Nonnull persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext * _Nonnull managedObjectContext;
- (void)saveContext;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC6Estim817SubViewController")
@interface SubViewController : UITableViewController
@property (nonatomic) BOOL parentNavigationBarHidden;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NumberOnlyText;
@class UITableView;
@class NSIndexPath;
@class NSNotification;
@class UITextField;
@class UITableViewCell;

SWIFT_CLASS("_TtC6Estim827CreateAccountViewController")
@interface CreateAccountViewController : SubViewController
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified accountTitleText;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified accountValueText;
@property (nonatomic, weak) IBOutlet UITableViewCell * _Null_unspecified positiveCell;
@property (nonatomic, weak) IBOutlet UITableViewCell * _Null_unspecified negativeCell;
@property (nonatomic, readonly, strong) NumberOnlyText * _Nonnull accountValueTextDelegate;
@property (nonatomic) BOOL isNegative;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)buttonSaveClicked;
- (void)somethingChanged;
- (void)notificationTitleChanged:(NSNotification * _Nonnull)notification;
- (void)notificationValueChanged:(NSNotification * _Nonnull)notification;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSDecimalNumber;
@class DecantViewController;

SWIFT_CLASS("_TtC6Estim825DecantChildViewController")
@interface DecantChildViewController : UITableViewController
@property (nonatomic, weak) IBOutlet UITableViewCell * _Null_unspecified fromCell;
@property (nonatomic, weak) IBOutlet UITableViewCell * _Null_unspecified toCell;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified amountText;
@property (nonatomic, strong) IBOutlet UITableView * _Null_unspecified settingsTable;
@property (nonatomic, strong) NumberOnlyText * _Nullable amountTextDelegate;
@property (nonatomic, weak) DecantViewController * _Nullable parent;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSDecimalNumber * _Nullable)getAmount;
- (void)setCellDetails:(BOOL)to title:(NSString * _Nonnull)title detail:(NSString * _Nullable)detail;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumberFormatter;

SWIFT_CLASS("_TtC6Estim814NumberOnlyText")
@interface NumberOnlyText : NSObject <UITextFieldDelegate>
@property (nonatomic) BOOL initialUsesGroupingSeparator;
@property (nonatomic) BOOL isEditing;
@property (nonatomic, readonly, strong) NSNumberFormatter * _Nonnull numberFormatter;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)setTextField:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldBeginEditing:(UITextField * _Nonnull)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField * _Nonnull)textField;
- (NSDecimalNumber * _Nullable)textToNumber:(NSString * _Nonnull)from;
- (void)setValue:(NSDecimalNumber * _Nonnull)value;
- (NSDecimalNumber * _Nonnull)getValue;
- (BOOL)textField:(UITextField * _Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string;
@end


SWIFT_CLASS("_TtC6Estim820DecantNumberOnlyText")
@interface DecantNumberOnlyText : NumberOnlyText
@property (nonatomic, weak) DecantViewController * _Nullable parent;
- (nonnull instancetype)initWithParent:(DecantViewController * _Nonnull)parent OBJC_DESIGNATED_INITIALIZER;
- (BOOL)textFieldShouldBeginEditing:(UITextField * _Nonnull)textField;
@end

@class UIPickerView;
@class UIScrollView;
@class UIStoryboardSegue;
@class NSLayoutConstraint;

SWIFT_CLASS("_TtC6Estim820DecantViewController")
@interface DecantViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>
@property (nonatomic) BOOL parentNavigationBarHidden;
@property (nonatomic) NSInteger fromSelected;
@property (nonatomic) NSInteger toSelected;
@property (nonatomic) BOOL editingTo;
@property (nonatomic, readonly, strong) NSNumberFormatter * _Nonnull numberFormatter;
@property (nonatomic, strong) DecantChildViewController * _Nullable child;
@property (nonatomic, weak) IBOutlet UIPickerView * _Null_unspecified pickler;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * _Null_unspecified containerHeight;
@property (nonatomic, weak) IBOutlet UIScrollView * _Null_unspecified scroll;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView * _Nonnull)pickerView;
- (NSInteger)pickerView:(UIPickerView * _Nonnull)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString * _Nullable)pickerView:(UIPickerView * _Nonnull)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(UIPickerView * _Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
- (void)somethingChanged;
- (void)fixFromToCells;
- (void)buttonDoneClicked;
- (void)notificationValueChanged:(NSNotification * _Nonnull)notification;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (void)showPickler:(BOOL)to;
- (void)setContainerHeightValue:(CGFloat)height;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIButton;
@class UILabel;

SWIFT_CLASS("_TtC6Estim825EditAccountViewController")
@interface EditAccountViewController : SubViewController
@property (nonatomic, weak) IBOutlet UILabel * _Null_unspecified accountNameLabel;
@property (nonatomic, weak) IBOutlet UITextField * _Null_unspecified accountValueText;
@property (nonatomic, readonly, strong) NumberOnlyText * _Nonnull accountValueTextDelegate;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)tableView:(UITableView * _Nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (IBAction)buttonDeleteClicked:(UIButton * _Nonnull)sender;
- (void)buttonSaveClicked;
- (void)somethingChanged;
- (void)notificationValueChanged:(NSNotification * _Nonnull)notification;
- (nonnull instancetype)initWithStyle:(UITableViewStyle)style OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@class NSDateFormatter;
@class UIGestureRecognizer;
@class UIBarButtonItem;
@class UIToolbar;
@class UINavigationBar;

SWIFT_CLASS("_TtC6Estim820SlicesViewController")
@interface SlicesViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITableViewDelegate>
@property (nonatomic, readonly) NSInteger panPointsCount;
@property (nonatomic, readonly, strong) NSDateFormatter * _Nonnull dateFormatter;
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified updatesTable;
@property (nonatomic, weak) IBOutlet UIToolbar * _Null_unspecified toolbar;
@property (nonatomic, weak) IBOutlet UINavigationBar * _Null_unspecified titleBar;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (BOOL)gestureRecognizer:(UIGestureRecognizer * _Nonnull)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer * _Nonnull)otherGestureRecognizer;
- (void)createDeleteButtonClicked;
- (IBAction)leftButtonClicked:(UIBarButtonItem * _Nonnull)sender;
- (IBAction)rightButtonClicked:(UIBarButtonItem * _Nonnull)sender;
- (IBAction)closeButtonClicked:(UIBarButtonItem * _Nonnull)sender;
- (void)panEvent:(UIGestureRecognizer * _Nonnull)recogniser;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC6Estim814ViewController")
@interface ViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView * _Null_unspecified accountsTable;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)viewDidAppear:(BOOL)animated;
- (void)prepareForSegue:(UIStoryboardSegue * _Nonnull)segue sender:(id _Nullable)sender;
- (BOOL)shouldPerformSegueWithIdentifier:(NSString * _Nonnull)identifier sender:(id _Nullable)sender;
- (NSInteger)tableView:(UITableView * _Nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSIndexPath * _Nullable)tableView:(UITableView * _Nonnull)tableView willSelectRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (BOOL)tableView:(UITableView * _Nonnull)tableView canEditRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (UITableViewCellEditingStyle)tableView:(UITableView * _Nonnull)tableView editingStyleForRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)tableView:(UITableView * _Nonnull)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (IBAction)buttonPlusClicked:(UIBarButtonItem * _Nonnull)sender;
- (IBAction)buttonDecantClicked:(id _Nonnull)sender;
- (IBAction)buttonSlicesClicked:(id _Nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
