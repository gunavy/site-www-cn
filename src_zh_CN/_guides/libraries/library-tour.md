---
title: Dart 库概览
description: Learn about the major features in Dart's libraries.
short-title: Dart 库概览
---
<?code-excerpt plaster="none"?>

本章将介绍以下库的主要功能及使用方式，
所有Dart平台中都包含这些库：

{% comment %}
[CHECK: is "all" guaranteed to stay true?]
{% endcomment %}

[dart:core](#dartcore---numbers-collections-strings-and-more)
: 内置类型，集合和其它核心功能。 
  该库会被自动导入到所有的 Dart 程序。

[dart:async](#dartasync---asynchronous-programming)
: 支持异步编程，包括Future和Stream等类。

{% comment %}
update-for-dart-2
Q: When will Future move to dart:core?
{% endcomment %}

[dart:math](#dartmath---math-and-random)
: 数学常数和函数，以及随机数生成器。

[dart:convert](#dartconvert---decoding-and-encoding-json-utf-8-and-more)
: 用于在不同数据表示之间进行转换的编码器和解码器，包括 JSON 和 UTF-8 。

本页只是一个概述；
只涵盖了几个 dart:* 库，
不包括第三方库。
特定平台库 dart:io 和 dart:html
的介绍，详见 [dart:io tour][] 和 [dart:html tour.][dart:html tour]

更多库信息可以在
[pub.dartlang.org][pub.dartlang.org] 和
[Dart web developer library guide.][webdev libraries] 查找。
所有 dart:* 库的 API 文档可以在
[Dart API reference][Dart API] 查找， 如果使用的是 Flutter
可以在 [Flutter API reference.][docs.flutter.io] 查找。

<aside class="alert alert-info" markdown="1">
**DartPad tip:**
可以通过将该页中的代码拷贝到 [DartPad.][DartPad]
中进行演示。
但请注意， [assert][] 语句在 DartPad 中是无操作的，
因为 DartPad 在生产模式下执行，而不是在检查模式下执行。 
一个简单的解决方法：
**将 `assert` 更改为 `print` 。** 
<br>
<br>

{% comment %}
update-for-dart-2
[TODO: fix styling instead of using the <br><br> hack.]

https://gist.github.com/2edc7174867be377021813ba4119ab8c
https://dartpad.dartlang.org/2edc7174867be377021813ba4119ab8c

{% prettify dart %}
void main() {
  assert(int.parse('42') == 42); // in checked mode: continues
  print(int.parse('42') == 42); // true

  assert(int.parse('43') == 42); // in checked mode: exception
  print(int.parse('43') == 42); // false
}
{% endprettify %}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=2edc7174867be377021813ba4119ab8c&horizontalRatio=99&verticalRatio=70"
    width="100%"
    height="255px"
    style="border: 1px solid #ccc;">
</iframe>

{% comment %}
https://github.com/dart-lang/dart-pad/issues/310
{% endcomment %}
</aside>


## dart:core - numbers, collections, strings, and more

dart:core 库 ([API reference][dart:core])
提供了一个少量但是重要的内置功能集合。
该库会被自动导入每个 Dart 程序。


### 控制台打印

顶级 `print()` 方法接受一个参数 任意对象）
并输出显示这个对象的字符串值(由 `toString()` 返回) 
到控制台。

<?code-excerpt "misc/test/library_tour/core_test.dart (print)"?>
{% prettify dart %}
print(anObject);
print('I drink $tea.');
{% endprettify %}

有关基本字符串和 `toString()` 的更多信息，参考
[Strings](/guides/language/language-tour#strings) in the language tour.


### Numbers

dart:core 库定义了 num ，int 以及 double 类，
这些类拥有一定的工具方法来处理数字。

使用 int 和 double 的 `parse()` 方法将字符串转换为整型或双浮点型对象：


<?code-excerpt "misc/test/library_tour/core_test.dart (int|double.parse)"?>
{% prettify dart %}
assert(int.parse('42') == 42);
assert(int.parse('0x42') == 66);
assert(double.parse('0.50') == 0.5);
{% endprettify %}

或者使用 num 的 parse() 方法，该方法可能会创建一个整型，否则为浮点型对象：


<?code-excerpt "misc/test/library_tour/core_test.dart (num-parse)"?>
{% prettify dart %}
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
{% endprettify %}

通过添加 `radix` 参数，指定整数的进制基数：

<?code-excerpt "misc/test/library_tour/core_test.dart (radix)"?>
{% prettify dart %}
assert(int.parse('42', radix: 16) == 66);
{% endprettify %}

使用 `toString()` 方法将整型或双精度浮点类型转换为字符串类型。
使用 [toStringAsFixed().][toStringAsFixed()] 指定小数点右边的位数，
使用 [toStringAsPrecision():][toStringAsPrecision()] 指定字符串中的有效数字的位数。

<?code-excerpt "misc/test/library_tour/core_test.dart (toString())"?>
{% prettify dart %}
// 整型转换为字符串类型。
assert(42.toString() == '42');

// 双浮点型转换为字符串类型。
assert(123.456.toString() == '123.456');

// 指定小数点后的位数。
assert(123.456.toStringAsFixed(2) == '123.46');

// 指定有效数字的位数。
assert(123.456.toStringAsPrecision(2) == '1.2e+2');
assert(double.parse('1.2e+2') == 120.0);
{% endprettify %}

更多详情， 参考
[int，][int] [double，][double] 和 [num][num] 的相关 API 文档。
也可参考 [dart:math section](#dartmath---math-and-random)。


### Strings and regular expressions

在 Dart 中一个字符串是一个固定不变的 UTF-16 编码单元序列。
语言概览中有更多关于 [strings](/guides/language/language-tour#strings) 的内容。
使用正则表达式 (RegExp 对象) 可以在字符串内搜索和替换部分字符串。

String 定义了例如 `split()`， `contains()`，
`startsWith()`， `endsWith()` 等方法。

#### 在字符串中搜索

可以在字符串内查找特定字符串的位置，
以及检查字符串是否以特定字符串作为开头或结尾。例如：

<?code-excerpt "misc/test/library_tour/core_test.dart (contains-etc)"?>
{% prettify dart %}
// 检查一个字符串是否包含另一个字符串。
assert('Never odd or even'.contains('odd'));

// 一个字符串是否以另一个字符串为开头?
assert('Never odd or even'.startsWith('Never'));

// 一个字符串是否以另一个字符串为结尾?
assert('Never odd or even'.endsWith('even'));

// 查找一个字符串在另一个字符串中的位置。
assert('Never odd or even'.indexOf('odd') == 6);
{% endprettify %}

#### 从字符串中提取数据

可以获取字符串中的单个字符，将其作为字符串或者整数。
确切地说，实际上获取的是单独的UTF-16编码单元;
诸如高音谱号符号 ('\\u{1D11E}') 之类的高编号字符分别为两个编码单元。

你也可以获取字符串中的子字符串或者将一个字符串分割为子字符串列表：

<?code-excerpt "misc/test/library_tour/core_test.dart (substring-etc)"?>
{% prettify dart %}
// 抓取一个子字符串。
assert('Never odd or even'.substring(6, 9) == 'odd');

// 使用字符串模式分割字符串。
var parts = 'structured web apps'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'structured');

// 通过下标获取 UTF-16 编码单元（编码单元作为字符串）。
assert('Never odd or even'[0] == 'N');

// 使用 split() 传入一个空字符串参数，
// 得到一个所有字符的 list 集合；
// 有助于字符迭代。
for (var char in 'hello'.split('')) {
  print(char);
}

// 获取一个字符串的所有 UTF-16 编码单元。
var codeUnitList =
    'Never odd or even'.codeUnits.toList();
assert(codeUnitList[0] == 78);
{% endprettify %}

#### 首字母大小写转换

可以轻松的对字符串的首字母大小写进行转换：

<?code-excerpt "misc/test/library_tour/core_test.dart (toUpperCase-toLowerCase)"?>
{% prettify dart %}
// 转换为首字母大写。
assert('structured web apps'.toUpperCase() ==
    'STRUCTURED WEB APPS');

// 转换为首字母小写。
assert('STRUCTURED WEB APPS'.toLowerCase() ==
    'structured web apps');
{% endprettify %}

<div class="alert alert-info" markdown="1">
**提示：**
这些方法不是在所有语言上都有效的。例如，
土耳其字母表的无点 *I* 转换是不正确的。
</div>


#### Trimming 和空字符串

使用 `trim()` 移除首尾空格。
使用 `isEmpty` 检查一个字符串是否为空（长度为0）。

<?code-excerpt "misc/test/library_tour/core_test.dart (trim-etc)"?>
{% prettify dart %}
// Trim a string.
assert('  hello  '.trim() == 'hello');

// 检查字符串是否为空。
assert(''.isEmpty);

// 空格字符串不是空字符串。
assert('  '.isNotEmpty);
{% endprettify %}

#### 替换部分字符串

字符串是不可变的对象，也就是说字符串可以创建但是不能被修改。
如果仔细阅读了 [String API docs,][String]
你会注意到，没有一个方法实际的改变了字符串的状态。
例如，方法 `replaceAll()` 返回一个新字符串，
并没有改变原始字符串：

<?code-excerpt "misc/test/library_tour/core_test.dart (replace)"?>
{% prettify dart %}
var greetingTemplate = 'Hello, NAME!';
var greeting =
    greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate 没有改变。
assert(greeting != greetingTemplate);
{% endprettify %}

#### 构建一个字符串

要以代码方式生成字符串，可以使用 StringBuffer 。
在调用 `toString()` 之前， StringBuffer 不会生成新字符串对象。
`writeAll()` 的第二个参数为可选参数，用来指定分隔符，
本例中使用空格作为分隔符。

<?code-excerpt "misc/test/library_tour/core_test.dart (StringBuffer)"?>
{% prettify dart %}
var sb = StringBuffer();
sb
  ..write('Use a StringBuffer for ')
  ..writeAll(['efficient', 'string', 'creation'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString ==
    'Use a StringBuffer for efficient string creation.');
{% endprettify %}

#### 正则表达式

RegExp类提供与JavaScript正则表达式相同的功能。
使用正则表达式可以对字符串进行高效搜索和模式匹配。

<?code-excerpt "misc/test/library_tour/core_test.dart (RegExp)"?>
{% prettify dart %}
// 下面正则表达式用于匹配一个或多个数字。
var numbers = RegExp(r'\d+');

var allCharacters = 'llamas live fifteen to twenty years';
var someDigits = 'llamas live 15 to 20 years';

// contains() 能够使用正则表达式。
assert(!allCharacters.contains(numbers));
assert(someDigits.contains(numbers));

// 替换所有匹配对象为另一个字符串。
var exedOut = someDigits.replaceAll(numbers, 'XX');
assert(exedOut == 'llamas live XX to XX years');
{% endprettify %}

你也可以直接使用RegExp类。
Match 类提供对正则表达式匹配对象的访问。

<?code-excerpt "misc/test/library_tour/core_test.dart (match)"?>
{% prettify dart %}
var numbers = RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// 检查正则表达式是否在字符串中匹配到对象。
assert(numbers.hasMatch(someDigits));

// 迭代所有匹配对象
for (var match in numbers.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
{% endprettify %}

#### 更多信息

有关完整的方法列表，
请参考 [String API docs][String]。
另请参考 [StringBuffer，][StringBuffer]
[Pattern，][Pattern] [RegExp，][RegExp] 和 [Match][Match]
的 API 文档。

### Collections

Dart 附带了核心集合 API ，其中包括 list ，set 和 map 类。

#### Lists

如语言概览中介绍，[lists](#lists) 可以通过字面量来创建和初始化。
另外，也可以使用 List 的构造函数。
List 类还定义了若干方法，用于向列表添加或删除项目。

<?code-excerpt "misc/test/library_tour/core_test.dart (List)"?>
{% prettify dart %}
// 使用 List 构造函数。
var vegetables = List();

// 或者仅使用一个 list 字面量。
var fruits = ['apples', 'oranges'];

// 添加一个元素到 list 对象。
fruits.add('kiwis');

// 添加多个元素到 list 对象。
fruits.addAll(['grapes', 'bananas']);

// 获取 list 长度。
assert(fruits.length == 5);

// 移除一个元素到 list 对象。
var appleIndex = fruits.indexOf('apples');
fruits.removeAt(appleIndex);
assert(fruits.length == 4);

// 移除多个元素到 list 对象。
fruits.clear();
assert(fruits.length == 0);
{% endprettify %}

使用 `indexOf()` 方法查找一个对象在 list 中的下标值。

<?code-excerpt "misc/test/library_tour/core_test.dart (indexOf)"?>
{% prettify dart %}
var fruits = ['apples', 'oranges'];

// 使用下标访问 list 中的元素
assert(fruits[0] == 'apples');

// 查找一个元素在 list 中的下标。
assert(fruits.indexOf('apples') == 0);
{% endprettify %}

使用 `sort()` 方法排序一个 list 。
你可以提供一个排序函数用于比较两个对象。
比较函数在 *小于* 时返回 \ <0，*相等* 时返回 0，*bigger* 时返回 \> 0 。
下面示例中使用 `compareTo()` 函数，
该函数在 [Comparable][] 中定义，
并被 String 类实现。

<?code-excerpt "misc/test/library_tour/core_test.dart (compareTo)"?>
{% prettify dart %}
var fruits = ['bananas', 'apples', 'oranges'];

// 排序一个 list 。
fruits.sort((a, b) => a.compareTo(b));
assert(fruits[0] == 'apples');
{% endprettify %}

list 是参数化类型，
因此可以指定 list 应该包含的元素类型：

<?code-excerpt "misc/test/library_tour/core_test.dart (ListOfString)"?>
{% prettify dart %}
// 这个 list 只能包含字符串类型。
var fruits = List<String>();

fruits.add('apples');
var fruit = fruits[0];
assert(fruit is String);

// 产生静态分析警告，num 不是字符串类型。
fruits.add(5); // BAD: Throws exception in checked mode.
{% endprettify %}

{% include checked-mode-2.0.html %}

{% comment %}
update-for-dart-2
{% endcomment %}

全部的方法介绍 ，请参考 [List API docs][List] 。

#### Sets

在 Dart 中，set 是一个无序的，元素唯一的集合。
因为一个 set 是无序的，所以无法通过下标（位置）获取 set 中的元素。

<?code-excerpt "misc/test/library_tour/core_test.dart (Set)"?>
{% prettify dart %}
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);
assert(ingredients.length == 3);

// 添加一个重复的元素是无效的。
ingredients.add('gold');
assert(ingredients.length == 3);

// 从 set 中移除一个元素。
ingredients.remove('gold');
assert(ingredients.length == 2);
{% endprettify %}

使用 `contains()` 和 `containsAll()` 来检查一个或多个元素是否在 set 中。

<?code-excerpt "misc/test/library_tour/core_test.dart (contains)"?>
{% prettify dart %}
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// 检查一个元素是否在该 set 中。
assert(ingredients.contains('titanium'));

// 检查多个元素是否在该 set 中。
assert(ingredients.containsAll(['titanium', 'xenon']));
{% endprettify %}

交集是另外两个 set 中的公共元素组成的 set 。

<?code-excerpt "misc/test/library_tour/core_test.dart (intersection)"?>
{% prettify dart %}
var ingredients = Set();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// 创建两个 set 的交集。
var nobleGases = Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
{% endprettify %}

全部的方法介绍 ，请参考 [Set API docs][Set] 。

#### Maps


map 是一个无序的 key-value （键值对）集合，就是大家熟知的 *dictionary* 或者 *hash*。
map 将 kay 与 value 关联，以便于检索。和 JavaScript 不同，Dart 对象不是 map 。

声明 map 可以使用简洁的字面量语法，也可以使用传统构造函数：

<?code-excerpt "misc/test/library_tour/core_test.dart (Map)"?>
{% prettify dart %}
// map 通常使用字符串作为 key。
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// map 可以通过构造函数构建。
var searchTerms = Map();

// map 是参数化类型；
// 可以指定一个 map 中 key 和 value 的类型。
var nobleGases = Map<int, String>();
{% endprettify %}

通过大括号语法可以为 map 添加，获取，设置元素。
使用 `remove()` 方法从 map 中移除键值对。

<?code-excerpt "misc/test/library_tour/core_test.dart (remove)"?>
{% prettify dart %}
var nobleGases = {54: 'xenon'};

// 使用 key 检索 value 。
assert(nobleGases[54] == 'xenon');

// 检查 map 是否包含 key 。
assert(nobleGases.containsKey(54));

// 移除一个 key 及其 value。
nobleGases.remove(54);
assert(!nobleGases.containsKey(54));
{% endprettify %}

可以从一个 map 中检索出所有的 key 或所有的 value：

<?code-excerpt "misc/test/library_tour/core_test.dart (keys)"?>
{% prettify dart %}
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// 获取的所有的 key 是一个无序集合
// (可迭代 list 对象)。
var keys = hawaiianBeaches.keys;

assert(keys.length == 3);
assert(Set.from(keys).contains('Oahu'));

// 获取的所有的 value 是一个无序集合
// (可迭代 list 对象).
var values = hawaiianBeaches.values;
assert(values.length == 3);
assert(values.any((v) => v.contains('Waikiki')));
{% endprettify %}

使用 `containsKey()` 方法检查一个 map 中是否包含某个key 。
因为 map 中的 value 可能会是 null ，
所有通过 key 获取 value，并通过判断 value 是否为 null 来判断 key 是否存在是不可靠的。

<?code-excerpt "misc/test/library_tour/core_test.dart (containsKey)"?>
{% prettify dart %}
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

assert(hawaiianBeaches.containsKey('Oahu'));
assert(!hawaiianBeaches.containsKey('Florida'));
{% endprettify %}

如果当且仅当该 key 不存在于 map 中，且要为这个 key 赋值，
可使用`putIfAbsent（）`方法。
该方法需要一个方法返回这个 value 。

<?code-excerpt "misc/test/library_tour/core_test.dart (putIfAbsent)"?>
{% prettify dart %}
var teamAssignments = {};
teamAssignments.putIfAbsent(
    'Catcher', () => pickToughestKid());
assert(teamAssignments['Catcher'] != null);
{% endprettify %}

全部的方法介绍 ，请参考 [Map API docs][Map] 。

#### 公共集合方法

List, Set, 和 Map 共享许多集合中的常用功能。
其中一些常见功能由 Iterable 类定义，
这些函数由 List 和 Set 实现。

<div class="alert alert-info" markdown="1">
**提示：**
虽然Map没有实现 Iterable，
但可以使用 Map `keys` 和 `values` 属性从中获取 Iterable 对象。
</div>

使用 `isEmpty` 和 `isNotEmpty` 方法可以检查 list， set 或 map 对象中是否包含元素：

<?code-excerpt "misc/test/library_tour/core_test.dart (isEmpty)"?>
{% prettify dart %}
var coffees = [];
var teas = ['green', 'black', 'chamomile', 'earl grey'];
assert(coffees.isEmpty);
assert(teas.isNotEmpty);
{% endprettify %}

使用 `forEach()` 可以让 list， set 或 map 对象中的每个元素都使用一个方法。

<?code-excerpt "misc/test/library_tour/core_test.dart (List.forEach)"?>
{% prettify dart %}
var teas = ['green', 'black', 'chamomile', 'earl grey'];

teas.forEach((tea) => print('I drink $tea'));
{% endprettify %}

当在 map 对象上调用 `forEach() 方法时，函数必须带两个参数（key 和 value）：

<?code-excerpt "misc/test/library_tour/core_test.dart (Map.forEach)"?>
{% prettify dart %}
hawaiianBeaches.forEach((k, v) {
  print('I want to visit $k and swim at $v');
  // 我想去瓦胡岛并且在
  // [Waikiki, Kailua, Waimanalo]游泳， 等等。
});
{% endprettify %}

Iterable 提供 `map()` 方法，这个方法将所有结果返回到一个对象中。

<?code-excerpt "misc/test/library_tour/core_test.dart (List.map)"?>
{% prettify dart %}
var teas = ['green', 'black', 'chamomile', 'earl grey'];

var loudTeas = teas.map((tea) => tea.toUpperCase());
loudTeas.forEach(print);
{% endprettify %}

<div class="alert alert-info" markdown="1">
**提示：**
`map()` 方法返回的对象是一个 *懒求值（lazily evaluated）*对象：
只有当访问对象里面的元素时，函数才会被调用。
</div>

使用 `map().toList()` 或 `map().toSet()` ，
可以强制在每个项目上立即调用函数。

<?code-excerpt "misc/test/library_tour/core_test.dart (toList)"?>
{% prettify dart %}
var loudTeas =
    teas.map((tea) => tea.toUpperCase()).toList();
{% endprettify %}

使用 Iterable 的 `where()` 方法可以获取所有匹配条件的元素。
使用 Iterable 的 `any()` 和 `every()` 方法可以检查部分或者所有元素是否匹配某个条件。
{% comment %}
PENDING: Change example as suggested by floitsch to have (maybe)
cities instead of isDecaffeinated.
{% endcomment %}


<?code-excerpt "misc/test/library_tour/core_test.dart (where-etc)"?>
{% prettify dart %}
var teas = ['green', 'black', 'chamomile', 'earl grey'];

// 洋甘菊不含咖啡因。
bool isDecaffeinated(String teaName) =>
    teaName == 'chamomile';

// 使用 where() 来查找元素，
// 这些元素在给定的函数中返回 true 。
var decaffeinatedTeas =
    teas.where((tea) => isDecaffeinated(tea));
// 或者 teas.where(isDecaffeinated)

// 使用 any() 来检查集合中是否至少有一个元素满足条件。
assert(teas.any(isDecaffeinated));

// 使用 every() 来检查集合中是否所有元素满足条件。
assert(!teas.every(isDecaffeinated));
{% endprettify %}

有关方法的完整列表，请参考 [Iterable API docs,][Iterable] 以及
[List,][List] [Set,][Set] and [Map.][Map]


### URIs

在使用 URI（可能你会称它为 *URLs*） 时，[Uri 类][Uri] 提供对字符串的编解码操作。
这些函数用来处理 URI 特有的字符，例如 `＆` 和 `=` 。
Uri 类还可以解析和处理 URI—host，port，scheme等组件。
{% comment %}
{PENDING: show
constructors: Uri.http, Uri.https, Uri.file, per floitsch's suggestion}
{% endcomment %}

#### 编码和解码完整合法的URI


使用 `encodeFull()` 和 `decodeFull()` 方法，
对 URI 中除了特殊字符（例如 `/`， `:`， `&`， `#`）以外的字符进行编解码，
这些方法非常适合编解码完整合法的 URI，并保留 URI 中的特殊字符。

<?code-excerpt "misc/test/library_tour/core_test.dart (encodeFull)"?>
{% prettify dart %}
var uri = 'http://example.org/api?foo=some message';

var encoded = Uri.encodeFull(uri);
assert(encoded ==
    'http://example.org/api?foo=some%20message');

var decoded = Uri.decodeFull(encoded);
assert(uri == decoded);
{% endprettify %}

注意上面代码只编码了 `some` 和 `message` 之间的空格。

#### 编码和解码 URI 组件

使用 `encodeComponent()` 和 `decodeComponent()` 方法，
对 URI 中具有特殊含义的所有字符串字符，特殊字符包括（但不限于）`/`， `&`， 和  `:`。

<?code-excerpt "misc/test/library_tour/core_test.dart (encodeComponent)"?>
{% prettify dart %}
var uri = 'http://example.org/api?foo=some message';

var encoded = Uri.encodeComponent(uri);
assert(encoded ==
    'http%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message');

var decoded = Uri.decodeComponent(encoded);
assert(uri == decoded);
{% endprettify %}

注意上面代码编码了所有的字符。例如 `/` 被编码为 `%2F`。

#### 解析 URI

可以使用 Uri 对象的字段（例如 `path`），
来获取一个 Uri 对象或者 URI 字符串的一部分。
使用 `parse()` 静态方法，可以使用字符串创建 Uri 对象。

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri.parse)"?>
{% prettify dart %}
var uri =
    Uri.parse('http://example.org:8080/foo/bar#frag');

assert(uri.scheme == 'http');
assert(uri.host == 'example.org');
assert(uri.path == '/foo/bar');
assert(uri.fragment == 'frag');
assert(uri.origin == 'http://example.org:8080');
{% endprettify %}

有关 URI 组件的更多内容，参考 [Uri API docs][Uri] 。

#### 构建 URI

可以使用 `Uri()` 构造函数，可以将各组件部分构建成 URI 。

<?code-excerpt "misc/test/library_tour/core_test.dart (Uri)"?>
{% prettify dart %}
var uri = Uri(
    scheme: 'http',
    host: 'example.org',
    path: '/foo/bar',
    fragment: 'frag');
assert(
    uri.toString() == 'http://example.org/foo/bar#frag');
{% endprettify %}


### Dates and times

A DateTime object is a point in time. The time zone is either UTC or the
local time zone.

You can create DateTime objects using several constructors:

<?code-excerpt "misc/test/library_tour/core_test.dart (DateTime)"?>
{% prettify dart %}
// Get the current date and time.
var now = DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000,
    isUtc: true);

// Parse an ISO 8601 date.
y2k = DateTime.parse('2000-01-01T00:00:00Z');
{% endprettify %}

The `millisecondsSinceEpoch` property of a date returns the number of
milliseconds since the “Unix epoch”—January 1, 1970, UTC:

<?code-excerpt "misc/test/library_tour/core_test.dart (millisecondsSinceEpoch)"?>
{% prettify dart %}
// 1/1/2000, UTC
var y2k = DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 1/1/1970, UTC
var unixEpoch = DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
{% endprettify %}

Use the Duration class to calculate the difference between two dates and
to shift a date forward or backward:

<?code-excerpt "misc/test/library_tour/core_test.dart (Duration)"?>
{% prettify dart %}
var y2k = DateTime.utc(2000);

// Add one year.
var y2001 = y2k.add(const Duration(days: 366));
assert(y2001.year == 2001);

// Subtract 30 days.
var december2000 =
    y2001.subtract(const Duration(days: 30));
assert(december2000.year == 2000);
assert(december2000.month == 12);

// Calculate the difference between two dates.
// Returns a Duration object.
var duration = y2001.difference(y2k);
assert(duration.inDays == 366); // y2k was a leap year.
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Warning:**
Using a Duration to shift a DateTime by days can be problematic, due
to clock shifts (to daylight saving time, for example). Use UTC dates
if you must shift days.
</div>

Refer to the API docs for [DateTime][] and [Duration][] for a full list of methods.


### Utility classes

The core library contains various utility classes, useful for sorting,
mapping values, and iterating.

#### Comparing objects

Implement the [Comparable][]
interface to indicate that an object can be compared to another object,
usually for sorting. The `compareTo()` method returns \< 0 for
*smaller*, 0 for the *same*, and \> 0 for *bigger*.

<?code-excerpt "misc/lib/library_tour/core/comparable.dart"?>
{% prettify dart %}
class Line implements Comparable<Line> {
  final int length;
  const Line(this.length);

  @override
  int compareTo(Line other) => length - other.length;
}

void main() {
  var short = const Line(1);
  var long = const Line(100);
  assert(short.compareTo(long) < 0);
}
{% endprettify %}

#### Implementing map keys

Each object in Dart automatically provides an integer hash code, and
thus can be used as a key in a map. However, you can override the
`hashCode` getter to generate a custom hash code. If you do, you might
also want to override the `==` operator. Objects that are equal (via
`==`) must have identical hash codes. A hash code doesn’t have to be
unique, but it should be well distributed.

{% comment %}
Note: There’s disagreement over whether to include identical() in the ==
implementation. It might improve speed, at least when you need to
compare many fields. They don’t do identical() automatically because, by
convention, NaN != NaN.
{% endcomment %}

<?code-excerpt "misc/lib/library_tour/core/hash_code.dart"?>
{% prettify dart %}
class Person {
  final String firstName, lastName;

  Person(this.firstName, this.lastName);

  // Override hashCode using strategy from Effective Java,
  // Chapter 11.
  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + firstName.hashCode;
    result = 37 * result + lastName.hashCode;
    return result;
  }

  // You should generally implement operator == if you
  // override hashCode.
  @override
  bool operator ==(dynamic other) {
    if (other is! Person) return false;
    Person person = other;
    return (person.firstName == firstName &&
        person.lastName == lastName);
  }
}

void main() {
  var p1 = Person('Bob', 'Smith');
  var p2 = Person('Bob', 'Smith');
  var p3 = 'not a person';
  assert(p1.hashCode == p2.hashCode);
  assert(p1 == p2);
  assert(p1 != p3);
}
{% endprettify %}

#### Iteration

The [Iterable][] and [Iterator][] classes
support for-in loops. Extend (if possible) or implement Iterable
whenever you create a class that can provide Iterators for use in for-in
loops. Implement Iterator to define the actual iteration ability.

<?code-excerpt "misc/lib/library_tour/core/iterator.dart"?>
{% prettify dart %}
class Process {
  // Represents a process...
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => ...
  @override
  bool moveNext() => ...
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (var process in Processes()) {
    // Do something with the process.
  }
}
{% endprettify %}


### Exceptions

The Dart core library defines many common exceptions and errors.
Exceptions are considered conditions that you can plan ahead for and
catch. Errors are conditions that you don’t expect or plan for.

A couple of the most common errors are:

[NoSuchMethodError][]

:   Thrown when a receiving object (which might be null) does not
    implement a method.

[ArgumentError][]

:   Can be thrown by a method that encounters an unexpected argument.

Throwing an application-specific exception is a common way to indicate
that an error has occurred. You can define a custom exception by
implementing the Exception interface:

<?code-excerpt "misc/lib/library_tour/core/exception.dart"?>
{% prettify dart %}
class FooException implements Exception {
  final String msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
{% endprettify %}

For more information, see [Exceptions](#exceptions) and the [Exception API docs.][Exception]


## dart:async - asynchronous programming

Asynchronous programming often uses callback functions, but Dart
provides alternatives: [Future][] and [Stream][] objects. A
Future is like a promise for a result to be provided sometime in the
future. A Stream is a way to get a sequence of values, such as events.
Future, Stream, and more are in the
dart:async library ([API reference][dart:async]).

<div class="alert alert-info" markdown="1">
**Note:**
You don't always need to use the Future or Stream APIs directly.
The Dart language supports asynchronous coding
using keywords such as `async` and `await`.
See [Asynchrony support](/guides/language/language-tour#asynchrony-support)
in the language tour for details.
</div>

The dart:async library works in both web apps and command-line apps. To
use it, import dart:async:

<?code-excerpt "misc/lib/library_tour/async/future.dart (import)"?>
{% prettify dart %}
import 'dart:async';
{% endprettify %}


### Future

Future objects appear throughout the Dart libraries, often as the object
returned by an asynchronous method. When a future *completes*, its value
is ready to use.


#### Using await

Before you directly use the Future API, consider using `await` instead.
Code that uses `await` expressions can be easier to understand
than code that uses the Future API.

Consider the following function.  It uses Future's `then()` method
to execute three asynchronous functions in a row,
waiting for each one to complete before executing the next one.

<?code-excerpt "misc/lib/library_tour/async/future.dart (runUsingFuture)"?>
{% prettify dart %}
runUsingFuture() {
  // ...
  findEntryPoint().then((entryPoint) {
    return runExecutable(entryPoint, args);
  }).then(flushThenExit);
}
{% endprettify %}

The equivalent code with await expressions
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/future.dart (runUsingAsyncAwait)"?>
{% prettify dart %}
runUsingAsyncAwait() async {
  // ...
  var entryPoint = await findEntryPoint();
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
}
{% endprettify %}

An async function can catch exceptions from Futures.
For example:

<?code-excerpt "misc/lib/library_tour/async/future.dart (catch)"?>
{% prettify dart %}
var entryPoint = await findEntryPoint();
try {
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
} catch (e) {
  // Handle the error...
}
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Important:**
Async functions return Futures.
If you don't want your function to return a future,
then use a different solution.
For example, you might call an async function from your function.
</div>

For more information on using `await` and related Dart language features,
see [Asynchrony support](/guides/language/language-tour#asynchrony-support).


#### Basic usage

{% comment %}
[PENDING: Delete much of the following content in favor of the tutorial coverage?]
{% endcomment %}

You can use `then()` to schedule code that runs when the future completes. For
example, `HttpRequest.getString()` returns a Future, since HTTP requests
can take a while. Using `then()` lets you run some code when that Future
has completed and the promised string value is available:

<?code-excerpt "misc/lib/library_tour/async/basic.dart (then)"?>
{% prettify dart %}
HttpRequest.getString(url).then((String result) {
  print(result);
});
{% endprettify %}

Use `catchError()` to handle any errors or exceptions that a Future
object might throw.

<?code-excerpt "misc/lib/library_tour/async/basic.dart (catchError)"?>
{% prettify dart %}
HttpRequest.getString(url).then((String result) {
  print(result);
}).catchError((e) {
  // Handle or ignore the error.
});
{% endprettify %}

The `then().catchError()` pattern is the asynchronous version of
`try`-`catch`.

<div class="alert alert-warning" markdown="1">
**Important:**
Be sure to invoke `catchError()` on the result of `then()`—not on the
result of the original Future. Otherwise, the `catchError()` can
handle errors only from the original Future's computation, but not
from the handler registered by `then()`.
</div>


#### Chaining multiple asynchronous methods

The `then()` method returns a Future, providing a useful way to run
multiple asynchronous functions in a certain order. If the callback
registered with `then()` returns a Future, `then()` returns an
equivalent Future. If the callback returns a value of any other type,
`then()` creates a new Future that completes with the value.

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain)"?>
{% prettify dart %}
Future result = costlyQuery(url);
result
    .then((value) => expensiveWork(value))
    .then((_) => lengthyComputation())
    .then((_) => print('Done!'))
    .catchError((exception) {
  /* Handle exception... */
});
{% endprettify %}

In the preceding example, the methods run in the following order:

1.  `costlyQuery()`
2.  `expensiveWork()`
3.  `lengthyComputation()`

Here is the same code written using await:

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain-as-await)"?>
{% prettify dart %}
try {
  final value = await costlyQuery(url);
  await expensiveWork(value);
  await lengthyComputation();
  print('Done!');
} catch (e) {
  /* Handle exception... */
}
{% endprettify %}


#### Waiting for multiple futures

Sometimes your algorithm needs to invoke many asynchronous functions and
wait for them all to complete before continuing. Use the [Future.wait()][]
static method to manage multiple Futures and wait for them to complete:

<?code-excerpt "misc/lib/library_tour/async/future.dart (wait)" replace="/elideBody;/\/* ... *\//g"?>
{% prettify dart %}
Future deleteLotsOfFiles() async =>  ...
Future copyLotsOfFiles() async =>  ...
Future checksumLotsOfOtherFiles() async =>  ...

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
{% endprettify %}


### Stream

Stream objects appear throughout Dart APIs, representing sequences of
data. For example, HTML events such as button clicks are delivered using
streams. You can also read a file as a stream.


#### Using an asynchronous for loop

Sometimes you can use an asynchronous for loop (`await for`)
instead of using the Stream API.

Consider the following function.
It uses Stream's `listen()` method
to subscribe to a list of files,
passing in a function literal that searches each file or directory.

<!-- OLD dart-tutorials-samples/cmdline/bin/dgrep.dart -->
<?code-excerpt "misc/lib/library_tour/async/stream.dart (listen)" replace="/listen/[!$&!]/g"?>
{% prettify dart %}
void main(List<String> arguments) {
  // ...
  FileSystemEntity.isDirectory(searchPath).then((isDir) {
    if (isDir) {
      final startingDir = Directory(searchPath);
      startingDir
          .list(
              recursive: argResults[recursive],
              followLinks: argResults[followLinks])
          .[!listen!]((entity) {
        if (entity is File) {
          searchFile(entity, searchTerms);
        }
      });
    } else {
      searchFile(File(searchPath), searchTerms);
    }
  });
}
{% endprettify %}

The equivalent code with await expressions,
including an asynchronous for loop (`await for`),
looks more like synchronous code:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (await-for)" replace="/await for/[!$&!]/g"?>
{% prettify dart %}
Future main(List<String> arguments) async {
  // ...
  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    [!await for!] (var entity in startingDir.list(
        recursive: argResults[recursive],
        followLinks: argResults[followLinks])) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(File(searchPath), searchTerms);
  }
}
{% endprettify %}

<div class="alert alert-warning" markdown="1">
**Important:**
Before using `await for`, make sure that it makes the code clearer
and that you really do want to wait for all of the stream's results.
For example, you usually should **not** use `await for` for DOM event listeners,
because the DOM sends endless streams of events.
If you use `await for` to register two DOM event listeners in a row,
then the second kind of event is never handled.
</div>

For more information on using `await` and related
Dart language features, see
[Asynchrony support](/guides/language/language-tour#asynchrony-support).


#### Listening for stream data

To get each value as it arrives, either use `await for` or
subscribe to the stream using the `listen()` method:

<?code-excerpt "misc/lib/library_tour/async/stream_web.dart (listen)" replace="/await for/[!$&!]/g"?>
{% prettify dart %}
// Find a button by ID and add an event handler.
querySelector('#submitInfo').onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
{% endprettify %}

In this example, the `onClick` property is a Stream object provided by
the "submitInfo" button.

If you care about only one event, you can get it using a property such
as `first`, `last`, or `single`. To test the event before handling it,
use a method such as `firstWhere()`, `lastWhere()`, or `singleWhere()`.
{% comment %}
{PENDING: example}
{% endcomment %}

If you care about a subset of events, you can use methods such as
`skip()`, `skipWhile()`, `take()`, `takeWhile()`, and `where()`.
{% comment %}
{PENDING: example}
{% endcomment %}


#### Transforming stream data

Often, you need to change the format of a stream's data before you can
use it. Use the `transform()` method to produce a stream with a
different type of data:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (transform)"?>
{% prettify dart %}
var lines = inputStream
    .transform(utf8.decoder)
    .transform(LineSplitter());
{% endprettify %}

This example uses two transformers. First it uses utf8.decoder to
transform the stream of integers into a stream of strings. Then it uses
a LineSplitter to transform the stream of strings into a stream of
separate lines. These transformers are from the dart:convert library (see the
[dart:convert section](#dartconvert---decoding-and-encoding-json-utf-8-and-more)).
{% comment %}
  PENDING: add onDone and onError. (See "Streaming file contents".)
{% endcomment %}


#### Handling errors and completion

How you specify error and completion handling code
depends on whether you use an asynchronous for loop (`await for`)
or the Stream API.

If you use an asynchronous for loop,
then use try-catch to handle errors.
Code that executes after the stream is closed
goes after the asynchronous for loop.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (readFileAwaitFor)" replace="/try|catch/[!$&!]/g"?>
{% prettify dart %}
Future readFileAwaitFor() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(utf8.decoder)
      .transform(LineSplitter());
  [!try!] {
    await for (var line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } [!catch!] (e) {
    print(e);
  }
}
{% endprettify %}

If you use the Stream API,
then handle errors by registering an `onError` listener.
Run code after the stream is closed by registering
an `onDone` listener.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (onDone)" replace="/onDone|onError/[!$&!]/g"?>
{% prettify dart %}
var config = File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream
    .transform(utf8.decoder)
    .transform(LineSplitter())
    .listen((String line) {
  print('Got ${line.length} characters from stream');
}, [!onDone!]: () {
  print('file is now closed');
}, [!onError!]: (e) {
  print(e);
});
{% endprettify %}


### More information

For some examples of using Future and Stream in command-line apps,
see the [dart:io tour.][dart:io tour]
Also see these articles and tutorials:

-   [Asynchronous Programming: Futures](/tutorials/language/futures)
-   [Futures and Error Handling](/guides/libraries/futures-error-handling)
-   [The Event Loop and Dart]({{site.webdev}}/articles/performance/event-loop)
-   [Asynchronous Programming: Streams](/tutorials/language/streams)
-   [Creating Streams in Dart](/articles/libraries/creating-streams)


## dart:math - math and random

The dart:math library ([API reference][dart:math])
provides common functionality such as sine and cosine,
maximum and minimum, and constants such as *pi* and *e*. Most of the
functionality in the Math library is implemented as top-level functions.

To use this library in your app, import dart:math. The following
examples use the prefix `math` to make clear which top-level functions
and constants are from the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (import)"?>
{% prettify dart %}
import 'dart:math';
{% endprettify %}


### Trigonometry

The Math library provides basic trigonometric functions:

<?code-excerpt "misc/test/library_tour/math_test.dart (trig)"?>
{% prettify dart %}
// Cosine
assert(cos(pi) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (pi / 180);
// radians is now 0.52359.
var sinOf30degrees = sin(radians);
// sin 30° = 0.5
assert((sinOf30degrees - 0.5).abs() < 0.01);
{% endprettify %}

<div class="alert alert-info" markdown="1">
**Note:**
These functions use radians, not degrees!
</div>


### Maximum and minimum

The Math library provides `max()` and `min()` methods:

<?code-excerpt "misc/test/library_tour/math_test.dart (min-max)"?>
{% prettify dart %}
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
{% endprettify %}


### Math constants

Find your favorite constants—*pi*, *e*, and more—in the Math library:

<?code-excerpt "misc/test/library_tour/math_test.dart (constants)"?>
{% prettify dart %}
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
{% endprettify %}


### Random numbers

Generate random numbers with the [Random][] class. You can
optionally provide a seed to the Random constructor.

<?code-excerpt "misc/test/library_tour/math_test.dart (Random)"?>
{% prettify dart %}
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
{% endprettify %}

You can even generate random booleans:

<?code-excerpt "misc/test/library_tour/math_test.dart (Random-bool)"?>
{% prettify dart %}
var random = Random();
random.nextBool(); // true or false
{% endprettify %}


### More information

Refer to the [Math API docs][dart:math] for a full list of methods.
Also see the API docs for [num,][num] [int,][int] and [double.][double]


## dart:convert - decoding and encoding JSON, UTF-8, and more

The dart:convert library ([API reference][dart:convert])
has converters for JSON and UTF-8, as well as support for creating
additional converters. [JSON][] is a simple text format for representing
structured objects and collections. [UTF-8][] is a common variable-width
encoding that can represent every character in the Unicode character
set.

The dart:convert library works in both web apps and command-line apps.
To use it, import dart:convert.

<?code-excerpt "misc/test/library_tour/convert_test.dart (import)"?>
{% prettify dart %}
import 'dart:convert';
{% endprettify %}


### Decoding and encoding JSON

Decode a JSON-encoded string into a Dart object with `jsonDecode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-decode)"?>
{% prettify dart %}
// NOTE: Be sure to use double quotes ("),
// not single quotes ('), inside the JSON string.
// This string is JSON, not Dart.
var jsonString = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

var scores = jsonDecode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
{% endprettify %}

Encode a supported Dart object into a JSON-formatted string with
`jsonEncode()`:

<?code-excerpt "misc/test/library_tour/convert_test.dart (json-encode)"?>
{% prettify dart %}
var scores = [
  {'score': 40},
  {'score': 80},
  {'score': 100, 'overtime': true, 'special_guest': null}
];

var jsonText = jsonEncode(scores);
assert(jsonText ==
    '[{"score":40},{"score":80},'
    '{"score":100,"overtime":true,'
    '"special_guest":null}]');
{% endprettify %}

Only objects of type int, double, String, bool, null, List, or Map (with
string keys) are directly encodable into JSON. List and Map objects are
encoded recursively.

You have two options for encoding objects that aren't directly
encodable. The first is to invoke `encode()` with a second argument: a
function that returns an object that is directly encodable. Your second
option is to omit the second argument, in which case the encoder calls
the object's `toJson()` method.


### Decoding and encoding UTF-8 characters

Use `utf8.decode()` to decode UTF8-encoded bytes to a Dart string:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-decode)" replace="/ \/\/line-br.*//g"?>
{% prettify dart %}
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1
];

var funnyWord = utf8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
{% endprettify %}

To convert a stream of UTF-8 characters into a Dart string, specify
`utf8.decoder` to the Stream `transform()` method:

<?code-excerpt "misc/test/library_tour/io_test.dart (utf8-decoder)" replace="/utf8.decoder/[!$&!]/g"?>
{% prettify dart %}
var lines = inputStream
    .transform([!utf8.decoder!])
    .transform(LineSplitter());
try {
  await for (var line in lines) {
    print('Got ${line.length} characters from stream');
  }
  print('file is now closed');
} catch (e) {
  print(e);
}
{% endprettify %}

Use `utf8.encode()` to encode a Dart string as a list of UTF8-encoded
bytes:

<?code-excerpt "misc/test/library_tour/convert_test.dart (utf8-encode)" replace="/ \/\/line-br.*//g"?>
{% prettify dart %}
List<int> encoded = utf8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
{% endprettify %}


### Other functionality

The dart:convert library also has converters for ASCII and ISO-8859-1
(Latin1). For details, see the [API docs for the dart:convert library.][dart:convert]


## Summary

This page introduced you to the most commonly used functionality in
Dart’s built-in libraries. It didn’t cover all the built-in
libraries, however. Others that you might want to look into include
[dart:collection][] and [dart:typed\_data,][dart:typed\_data]
as well as platform-specific libaries like the
[Dart web development libraries][webdev libraries]
and the [Flutter libraries.][docs.flutter.io]

You can get yet more libraries by using the [pub tool](/tools/pub). The
[collection,](https://pub.dartlang.org/packages/collection)
[crypto,](https://pub.dartlang.org/packages/crypto)
[http,](https://pub.dartlang.org/packages/http)
[intl,](https://pub.dartlang.org/packages/intl) and
[test](https://pub.dartlang.org/packages/test) libraries are just a
sampling of what you can install using pub.

To learn more about the Dart language, see the
[language tour][].

[language tour]: /guides/language/language-tour
[docs.flutter.io]: https://docs.flutter.io/
[dartdocs.org]: https://www.dartdocs.org/
[pub.dartlang.org]: https://pub.dartlang.org
[DartPad]: https://dartpad.dartlang.org
[Assert]: /guides/language/language-tour#assert
[ArgumentError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[Comparable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Comparable-class.html
[dart:core]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/dart-core-library.html
[dart:async]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[dart:collection]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-collection/dart-collection-library.html
[dart:convert]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-convert/dart-convert-library.html
[dart:html tour]: {{site.webdev}}/guides/html-library-tour
[dart:io tour]: /dart-vm/io-library-tour
[dart:math]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/dart-math-library.html
[dart:typed\_data]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-typed_data/dart-typed_data-library.html
[Dart API]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}
[DateTime]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/DateTime-class.html
[double]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/double-class.html
[Duration]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Duration-class.html
[Exception]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[Future.wait()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/wait.html
[IndexedDB]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-indexed_db/dart-indexed_db-library.html
[int]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int-class.html
[Iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[Iterator]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterator-class.html
[JSON]: https://www.json.org/
[List]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[Map]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
[Match]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Match-class.html
[NoSuchMethodError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/NoSuchMethodError-class.html
[num]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num-class.html
[Object]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html
[Pattern]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Pattern-class.html
[Random]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-math/Random-class.html
[RegExp]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/RegExp-class.html
[Set]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Set-class.html
[Stream]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[String]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String-class.html
[StringBuffer]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StringBuffer-class.html
[Symbol]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Symbol-class.html
[toStringAsFixed()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/toStringAsPrecision.html
[UTF-8]: https://en.wikipedia.org/wiki/UTF-8
[web audio]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-web_audio/dart-web_audio-library.html
[Uri]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Uri-class.html
[webdev libraries]: {{site.webdev}}/guides/web-programming
