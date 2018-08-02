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


### **要** 使用 `lowerCamelCase` 风格来命名其它的标识符。

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


### DO capitalize acronyms and abbreviations longer than two letters like words.

Capitalized acronyms can be hard to read, and
multiple adjacent acronyms can lead to ambiguous names.
For example, given a name that starts with `HTTPSFTP`, there's no way
to tell if it's referring to HTTPS FTP or HTTP SFTP.

To avoid this, acronyms and abbreviations are capitalized like regular words,
except for two-letter acronyms. (Two-letter *abbreviations* like
ID and Mr. are still capitalized like words.)

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


### DON’T use prefix letters

[Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) and
other schemes arose in the time of BCPL, when the compiler didn't do much to
help you understand your code. Because Dart can tell you the type, scope,
mutability, and other properties of your declarations, there's no reason to
encode those properties in identifier names.

{:.good-style}
{% prettify dart %}
defaultTimeout
{% endprettify %}

{:.bad-style}
{% prettify dart %}
kDefaultTimeout
{% endprettify %}


## Ordering

To keep the preamble of your file tidy, we have a prescribed order that
directives should appear in. Each "section" should be separated by a blank line.


### DO place "dart:" imports before other imports.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (dart-import-first)" replace="/\w+\/effective_dart\///g"?>
{% prettify dart %}
import 'dart:async';
import 'dart:html';

import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
{% endprettify %}


### DO place "package:" imports before relative imports.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (pkg-import-before-local)" replace="/\w+\/effective_dart\///g;/'foo/'util/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'util.dart';
{% endprettify %}


### PREFER placing "third-party" "package:" imports before other imports.

If you have a number of "package:" imports for your own package along with other
third-party packages, place yours in a separate section after the external ones.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/style_lib_good.dart (third-party)" replace="/\w+\/effective_dart\///g;/(package):foo(.dart)/$1:my_package\/util$2/g"?>
{% prettify dart %}
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';

import 'package:my_package/util.dart';
{% endprettify %}


### DO specify exports in a separate section after all imports.

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


### DO sort sections alphabetically.

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


## Formatting

Like many languages, Dart ignores whitespace. However, *humans* don't. Having a
consistent whitespace style helps ensure that human readers see code the same
way the compiler does.


### DO format your code using `dartfmt`.

Formatting is tedious work and is particularly time-consuming during
refactoring. Fortunately, you don't have to worry about it. We provide a
sophisticated automated code formatter called [dartfmt][] that does do it for
you. We have [some documentation][dartfmt docs] on the rules it applies, but the
official whitespace-handling rules for Dart are *whatever dartfmt produces*.

The remaining formatting guidelines are for the few things dartfmt cannot fix
for you.

[dartfmt]: https://github.com/dart-lang/dart_style
[dartfmt docs]: https://github.com/dart-lang/dart_style/wiki/Formatting-Rules

### CONSIDER changing your code to make it more formatter-friendly.

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


### AVOID lines longer than 80 characters.

Readability studies show that long lines of text are harder to read because your
eye has to travel farther when moving to the beginning of the next line. This is
why newspapers and magazines use multiple columns of text.

If you really find yourself wanting lines longer than 80 characters, our
experience is that your code is likely too verbose and could be a little more
compact. The main offender is usually `VeryLongCamelCaseClassNames`. Ask
yourself, "Does each word in that type name tell me something critical or
prevent a name collision?" If not, consider omitting it.

Note that dartfmt does 99% of this for you, but the last 1% is you. It does not
split long string literals to fit in 80 columns, so you have to do that
manually.

We make an exception for URIs and file paths. When those occur in comments or
strings (usually in imports and exports), they may remain on a single line even
if they go over the line limit. This makes it easier to search source files for
a given path.


### DO use curly braces for all flow control structures.

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
