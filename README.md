# RouteAction

**RouteAction是一个路由工具，用来解除业务模块之间的横向依赖，实现组件化。**

RouteAction包括两个部分，Core和Extension。Core提供了最基本的路由功能，注册路由动作，发起请求。Extension提供了对控制器跳转的路由支持。

## 重要类介绍
> 基础部分

### RARouter
路由管理者，负责路由注册和销毁，发送请求。

### RARequest
请求对象，封装请求的URL和参数。可以配置响应回调，完成回调。

### RAIntercepter
拦截器，对发起的请求进行拦截，可以对该请求执行放行，拒绝，转发三种操作。

### RAResponse
响应对象，封装响应的数据。

### RARequestHandler
请求处理对象，负责对请求发送响应或者完成。


> 扩展部分

### RATransitionRequest
控制器转场请求，继承于RARequest，封装转场请求需要的数据。

### RATransitionResponse
控制器转场响应，继承于RAResponse，封装转场响应的数据。

## 使用介绍
> 基础部分

### 注册动作
指定URL模板和动作，当收到匹配的请求时会触发该动作。

**URL模板有两种形式:**

1.指定具体路径，比如/a/b/c。当收到路径为/a/b/c的请求时会触发注册的动作。

2.指定通配符路径，比如/a/*。当收到路径为/a/b/c/d的请求时也会触发注册的动作。

**当具体路径和通配符路径同时满足时，优先选择具体路径。**

**注意:通配符路径只能作为最后一个路径出现在末尾，比如/a/*。以下格式: /a/\*.jsp，/a/\*/b，/a/b/c\*d，/a/b/c/d\*都不是合法的通配符路径，会被视为具体路径。**

```objc
[[RARouter shared] registerActionWithURLPattern:@"/a/b/c" block:^(RARequest *request, RARequestHandler *handler) {
    
}];
```

### 发起请求
指定URL和参数，发起请求。

```objc
RARequest *request = [RARequest requestWithURL:@"/demo1/action" params:@{@"id":@"123"}];
[[RARouter shared] sendRequest:request];
```

请求参数除了可以在RARequest对象中指明。也可以像HTTP的GET请求一样拼接在URL中。

```objc
RARequest *request = [RARequest requestWithURL:@"/a/b/c?account=zhangsan&&password=123456" params:@{@"ext":@"hello"}];
```

如果需要接收响应事件或者完成事件，可以进行配置:

```objc
[request onResponse:^(RAResponse *response) {
    //处理响应事件
}];
    
[request onComplete:^(NSError *error) {
    //处理完成事件
}];
```

### 处理请求
当注册的URL模板和请求匹配时，会触发注册的动作。

获取请求参数

```objc
[[RARouter shared] registerActionWithURLPattern:@"/demo1/action" block:^(RARequest *request, RARequestHandler *handler) {
    NSDictionary *params = request.params;
}];
```

回调操作

触发动作后，可以发送多次响应事件和一次完成事件给请求。请求在接收完成事件之后不再接收任何事件。

```objc
[[RARouter shared] registerActionWithURLPattern:@"/a/b/c" block:^(RARequest *request, RARequestHandler *handler) {
    RAResponse *response = [RAResponse responseWithCode:0 data:@"hello"];
    handler.response(response); //发送响应
    handler.complete(nil);      //发送完成
}];
```

### 注册拦截器
指定URL模板和拦截器对象，注册拦截器。

**URL模板也提供具体路径和通配符路径两种，规则同上。**

```objc
RAIntercepter *intercepter = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
    judger.doContinue();
}];
    
//注册拦截器
[[RARouter shared] registerIntercepter:intercepter withURLPattern:@"/a/*"];
```
### 拦截器处理
拦截器拦截到请求后，可以执行放行，拒绝，转发三种操作。

```objc
RAIntercepter *intercepter = [RAIntercepter intercepterWithAwake:^(RARequest *request, id<RAIntercepterJudger> judger) {
    judger.doContinue();        //放行该请求
    judger.doReject(error);     //拒绝该请求
    judger.doSwitch(@"/x/y/z"); //转发该请求到/x/y/z
}];
```

### 处理路径参数
在注册路由动作时，也可以指明包含在URL路径中的参数。在收到请求时，路径中的参数会填充到请求对象的params字典中。

```objc
[[RARouter shared] registerActionWithURLPattern:@"/a/:account/:password" block:^(RARequest *request, RARequestHandler *handler) {
    
}];
```
### 注销动作
指定需要注销的节点的URL模板。该节点被注销后，和该节点绑定的动作和拦截器都会被清空。

**URL模板同样支持具体路径和通配符路径两种规则。**

```objc
//注销/a/b/c节点
[[RARouter shared] deregisterWithURLPattern:@"/a/b/c"];
//注销/a路径下的所有节点
[[RARouter shared] deregisterWithURLPattern:@"/a/*"];
```

### 404处理
当找不到请求对应的动作时，会在日志中提示404警告。如果需要对404请求处理，可以进行配置：
```objc
[[RARouter shared] configGlobalMissmatch:^(RARequest * _Nonnull request) {
    //handle 404 request
}];
```
> 扩展部分

### 注册控制器
注册了控制器后，就可以通过转场请求来展现对应的控制器界面。

**URL模板同样支持具体路径和通配符路径两种规则。**

```objc
[[RARouter shared] registerControllerWithClass:[RADemo1ViewController class] URLPattern:@"/demo1"];
```

### 发起转场请求
根据URL创建请求:

```objc
RATransitionRequest *request = [RATransitionRequest requestWithURL:@"/demo1"];
request.transitionDisplay = [RAPresentTransition new];
```

根据Class创建请求:

```objc
RATransitionRequest *request = [RATransitionRequest requestWithControllerClass:[RADemo1ViewController class]];
request.transitionDisplay = [RAPresentTransition new];
```

转场完成的回调:

```objc
[request onTransitionComplete:^(RATransitionRequest *request) {
    //转场完成
}];
```

发起转场:

```objc
//ra_startRequest:是UIViewController的路由扩展方法，控制器之间的路由跳转需要调用此方法
[self ra_startRequest:request];
```

### 默认转场动画
每一个转场请求都需要指定转场方式，工具内部分别提供了push，present两种方式的默认实现。

```objc
//push转场
id<RATransitionDisplay>pushTransition = [RAPushTransition new];
//present转场
id<RATransitionDisplay>presentTransition = [RAPresentTransition new];
```
### 自定义转场动画
除了默认转场，还可以自定义转场，只要实现RATransitionDisplay协议。内部提供的转场对象也是实现了RATransitionDisplay协议。

```objc
@protocol RATransitionDisplay <NSObject>

- (void)displayFromViewController:(UIViewController *)from
                 toViewController:(UIViewController *)to
                         animated:(BOOL)animated
                       completion:(void(^)(void))completion;

- (void)finishDisplayFromViewController:(UIViewController *)from
                       toViewController:(UIViewController *)to
                               animated:(BOOL)animated
                             completion:(void(^)(void))completion;
@end
```
### 控制器初始化
通过路由方式跳转的控制器，都会走initWithRARequest:handler:初始化方法。

```objc
- (instancetype)initWithRARequest:(RATransitionRequest *)request handler:(RARequestHandler *)handler;
```

### 转场返回
如果控制器是通过路由跳转的，可以在需要返回上级界面时调用扩展方法ra_finishDisplay。使用该方法的好处是控制器不用再关心是自己push出来的还是present出来的。

```objc
//方式1
[self ra_finishDisplay];
//方式2
[self ra_finishDisplayAnimated:YES];
//方式3
[self ra_finishDisplayAnimated:YES completion:^{
    //转场完成
}];
```

## 补充
### 路由注册格式限制
URL格式形如scheme://[username:password@]host:[port][/paths][?params][#fragment]，注册的URL模板只能从/paths开始。

### 路径占位符匹配规则
1.不同层级优先匹配更深层级。

eg:已经注册的路由:/a/b，/a/:account/c，请求的URL:/a/b/c。会优先匹配/a/:account/c。

2.相同层级优先匹配非占位符路径。

eg:已经注册的路由:/a/:account，/a/b，请求的URL:/a/b。会优先匹配/a/b。

### 路径通配符匹配规则
1.不同层级优先匹配更深层级。

eg:已经注册的路由:/a/\*，/a/b/\*，请求的URL:/a/b/c。会优先匹配/a/b/*。

2.相同层级优先匹配具体路径。

eg:已经注册的路由:/a/b/\*，/a/b/c，请求的URL:/a/b/c。会优先匹配/a/b/c。
