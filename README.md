# Koinu

`Koinu` 是一个自定义 `UINavigationController` 框架，通过对 `UIViewController` 进行包装，使每个  `UIViewController` 独立的维护各自的 `UINavigationBar` 的样式，从而避免了在 `UIViewController` 的 `viewWillAppear(_:)` 与 `viewDidDisappear(_:)` 方法中修改 `UINavigationBar` 样式所导致的问题。

## 示例代码

## 限制条件
- iOS 10.0+
- Swift 5.0+    

## 安装

### **CocoaPods**
``` ruby
pod 'Koinu', '~> 1.0.0'
```

### **Swift Package Manager**
```
https://github.com/spirit-jsb/Koinu.git
```

## 作者
spirit-jsb, sibo_jian_29903549@163.com

## 许可文件
`Koinu` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。