# KYBarrageKit
This is a barrage of rendering library iOS high expansion, for most of the live broadcasting barrage scene.

[中文介绍](https://my.oschina.net/kinglyphp/blog/794767)

# reason

The company is doing direct business platform, products need to interface with the barrage in the live effect, there are some special animation effects, according to the needs of products, some open source projects combined with the Internet, he made the wheels, write a barrage of live rendering library, since meet the functional requirements of our products and.

# features

* 4 round support barrage rolling direction;
* the rolling speed custom barrage;
* the barrage of information for the `NSMutableAttributedString` type support, pictures and text barrage, Emoji emoticons etc.;
* When is `KYBarrageDisplayTypeImage` type barrage, barrage support custom height;
* the types can be extended (custom barrage currently supports plain text and graphics);
* using `CABasicAnimation` to achieve animation effects to barrage;
* supports batch sending barrage, barrage pause, restart, remove, start etc.;
* support a barrage of memory warning, remove a barrage of buffer pool.

To achieve some of the basic functions, more follow-up to improve the function......

Effect as shown below:

![](https://raw.githubusercontent.com/kingly09/KYBarrageKit/master/images/ba01.gif)


# feedback

*  if you need help, you can contact me or  [**weibo:**] (http://weibo.com/balenn) by using **QQ:** 362108564.
* If you found a bug, open an [**issue**](https://github.com/kingly09/KYBarrageKit/issues/new).
* If you have a feature request, open an [**issue**](https://github.com/kingly09/KYBarrageKit/issues/new).
* If you want to contribute, submit a pull request.

If there is anything you think is wrong, or have a better suggestion, the above contact can contact me. Thank you very much.


# installation
### requirements

* Xcode 7 +
* iOS 7.0 +

### installation manual

First [Download project](https://github.com/kingly09/KYBarrageKit.git) ,the **KYBarrageKit** sub folder into the project, import the `KYBarrageKit.h` header file in use.

### CocoaPods installation

You can add the following line of code to the **KYBarrageKit** to use the **Podfile**

```
	pod 'KYBarrageKit'
```

Use `cocoaPods` to manage the third party library, if the computer does not install `cocoapods`, please install the `cocoapods`. Installation method can refer to: [the latest cocoapods installation] (http://blog.sina.com.cn/s/blog_6ff6523d0102x8dq.html)

# usage


* in the need to use the function of local barrage rendering
 
 ``` 
  #import “KYBarrageKit”
 ```
 
* create a `KYBarrageManager *manager` object, and the view add that you want to add a barrage of animation view, as shown below:

```
@interface ViewController ()
@property (strong, nonatomic) KYBarrageManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
   self.view.backgroundColor = [UIColor whiteColor];
    _manager = [KYBarrageManager manager];
    _manager.bindingView = self.view;
    _manager.scrollSpeed = 30;     
    _manager.refreshInterval = 1.0;  
}
```

* send a barrage 
 
```
int a = arc4random() % 100000;
    NSString *str = [NSString stringWithFormat:@"I'm coming %d ",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    [_manager showBarrageWithDataSource:m]; // Scroll Barrage 
```

* set up a barrage of display area, support four direction, the default for the entire display area `KYBarrageDisplayLocationTypeDefault`

Global setting

```
_manager.displayLocation = KYBarrageDisplayLocationTypeTop;  

```
Or when the sub set barrage
 
```
   KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation       = _manager. KYBarrageDisplayLocationTypeTop;
 
```

Support for the display area of the corresponding `NSInteger` enumeration:

KYBarrageDisplayLocationType        | value| note 
----------------------------------- | -----| -------------
KYBarrageDisplayLocationTypeDefault  | 0   |  the entire display area
KYBarrageDisplayLocationTypeTop      | 1   |  the top part
KYBarrageDisplayLocationTypeCenter   | 2   |  the middle part 
KYBarrageDisplayLocationTypeBottom   | 3   |  the bottom part 
KYBarrageDisplayLocationTypeHidden   | 4   |  Hidden


* set the barrage position display support four direction.

Global setting

```
_manager.scrollDirection = KYBarrageScrollDirectRightToLeft;  
 
```
Or when the sub set barrage
 
```
   KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.direction       = _manager.scrollDirection;
 
```

Support for the enumeration of `NSInteger` in four directions:

KYBarrageScrollDirection            | value| note 
----------------------------------- | -----| -------------
KYBarrageScrollDirectRightToLeft    | 0   |  <<<<< 
KYBarrageScrollDirectLeftToRight    | 1   |  >>>>>
KYBarrageScrollDirectBottomToTop    | 2   |  ↑↑↑↑↑
KYBarrageScrollDirectTopToBottom    | 3   |  ↓↓↓↓↓



* active pull data set barrage barrage, commissioned by `KYBarrageManagerDelegate`, call the `-delegate barrageManagerDataSource` data

Set proxy，Open Access Initiative barrage

```
 _manager.delegate = self;
 [_manager startScroll]; //Open Access Initiative barrage
```

Calling method

```
- (id)barrageManagerDataSource {
    
    int a = arc4random() % 10000;
    NSString *str = [NSString stringWithFormat:@"%d digg",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation = _manager.displayLocation;
    m.direction       = _manager.scrollDirection;
    m.barrageType = KYBarrageDisplayTypeImage;
    m.object = [UIImage imageNamed:[NSString stringWithFormat:@"digg_%d",arc4random() % 10]];
    return m;
}
```

* set the clear barrage.

```
[_manager closeBarrage];
```

* set the barrage of pause and recovery.

 ``` 
     // 1. On the screen the barrage is suspended, and stop acquiring new barrage
     // 2. The current barrage on the screen to start rolling, and to obtain a new barrage
    [_manager pauseScroll];
 ```

* type setting barrage currently supports plain text and graphics `KYBarrageDisplayTypeDefault` `KYBarrageDisplayTypeImage`, can customize other types of `KYBarrageScene`.

 ```
 m.barrageType = KYBarrageDisplayTypeImage;
 ```
 
# Other

The click event support barrage


If a barrage of type `KYBarrageDisplayTypeImage` barrage, please rewrite the `ViewController` `touchesBegan` method

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    [[_manager barrageScenes] enumerateObjectsUsingBlock:^(BarrageScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.layer.presentationLayer hitTest:touchPoint]) {
           /* if barrage's type is ` `KYBarrageDisplayTypeImage` `, add your code here*/
            NSLog(@"message = %@",obj.model.message.string);
        }
    }];
}
```

Such as click inside the DEMO barrage, barrage pause 3S after rolling, can also be extended to other events, as shown below:


![](https://raw.githubusercontent.com/kingly09/KYBarrageKit/master/images/ba02.gif)


# encourage

If it accidentally gives you help, please do not mean to give it a **star**, it is the best support for it, thank you very much!

# LICENSE

**KYBarrageKit** is licensed under the **MIT** protocol. Access to the **LICENSE** file for more information.