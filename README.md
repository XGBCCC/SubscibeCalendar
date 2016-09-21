# SubscibeCalendar

SubscibeCalendar 是之前业余时间做的，一个关于日历订阅的app，但是没坚持做下去，现开源出来，仅供参考

### 项目层级
1. 主要使用MVC结构
2. 由于加入了TodayWidget，将Model，API，部分业务逻辑都放入了framework中，以供不同的target进行调用
3. API通过三方库Moya进行调用
4. API的数据返回，是通过传递给service一个parser的闭包，然后进行解析【这么做主要是为了之后的扩展，例如：如果其他人需要用你这个kit，你可以很简单的将这个kit给他，而不需要牵连给出其他解析器，model等类库】
5. **其实，后来项目中，并没有再用这种做法了，然而APIService，直接返回原始的Data，然后使用范型来进行解析，更加的简单方便，使用大概如下：XXParser\<User\>.parserData(data)**

