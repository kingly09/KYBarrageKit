# KYBarrageKit
这是一个iOS高扩展的弹幕渲染库，适用大多数直播类弹幕场景。

# 原因
公司是做直播电商平台的，产品需要在直播界面有弹幕效果，还有一些特殊的动画效果，根据产品提供的需要，结合网上的一些开源项目，自己造了轮子，写一个直播类弹幕渲染库，以来满足我们产品多变的功能需求。

# 特征
* 支持弹幕的4个方位滚动方向；
* 自定义弹幕的滚动速度；
* 弹幕信息为`NSMutableAttributedString`类型，支持图片和文字弹幕，emoji表情符号等；
* 当是弹幕为`KYBarrageDisplayTypeImage`类型是，支持弹幕自定义高度；
* 弹幕的类型可以扩展自定义（目前支持纯文本和图文）；
* 采用`CABasicAnimation`实现来弹幕动画效果；
* 支持批量主动发送弹幕，弹幕的暂停，清除，重启，开始等；
* 支持弹幕内存预警，清除弹幕缓冲池。

实现一些基础功能，更多的功能后续完善中......

效果如下图所示：

# 反馈


*  如果需要帮助，可以使用**QQ:** 362108564联系我 或**weibo:** [http://weibo.com/balenn](http://weibo.com/balenn) 留言.
* 如果你发现了一个bug，打开一个 **issue**.
* 如果您有一个功能请求，请打开一个 **issue**.
* 如果您想贡献，请提交一个请求.

如果有任何你觉得不对的地方，或有更好的建议，以上联系都可以联系我。 十分感谢！


# 安装
### 要求

* Xcode 7 +
* iOS 7.0 +

### 手动安装

先[下载项目](https://github.com/kingly09/KYBarrageKit.git)后,将子文件夹 **KYBarrageKit** 拖入到项目中, 导入头文件`KYBarrageKit.h` 开始使用.

### CocoaPods安装

你可以在 **Podfile** 中加入下面一行代码来使用 **KYBarrageKit**

```
	pod 'KYBarrageKit'
```

使用 `cocoaPods` 管理第三方库， 如果电脑没有安装 `cocoapods`，请先安装 `cocoapods`。安装方式可参考：[最新的cocoapods安装] (http://blog.sina.com.cn/s/blog_6ff6523d0102x8dq.html)

# 使用

* 在需要使用弹幕渲染功能的地方
 
 ``` 
  #import “KYBarrageKit”
 ```
 
* 创建一个 `KYBarrageManager *manager` 对象，并将其 view add 到你想要添加弹幕动画的 view 上，如下面所示：

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

* 发送一个弹幕 
 
```
int a = arc4random() % 100000;
    NSString *str = [NSString stringWithFormat:@"I'm coming %d ",a];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:RandomColor() range:NSMakeRange(0, str.length)];
    
    KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    [_manager showBarrageWithDataSource:m]; // Scroll Barrage 
```

* 设置弹幕显示区域，支持四个方向，默认为 `KYBarrageDisplayLocationTypeDefault` 整个显示区域

全局设置

```

_manager.displayLocation = KYBarrageDisplayLocationTypeTop;  
 
```
或 当个子弹幕设置
 
```
   KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.displayLocation       = _manager. KYBarrageDisplayLocationTypeTop;
 
```

支持显示区域对应`NSInteger`的枚举:

KYBarrageDisplayLocationType        | value| note 
----------------------------------- | -----| -------------
KYBarrageDisplayLocationTypeDefault  | 0   |  整个显示区域
KYBarrageDisplayLocationTypeTop      | 1   |  顶部部分
KYBarrageDisplayLocationTypeCenter   | 2   |  中间部分
KYBarrageDisplayLocationTypeBottom   | 3   |  底部部分
KYBarrageDisplayLocationTypeHidden   | 4   |  不显示

* 设置弹幕显示位置，支持四个方向。

全局设置

```

_manager.scrollDirection = KYBarrageScrollDirectRightToLeft;  
 
```
或 当个子弹幕设置
 
```
   KYBarrageModel *m = [[KYBarrageModel alloc] initWithBarrageContent:attr];
    m.direction       = _manager.scrollDirection;
 
```
支持四个方向对应`NSInteger`的枚举:

KYBarrageScrollDirection            | value| note 
----------------------------------- | -----| -------------
KYBarrageScrollDirectRightToLeft    | 0   |  <<<<< 
KYBarrageScrollDirectLeftToRight    | 1   |  >>>>>
KYBarrageScrollDirectBottomToTop    | 2   |  ↑↑↑↑↑
KYBarrageScrollDirectTopToBottom    | 3   |  ↓↓↓↓↓



* 主动拉取弹幕数据发弹幕，设置 `KYBarrageManagerDelegate` 委托，调用`-delegate barrageManagerDataSource`返回数据

设置代理委托

```
 _manager.delegate = self;
 [_manager startScroll]; //开启主动获取弹幕
```

调用方法

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

* 设置清除弹幕。

```
[_manager closeBarrage];
```

* 设置弹幕的暂停与恢复。

 ``` 
    // 1. 在屏幕上的阻塞被暂停，停止获取新的阻塞
    // 2. 当前的屏幕上的弹幕重新滚动，并获得一个开始的新弹幕推送
    [_manager pauseScroll];
 ```

* 设置弹幕的类型目前支持纯文本`KYBarrageDisplayTypeDefault` 和图文`KYBarrageDisplayTypeImage`，可以在 `KYBarrageScene`自定义其他的类型。

 ```
 m.barrageType = KYBarrageDisplayTypeImage;
 ```
 
# 其他

支持弹幕的点击事件 


如果弹幕为`KYBarrageDisplayTypeImage`型的弹幕时，请重写`ViewController`的 `touchesBegan` 方法

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

如DEMO里面的点击弹幕，弹幕停顿3s后，进行滚动，也可以扩展其他事件，如下图所示：



# 鼓励

它若不慎给您帮助，请不吝啬给它点一个**star**，是对它的最好支持，非常感谢！🙏

# LICENSE

**KYBarrageKit** 被许可在 **MIT** 协议下使用。查阅 **LICENSE** 文件来获得更多信息。




