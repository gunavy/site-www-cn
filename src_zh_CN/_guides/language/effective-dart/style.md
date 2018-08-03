---
title: "Effective Dart: 风格"
description: Formatting and naming rules for consistent, readable code.
nextpage:
  url: /guides/language/effective-dart/documentation
  title: 文档注释
prevpage:
  url: /guides/language/effective-dart
  title: 概述
---
<?code-excerpt plaster="none"?>

{% include effective-dart-banner.html %}

好的代码有一个非常重要的特点就是拥有好的风格。
一致的命名、一致的顺序、 以及一致的格式让代码看起来是一样的。
这非常有利于发挥我们视力系统强大的模式匹配能力。
如果我们整个 Dart 生态系统中都使用统一的风格，
那么这将让我们彼此之间更容易的互相学习和互相贡献。
它使我们所有人都可以更容易地学习并为彼此的代码做出贡献。

* TOC
{:toc}

## 标识符

在 Dart 中标识符有三种类型。

*   `UpperCamelCase` 每个单词的首字母都大写，包含第一个单词。

*   `lowerCamelCase` 每个单词的首字母都大写，*除了*第一个单词，
    第一个单词首字母小写，即使是缩略词。

*   `lowercase_with_underscores` 只是用小写字母单词，即使是缩略词，
    并且单词之间使用 `_` 连接。


### **要** 使用 `UpperCamelCase` 风格命名类型。

Classes（类名）、 enums（枚举类型）、 typedefs（类型定义）、
以及 type parameters（类型参数）应该把每个单词的首字母都大写（包含第一个单词）， 
不使用分隔符。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (type-names)"?>
{% prettify dart %}
class SliderMenu { ... }

class HttpRequest { ... }

typedef Predicate = bool Function<T>(T value);
{% endprettify %}

这里包括使用元数据注解的类。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (annotation-type-names)"?>
{% prettify dart %}
class Foo {
  const Foo([arg]);
}

@Foo(anArg)
class A { ... }

@Foo()
class B { ... }
{% endprettify %}

如果注解类的构造函数是无参函数，
则可以使用一个 `lowerCamelCase` 风格的常量来初始化这个注解。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (annotation-const)"?>
{% prettify dart %}
const foo = Foo();

@foo
class C { ... }
{% endprettify %}


### **要** 用 `lowercase_with_underscores` 风格命名库和源文件名。

一些文件系统不区分大小写，所以很多项目要求文件名必须是小写字母。
使用分隔符这种形式可以保证命名的可读性。使用下划线作为分隔符可确保名称仍然是有效的Dart标识符，
如果语言后续支持符号导入，这将会起到非常大的帮助。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart" replace="/foo\///g"?>
{% prettify dart %}
library peg_parser.source_scanner;

import 'file_system.dart';
import 'slider_menu.dart';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart" replace="/foo\///g;/file./file-/g;/slider_menu/SliderMenu/g;/source_scanner/SourceScanner/g;/peg_parser/pegparser/g"?>
{% prettify dart %}
library pegparser.SourceScanner;

import 'file-system.dart';
import 'SliderMenu.dart';
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **注意：** 如果你*选择命名库*，本准则给定了*如何*为库取名。
  如果需要，可以在文件中_省略_库指令。
</aside>


### **要** 使用 `lowercase_with_underscores` 风格命名导入的前缀。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (import-as)" replace="/(package):examples[^']*/$1:angular_components\/angular_components/g"?>
{% prettify dart %}
import 'dart:math' as math;
import 'package:angular_components/angular_components'
    as angular_components;
import 'package:js/js.dart' as js;
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (import-as)" replace="/(package):examples[^']*/$1:angular_components\/angular_components/g;/as angular_components/as angularComponents/g;/ math/ Math/g;/as js/as JS/g"?>
{% prettify dart %}
import 'dart:math' as Math;
import 'package:angular_components/angular_components'
    as angularComponents;
import 'package:js/js.dart' as JS;
{% endprettify %}


### **要** 使用 `lowerCamelCase` 风格来命名其他的标识符。

类成员、顶级定义、变量、参数以及命名参数等
*除了*第一个单词，每个单词首字母都应大写，并且不使用分隔符。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (misc-names)"?>
{% prettify dart %}
var item;

HttpRequest httpRequest;

void align(bool clearItems) {
  // ...
}
{% endprettify %}


### **推荐** 使用 `lowerCamelCase` 来命名常量。

在新的代码中，使用 `lowerCamelCase` 来命名常量，包括枚举的值。
已有的代码使用了 `SCREAMING_CAPS` 风格，
你可以继续全部使用该风格来保持代码的一致性。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (const-names)"?>
{% prettify dart %}
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');

class Dice {
  static final numberGenerator = Random();
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_bad.dart (const-names)"?>
{% prettify dart %}
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');

class Dice {
  static final NUMBER_GENERATOR = Random();
}
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **注意：** 我们一开始使用 Java `SCREAMING_CAPS` 风格来命名常量。
  我们之所以不再使用，是因为：

  *   `SCREAMING_CAPS` 很多情况下看起来比较糟糕，
      尤其类似于 CSS 颜色这类的枚举值。
  *   常量常常被修改为 final 类型的非常量变量，
      这种情况你还需要修改变量的名字为小写字母形式。
  *   在枚举类型中自动定义的 `values` 属性为常量并且是小写字母
      形式的。
</aside>

### **要** 把超过两个字母的首字母大写缩略词和缩写词当做一般单词来对待。

首字母大写缩略词比较难阅读，
特别是多个缩略词连载一起的时候会引起歧义。
例如，一个以 `HTTPSFTP` 开头的名字，
没有办法判断它是指 HTTPS FTP 还是 HTTP SFTP 。

为了避免上面的情况，缩略词和缩写词要像普通单词一样首字母大写，
两个字母的单词除外。
（像 ID 和 Mr. 这样的双字母*缩写词*仍然像一般单词一样首字母大写。）

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (acronyms and abbreviations)" replace="/,//g"?>
{% prettify dart %}
HttpConnectionInfo
uiHandler
IOStream
HttpRequest
Id
DB
{% endprettify %}

{:.bad-style}
{% prettify dart %}
HTTPConnection
UiHandler
IoStream
HTTPRequest
ID
Db
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **译者注：** 

  *   `acronyms` ：首字母缩略词，指取若干单词首字母组成一个新单词，如：HTTP = HyperText Transfer Protocol
  *   `abbreviations` : 缩写词，指取某一单词的部分字母（或其他缩短单词的方式）代表整个单词，如：ID = identification
</aside>


### **不要** 使用前缀字母

在编译器无法帮助你了解自己代码的时，
[匈牙利命名法](https://en.wikipedia.org/wiki/Hungarian_notation)
和其他方案出现在了 BCPL ，
但是因为 Dart 可以提示你声明的类型，范围，可变性和其他属性，
所以没有理由在标识符名称中对这些属性进行编码。

{:.good-style}
{% prettify dart %}
defaultTimeout
{% endprettify %}

{:.bad-style}
{% prettify dart %}
kDefaultTimeout
{% endprettify %}


## 顺序

为了使文件前面部分保持整洁，我们规定了关键字出现顺序的规则。
每个“部分”应该使用空行分割。

### **要** 把 "dart:" 导入语句放到其他导入语句之前。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
{% endprettify %}


### **要** 把 "package:" 导入语句放到项目相关导入语句之前。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
{% endprettify %}


### **推荐** 把"第三方" "package:" 导入语句放到其他语句之前。

如果你使用了多个 "package:" 导入语句来导入自己的包以及其他第三方包，
推荐将自己的包分开放到一个额外的部分。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (third-party)" replace="/\w+\/effective_dart\///g;/(package):foo(.dart)/$1:my_package\/util$2/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'package:my_package/util.dart';
{% endprettify %}


### **要** 把导出（export）语句作为一个单独的部分放到所有导入语句之后。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (export)"?>
{% prettify dart %}
import 'src/error.dart';
import 'src/foo_bar.dart';

export 'src/error.dart';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_bad.dart (export)"?>
{% prettify dart %}
import 'src/error.dart';
export 'src/error.dart';
import 'src/foo_bar.dart';
{% endprettify %}


### **要** 按照字母顺序来排序每个部分中的语句。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'foo.dart';
import 'foo/foo.dart';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_bad.dart (sorted)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'package:foo/foo.dart';
import 'package:bar/bar.dart';

import 'foo/foo.dart';
import 'foo.dart';
{% endprettify %}


## 格式化

和其他大部分语言一样， Dart 忽略空格。但是，*人*不会。
具有一致的空格风格有助于帮助我们能够用编译器相同的方式理解代码。

### **要** 使用 `dartfmt` 格式化你的代码。

Formatting is tedious work and is particularly time-consuming during
refactoring. Fortunately, you don't have to worry about it. We provide a
sophisticated automated code formatter called [dartfmt][] that does **要** it for
you. We have [some documentation][dartfmt docs] on the rules it applies, but the
official whitespace-handling rules for Dart are *whatever dartfmt produces*.

The remaining formatting guidelines are for the few things dartfmt cannot fix
for you.

[dartfmt]: https://github.com/dart-lang/dart_style
[dartfmt docs]: https://github.com/dart-lang/dart_style/wiki/Formatting-Rules

### **考虑** changing your code to make it more formatter-friendly.

The formatter does the best it can with whatever code you throw at it, but it
can't work miracles. If your code has particularly long identifiers, deeply
nested expressions, a mixture of different kinds of operators, etc. the
formatted output may still be hard to read.

When that happens, reorganize or simplify your code. Consider shortening a local
variable name or hoisting out an expression into a new local variable. In other
words, make the same kinds of modifications that you'd make if you were
formatting the code by hand and trying to make it more readable. Think of
dartfmt as a partnership where you work together, sometimes iteratively, to
produce beautiful code.


### **避免** lines longer than 80 characters.

Readability studies show that long lines of text are harder to read because your
eye has to travel farther when moving to the beginning of the next line. This is
why newspapers and magazines use multiple columns of text.

If you really find yourself wanting lines longer than 80 characters, our
experience is that your code is likely too verbose and could be a little more
compact. The main offender is usually `VeryLongCamelCaseClassNames`. Ask
yourself, "Does each word in that type name tell me something critical or
prevent a name collision?" If not, consider omitting it.

Note that dartfmt does 99% of this for you, but the last 1% is you. It does not
split long string literals to fit in 80 columns, so you have to **要** that
manually.

We make an exception for URIs and file paths. When those occur in comments or
strings (usually in imports and exports), they may remain on a single line even
if they go over the line limit. This makes it easier to search source files for
a given path.


### **要** use curly braces for all flow control structures.

Doing so avoids the [dangling else][] problem.

[dangling else]: http://en.wikipedia.org/wiki/Dangling_else

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (curly-braces)"?>
{% prettify dart %}
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
{% endprettify %}

There is one exception to this: an `if` statement with no `else` clause where
the entire `if` statement and the then body all fit in one line. In that case,
you may leave off the braces if you prefer:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (one-line-if)"?>
{% prettify dart %}
if (arg == null) return defaultValue;
{% endprettify %}

If the body wraps to the next line, though, use braces:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_good.dart (one-line-if-wrap)"?>
{% prettify dart %}
if (overflowChars != other.overflowChars) {
  return overflowChars < other.overflowChars;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/style_bad.dart (one-line-if-wrap)"?>
{% prettify dart %}
if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
{% endprettify %}
