---
title: "Effective Dart: 使用"
description: Guidelines for using language features to write maintainable code.
nextpage:
  url: /guides/language/effective-dart/design
  title: 设计
prevpage:
  url: /guides/language/effective-dart/documentation
  title: 文档注释
---
<?code-excerpt replace="/([A-Z]\w*)\d\b/$1/g"?>

{% comment %}
This is the most "blue-collar" guide in Effective Dart. You'll apply the
guidelines here every day in the bodies of your Dart code. *Users* of your
library may not be able to tell that you've internalized the ideas here, but
*maintainers* of it sure will.
{% endcomment %}

该指南在 Effective Dart 中是最为基础的部分。
每天在你写的 Dart 代码中都会应用到这些准则。
库的*使用者*可能不需要知道你在其中的一些想法，
但是*维护者*肯定是需要的。

* TOC
{:toc}

{% comment %}
## Libraries

These guidelines help you compose your program out of multiple files in a
consistent, maintainable way. To keep these guidelines brief, they use "import"
to cover `import` and `export` directives. The guidelines apply equally to both.
{% endcomment %}

## 库

这些准则可以帮助你在多个文件编写程序的情况下保证一致性和可维护性。
为了让准则简洁，这里使用“import”来同事代表 `import` 和 `export` 。
准则同时适用于这两者。


{% comment %}
### DO use strings in `part of` directives.

Many Dart developers avoid using `part` entirely. They find it easier to reason
about their code when each library is a single file. If you do choose to use
`part` to split part of a library out into another file, Dart requires the other
file to in turn indicate which library it's a part of. For legacy reasons, Dart
allows this `part of` directive to use the *name* of the library it's a part of.
That makes it harder for tools to physically find the main library file, and can
make it ambiguous which library the part is actually part of.

The preferred, modern syntax is to use a URI string that points directly to the
library file, just like you use in other directives. If you have some library,
`my_library.dart`, that contains:

<?code-excerpt "misc/lib/effective_dart/my_library.dart"?>
{% prettify dart %}
library my_library;

part "some/other/file.dart";
{% endprettify %}

Then the part file should look like:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/some/other/file.dart"?>
{% prettify dart %}
part of "../../my_library.dart";
{% endprettify %}

And not:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/some/other/file_2.dart"?>
{% prettify dart %}
part of my_library;
{% endprettify %}
{% endcomment %}

### **要** 在 `part of` 中使用字符串。

很多 Dart 开发者会避免直接使用 `part` 。他们发现当库仅有一个文件的时候很容易读懂代码。
如果你确实要使用 `part` 将库的一部分拆分为另一个文件，则 Dart 要求另一个文件指示它所属库的路径。 
由于遗留原因， Dart 允许 `part of` 指令使用它所属的库的*名称*。
这使得工具很难直接查找到这个文件对应主库文件，使得库和文件之间的关系模糊不清。

推荐的现代语法是使用 URI 字符串直接指向库文件。
首选的现代语法是使用直接指向库文件的URI字符串，URI 的使用和其他指令中一样。
如果你有一些库，`my_library.dart`，其中包含：

<?code-excerpt "misc/lib/effective_dart/my_library.dart"?>
{% prettify dart %}
library my_library;

part "some/other/file.dart";
{% endprettify %}

从库中拆分的文件应该如下所示：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/some/other/file.dart"?>
{% prettify dart %}
part of "../../my_library.dart";
{% endprettify %}

而不是：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/some/other/file_2.dart"?>
{% prettify dart %}
part of my_library;
{% endprettify %}


{% comment %}
### DON'T import libraries that are inside the `src` directory of another package.

The `src` directory under `lib` [is specified][package guide] to contain
libraries private to the package's own implementation. The way package
maintainers version their package takes this convention into account. They are
free to make sweeping changes to code under `src` without it being a breaking
change to the package.

[package guide]: https://www.dartlang.org/tools/pub/package-layout

That means that if you import some other package's private library, a minor,
theoretically non-breaking point release of that package could break your code.
{% endcomment %}

### **不要** 导入 package 中 `src` 目录下的库。

`lib` 下的 `src` 目录[被指定][package guide]为 package 自己实现的私有库。
基于包维护者对版本的考虑，package 使用了这种约定。
在不破坏 package 的情况下，维护者可以自由地对 `src` 目录下的代码进行修改。

[package guide]: https://www.dartlang.org/tools/pub/package-layout

这意味着，你如果导入了其中的私有库，
按理论来讲，一个不破坏 package 的次版本就会影响到你的代码。

{% comment %}
### PREFER relative paths when importing libraries within your own package's `lib` directory.

When referencing a library inside your package's `lib` directory from another
library in that same package, either a relative URI or an explicit `package:`
will work.

For example, say your directory structure looks like:

```text
my_package
└─ lib
   ├─ src
   │  └─ utils.dart
   └─ api.dart
```

If `api.dart` wants to import `utils.dart`, it should do so using:

{:.good-style}
{% prettify dart %}
import 'src/utils.dart';
{% endprettify %}

And not:

{:.bad-style}
{% prettify dart %}
import 'package:my_package/src/utils.dart';
{% endprettify %}

There is no profound reason to prefer the former—it's just shorter, and we want
to be consistent.

The "within your own package's `lib` directory" part is important. Libraries
inside `lib` can import other libraries inside `lib` (or in subdirectories of
it). Libraries outside of `lib` can use relative imports to reach other
libraries outside of `lib`. For example, you may have a test utility library
under `test` that other libraries in `test` import.

But you can't "cross the streams". A library outside of `lib` should never use a
relative import to reach a library under `lib`, or vice versa. Doing so will
break Dart's ability to correctly tell if two library URIs refer to the same
library. Follow these two rules:

* An import path should never contain `/lib/`.
* A library under `lib` should never use `../` to escape the `lib` directory.
{% endcomment %}

### **建议** 使用相对路径在导入你自己 package 中的 `lib` 目录。

在同一个 package 下其中一个库引用另一个 `lib` 目录下的库时，
应该使用相对的 URI 或者直接使用 `package:`。

比如，下面是你的 package 目录结构：

```text
my_package
└─ lib
   ├─ src
   │  └─ utils.dart
   └─ api.dart
```

如果 `api.dart` 想导入 `utils.dart` ，应该这样使用：

{:.good-style}
{% prettify dart %}
import 'src/utils.dart';
{% endprettify %}

而不是:

{:.bad-style}
{% prettify dart %}
import 'package:my_package/src/utils.dart';
{% endprettify %}

喜欢一种方式没有什么深奥的原因——这里仅仅是因为更精简，或者是能够保持一致。

“让 package 的 `lib` 目录”独立分离非常重要。
`lib` 中的库可以导入 `lib`（或其子目录）中的其他库。
`lib` 之外的库可以使用相对导入的方式来访问`lib`之外的其他库。
例如，`test` 下可能有一个测试实用程序库被其它在 `test` 下的库导入。

但不能跨越导入。一个在 `lib` 外部的库应该永远不会引用一个在 `lib` 内部的库，反之亦然。
这样做，会破坏 Dart 正确判断两个库的 URL 是否引用了同一个库的能力。
遵循以下两条规则：

* 导入路径不应包含 `/lib/` 。
* `lib` 下的库永远不应该使用 `../` 来跨越 `lib` 目录。

{% comment %}
## Strings

Here are some best practices to keep in mind when composing strings in Dart.
{% endcomment %}

## 字符串

下面是一些需要记住的，关于在 Dart 中使用字符串的最佳实践。

{% comment %}
### DO use adjacent strings to concatenate string literals.

If you have two string literals&mdash;not values, but the actual quoted literal
form&mdash;you do not need to use `+` to concatenate them. Just like in C and
C++, simply placing them next to each other does it. This is a good way to make
a single long string that doesn't fit on one line.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (adjacent-strings-literals)"?>
{% prettify dart %}
raiseAlarm(
    'ERROR: Parts of the spaceship are on fire. Other '
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (adjacent-strings-literals)"?>
{% prettify dart %}
raiseAlarm('ERROR: Parts of the spaceship are on fire. Other ' +
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}
{% endcomment %}

### **要** 使用临近字符字的方式连接字面量字符串。

如果你有两个字面量字符串（不是变量，是放在引号中的字符串），你不需要使用 `+` 来连接它们。
应该想 C 和 C++ 一样，只需要将它们挨着在一起就可以了。
这种方式非常适合不能放到一行的长字符串的创建。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (adjacent-strings-literals)"?>
{% prettify dart %}
raiseAlarm(
    'ERROR: Parts of the spaceship are on fire. Other '
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (adjacent-strings-literals)"?>
{% prettify dart %}
raiseAlarm('ERROR: Parts of the spaceship are on fire. Other ' +
    'parts are overrun by martians. Unclear which are which.');
{% endprettify %}

{% comment %}
### PREFER using interpolation to compose strings and values.

If you're coming from other languages, you're used to using long chains of `+`
to build a string out of literals and other values. That does work in Dart, but
it's almost always cleaner and shorter to use interpolation:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (string-interpolation)"?>
{% prettify dart %}
'Hello, $name! You are ${year - birth} years old.';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (string-interpolation)"?>
{% prettify dart %}
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
{% endprettify %}
{% endcomment %}

### **推荐** 使用插值的形式来组合字符串和值。

如果你之前使用过其他语言，你一定习惯使用大量 `+` 将字面量字符串以及字符串变量链接构建字符串。
这种方式在 Dart 中同样有效，但是通常情况下使用插值会更清晰简短。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (string-interpolation)"?>
{% prettify dart %}
'Hello, $name! You are ${year - birth} years old.';
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (string-interpolation)"?>
{% prettify dart %}
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
{% endprettify %}

{% comment %}
### AVOID using curly braces in interpolation when not needed.

If you're interpolating a simple identifier not immediately followed by more
alphanumeric text, the `{}` should be omitted.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (string-interpolation-avoid-curly)"?>
{% prettify dart %}
'Hi, $name!'
"Wear your wildest $decade's outfit."
'Wear your wildest ${decade}s outfit.'
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (string-interpolation-avoid-curly)"?>
{% prettify dart %}
'Hi, ${name}!'
"Wear your wildest ${decade}'s outfit."
{% endprettify %}
{% endcomment %}

### **避免** 在字符串插值中使用不必要的大括号。

如果要插入是一个简单的标识符，并且后面没有紧跟随在其他字母文本，则应省略 `{}` 。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (string-interpolation-avoid-curly)"?>
{% prettify dart %}
'Hi, $name!'
"Wear your wildest $decade's outfit."
'Wear your wildest ${decade}s outfit.'
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (string-interpolation-avoid-curly)"?>
{% prettify dart %}
'Hi, ${name}!'
"Wear your wildest ${decade}'s outfit."
{% endprettify %}

{% comment %}
## Collections

Out of the box, Dart supports four collection types: lists, maps, queues, and sets.
The following best practices apply to collections.
{% endcomment %}

## 集合

Dart 集合中原生支持了四种类型：list， map， queue， 和 set。
下面是应用于集合的最佳实践。

{% comment %}
### DO use collection literals when possible.

There are two ways to make an empty growable list: `[]` and `List()`.
Likewise, there are three ways to make an empty linked hash map: `{}`,
`Map()`, and `LinkedHashMap()`.

If you want to create a non-growable list, or some other custom collection type
then, by all means, use a constructor. Otherwise, use the nice literal syntax.
The core library exposes those constructors to ease adoption, but idiomatic Dart
code does not use them.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (collection-literals)"?>
{% prettify dart %}
var points = [];
var addresses = {};
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (collection-literals)"?>
{% prettify dart %}
var points = List();
var addresses = Map();
{% endprettify %}

You can even provide a type argument for them if that matters.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (generic-collection-literals)"?>
{% prettify dart %}
var points = <Point>[];
var addresses = <String, Address>{};
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (generic-collection-literals)"?>
{% prettify dart %}
var points = List<Point>();
var addresses = Map<String, Address>();
{% endprettify %}

Note that this doesn't apply to the *named* constructors for those classes.
`List.from()`, `Map.fromIterable()`, and friends all have their uses. Likewise,
if you're passing a size to `List()` to create a non-growable one, then it
makes sense to use that.
{% endcomment %}

### **要** 尽可能的使用集合字面量。

有两种方式来构造一个空的可变 list ： `[]` 和 `List()` 。
同样，有三总方式来构造一个空的链表哈希 map：`{}`，
`Map()`， 和 `LinkedHashMap()` 。

如果想创建一个固定不变的 list 或者其他自定义集合类型，这种情况下你需要使用构造函数。
否则，使用字面量语法更加优雅。
核心库中暴露这些构造函数易于扩展，但是通常在 Dart 代码中并不使用构造函数。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (collection-literals)"?>
{% prettify dart %}
var points = [];
var addresses = {};
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (collection-literals)"?>
{% prettify dart %}
var points = List();
var addresses = Map();
{% endprettify %}

如果需要的话，你甚至可以为它们提供一个类型参数。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (generic-collection-literals)"?>
{% prettify dart %}
var points = <Point>[];
var addresses = <String, Address>{};
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (generic-collection-literals)"?>
{% prettify dart %}
var points = List<Point>();
var addresses = Map<String, Address>();
{% endprettify %}

注意，对于集合类的 *命名* 构造函数则不适用上面的规则。
`List.from()`、 `Map.fromIterable()` 都有其使用场景。 
如果需要一个固定长度的结合，使用 ``List()`` 来创建一个固定长度的 list 也是合理的。

{% comment %}
### DON'T use `.length` to see if a collection is empty.

The [Iterable][] contract does not require that a collection know its length or
be able to provide it in constant time. Calling `.length` just to see if the
collection contains *anything* can be painfully slow.

[iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html

Instead, there are faster and more readable getters: `.isEmpty` and
`.isNotEmpty`. Use the one that doesn't require you to negate the result.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-use-length)"?>
{% prettify dart %}
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-use-length)"?>
{% prettify dart %}
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
{% endprettify %}
{% endcomment %}

### **不要** 使用 `.length` 来判断一个集合是否为空。

[Iterable][] 合约并不要求集合知道其长度，也没要求在遍历的时候其长度不能改变。
通过调用 `.length`  来判断集合是否包含内容是非常低效的。

[iterable]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html

相反，Dart 提供了更加高效率和易用的 getter 函数：`.isEmpty` 和`.isNotEmpty`。
使用这些函数并不需要对结果再次取非。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-use-length)"?>
{% prettify dart %}
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-use-length)"?>
{% prettify dart %}
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
{% endprettify %}

{% comment %}
### CONSIDER using higher-order methods to transform a sequence.

If you have a collection and want to produce a new modified collection from it,
it's often shorter and more declarative to use `.map()`, `.where()`, and the
other handy methods on `Iterable`.

Using those instead of an imperative `for` loop makes it clear that your intent
is to produce a new sequence and not to produce side effects.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-higher-order-func)"?>
{% prettify dart %}
var aquaticNames = animals
    .where((animal) => animal.isAquatic)
    .map((animal) => animal.name);
{% endprettify %}

At the same time, this can be taken too far. If you are chaining or nesting
many higher-order methods, it may be clearer to write a chunk of imperative
code.
{% endcomment %}

### **考虑** 使用高阶（higher-order）函数来转换集合数据。

如果你有一个集合并且想要修改里面的内容转换为另外一个集合，
使用 `.map()`、 `.where()` 以及 `Iterable` 提供的其他函数会让代码更加简洁。

使用这些函数替代 `for` 循环会让代码更加可以表述你的意图，
生成一个新的集合系列并不具有副作用。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-higher-order-func)"?>
{% prettify dart %}
var aquaticNames = animals
    .where((animal) => animal.isAquatic)
    .map((animal) => animal.name);
{% endprettify %}

与此同时，这可以非常长，
如果你串联或者嵌套调用很多高阶函数，
则使用一些命令式代码可能会更加清晰。

{% comment %}
### AVOID using `Iterable.forEach()` with a function literal.

`forEach()` functions are widely used in JavaScript because the built in
`for-in` loop doesn't do what you usually want. In Dart, if you want to iterate
over a sequence, the idiomatic way to do that is using a loop.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-forEach)"?>
{% prettify dart %}
for (var person in people) {
  ...
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (avoid-forEach)"?>
{% prettify dart %}
people.forEach((person) {
  ...
});
{% endprettify %}

The exception is if all you want to do is invoke some already existing function
with each element as the argument. In that case, `forEach()` is handy.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (forEach-over-func)"?>
{% prettify dart %}
people.forEach(print);
{% endprettify %}
{% endcomment %}

### **避免** 在 `Iterable.forEach()` 中使用字面量函数。

`forEach()` 函数在 JavaScript 中被广泛使用，
这因为内置的 `for-in` 循环通常不能达到你想要的效果。
在Dart中，如果要对序列进行迭代，惯用的方式是使用循环。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-forEach)"?>
{% prettify dart %}
for (var person in people) {
  ...
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (avoid-forEach)"?>
{% prettify dart %}
people.forEach((person) {
  ...
});
{% endprettify %}

例外情况是，如果要执行的操作是调用一些已存在的并且将每个元素作为参数的函数，
在这种情况下，`forEach()` 是很方便的。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (forEach-over-func)"?>
{% prettify dart %}
people.forEach(print);
{% endprettify %}

{% comment %}
### DON'T use `List.from()` unless you intend to change the type of the result.

Given an Iterable, there are two obvious ways to produce a new List that
contains the same elements:

<?code-excerpt "misc/test/effective_dart_test.dart (list-from-1)"?>
{% prettify dart %}
var copy1 = iterable.toList();
var copy2 = List.from(iterable);
{% endprettify %}

The obvious difference is that the first one is shorter. The *important*
difference is that the first one preserves the type argument of the original
object:

{:.good-style}
<?code-excerpt "misc/test/effective_dart_test.dart (list-from-good)"?>
{% prettify dart %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<int>":
print(iterable.toList().runtimeType);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/test/effective_dart_test.dart (list-from-bad)"?>
{% prettify dart %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<dynamic>":
print(List.from(iterable).runtimeType);
{% endprettify %}

If you *want* to change the type, then calling `List.from()` is useful:

{:.good-style}
<?code-excerpt "misc/test/effective_dart_test.dart (list-from-3)"?>
{% prettify dart %}
var numbers = [1, 2.3, 4]; // List<num>.
numbers.removeAt(1); // Now it only contains integers.
var ints = List<int>.from(numbers);
{% endprettify %}

But if your goal is just to copy the iterable and preserve its original type, or
you don't care about the type, then use `toList()`.
{% endcomment %}

### **不要** 使用 `List.from()` 除非想修改结果的类型。

给定一个可迭代的对象，有两种常见方式来生成一个包含相同元素的 list：

<?code-excerpt "misc/test/effective_dart_test.dart (list-from-1)"?>
{% prettify dart %}
var copy1 = iterable.toList();
var copy2 = List.from(iterable);
{% endprettify %}

明显的区别是前一个更短。
更*重要*的区别在于第一个保留了原始对象的类型参数：

{:.good-style}
<?code-excerpt "misc/test/effective_dart_test.dart (list-from-good)"?>
{% prettify dart %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<int>":
print(iterable.toList().runtimeType);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/test/effective_dart_test.dart (list-from-bad)"?>
{% prettify dart %}
// Creates a List<int>:
var iterable = [1, 2, 3];

// Prints "List<dynamic>":
print(List.from(iterable).runtimeType);
{% endprettify %}

如果你*想要*改变类型，那么可以调用 `List.from()` ：

{:.good-style}
<?code-excerpt "misc/test/effective_dart_test.dart (list-from-3)"?>
{% prettify dart %}
var numbers = [1, 2.3, 4]; // List<num>.
numbers.removeAt(1); // Now it only contains integers.
var ints = List<int>.from(numbers);
{% endprettify %}

但是如果你的目的只是复制可迭代对象并且保留元素原始类型，
或者并不在乎类型，那么请使用 `toList()` 。


{% comment %}
### DO use `whereType()` to filter a collection by type.

{% comment %}
update-for-dart-2
{% endcomment %}
<aside class="alert alert-warning" markdown="1">
  **Before using `whereType()`, make sure it's implemented.**
  We expect `whereType()` to be added late in Dart&nbsp;2 development.
  For details, see
  [SDK issue #32463.](https://github.com/dart-lang/sdk/issues/32463#issuecomment-402975456)
</aside>

Let's say you have a list containing a mixture of objects, and you want to get
just the integers out of it. You could use `where()` like this:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (where-type)"?>
{% prettify dart %}
var objects = [1, "a", 2, "b", 3];
var ints = objects.where((e) => e is int);
{% endprettify %}

This is verbose, but, worse, it returns an iterable whose type probably isn't
what you want. In the example here, it returns an `Iterable<Object>` even though
you likely want an `Iterable<int>` since that's the type you're filtering it to.

Sometimes you see code that "corrects" the above error by adding `cast()`:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (where-type-2)"?>
{% prettify dart %}
var objects = [1, "a", 2, "b", 3];
var ints = objects.where((e) => e is int).cast<int>();
{% endprettify %}

That's verbose and causes two wrappers to be created, with two layers of
indirection and redundant runtime checking. Fortunately, the core library has
the [`whereType()`][where-type] method for this exact use case:

[where-type]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable/whereType.html

{:.good-style}
<?code-excerpt "misc/test/effective_dart_test.dart (whereType)"?>
{% prettify dart %}
var objects = [1, "a", 2, "b", 3];
var ints = objects.whereType<int>();
{% endprettify %}

Using `whereType()` is concise, produces an [Iterable][] of the desired type,
and has no unnecessary levels of wrapping.
{% endcomment %}

### **要** 使用 `whereType()` 按类型过滤集合。

{% comment %}
update-for-dart-2
{% endcomment %}
<aside class="alert alert-warning" markdown="1">
  **在使用 `whereType()` 前，确认它是否已经被实现。**
  我们期望 `whereType()` 会在后续的 Dart&nbsp;2 中添加。
  更多详情，参考
  [SDK issue #32463.](https://github.com/dart-lang/sdk/issues/32463#issuecomment-402975456)
</aside>

假设你有一个 list 里面包含了多种类型的对象，
但是你指向从它里面获取整型类型的数据。
那么你可以像下面这样使用 `where()` ：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (where-type)"?>
{% prettify dart %}
var objects = [1, "a", 2, "b", 3];
var ints = objects.where((e) => e is int);
{% endprettify %}

这个很罗嗦，但是更糟糕的是，它返回的可迭代对象类型可能并不是你想要的。
在上面的例子中，虽然你想得到一个 `Iterable<int>`，然而它返回了一个 `Iterable<Object>`，
这是因为，这是你过滤后得到的类型。

有时候你会看到通过添加 `cast()` 来“修正”上面的错误：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (where-type-2)"?>
{% prettify dart %}
var objects = [1, "a", 2, "b", 3];
var ints = objects.where((e) => e is int).cast<int>();
{% endprettify %}

代码冗长，并导致创建了两个包装器，获取元素对象要间接通过两层，并进行两次多余的运行时检查。
幸运的是，对于这个用例，核心库提供了 `whereType()`][where-type] 方法：

[where-type]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable/whereType.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (where-type)"?>
{% prettify dart %}
var objects = [1, "a", 2, "b", 3];
var ints = objects.whereType<int>();
{% endprettify %}

使用 `whereType()` 简洁，
生成所需的 [Iterable][]（可迭代）类型，
并且没有不必要的层级包装。

{% comment %}
### DON'T use `cast()` when a nearby operation will do.

Often when you're dealing with an iterable or stream, you perform several
transformations on it. At the end, you want to produce an object with a certain
type argument. Instead of tacking on a call to `cast()`, see if one of the
existing transformations can change the type.

If you're already calling `toList()`, replace that with a call to
[`List<T>.from()`][list-from] where `T` is the type of resulting list you want.

[list-from]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/List.from.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-list)"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var ints = List<int>.from(stuff);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-list)"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var ints = stuff.toList().cast<int>();
{% endprettify %}

If you are calling `map()`, give it an explicit type argument so that it
produces an iterable of the desired type. Type inference often picks the correct
type for you based on the function you pass to `map()`, but sometimes you need
to be explicit.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-map)" replace="/\(n as int\)/n/g"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map<double>((n) => 1 / n);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-map)" replace="/\(n as int\)/n/g"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map((n) => 1 / n).cast<double>();
{% endprettify %}
{% endcomment %}


### **不要** 使用 `cast()`，如果有更合适的方法。

通常，当处理可迭代对象或 stream 时，
你可以对其执行多次转换。
最后，生成所希望的具有特定类型参数的对象。
尝试查看是否有已有的转换方法来改变类型，而不是去掉用 `cast()` 。
而不是调用cast（），看看是否有一个现有的转换可以改变类型。

如果你已经使用了 `toList()` ，那么请使用 [`List<T>.from()`][list-from] 替换，
这里的 `T` 是你想要的返回值的类型。

[list-from]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/List.from.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-list)"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var ints = List<int>.from(stuff);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-list)"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var ints = stuff.toList().cast<int>();
{% endprettify %}

如果你正在调用 `map()` ，给它一个显式的类型参数，
这样它就能产生一个所需类型的可迭代对象。
类型推断通常根据传递给 `map()` 的函数选择出正确的类型，
但有的时候需要明确指明。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-map)" replace="/\(n as int\)/n/g"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map<double>((n) => 1 / n);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-map)" replace="/\(n as int\)/n/g"?>
{% prettify dart %}
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map((n) => 1 / n).cast<double>();
{% endprettify %}

{% comment %}
### AVOID using `cast()`.

This is the softer generalization of the previous rule. Sometimes there is no
nearby operation you can use to fix the type of some object. Even then, when
possible avoid using `cast()` to "change" a collection's type.

Prefer any of these options instead:

*   **Create it with the right type.** Change the code where the collection is
    first created so that it has the right type.

*   **Cast the elements on access.** If you immediately iterate over the
    collection, cast each element inside the iteration.

*   **Eagerly cast using `List.from()`.** If you'll eventually access most of
    the elements in the collection, and you don't need the object to be backed
    by the original live object, convert it using `List.from()`.

    The `cast()` method returns a lazy collection that checks the element type
    on *every operation*. If you perform only a few operations on only a few
    elements, that laziness can be good. But in many cases, the overhead of lazy
    validation and of wrapping outweighs the benefits.

Here is an example of **creating it with the right type:**

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-at-create)"?>
{% prettify dart %}
List<int> singletonList(int value) {
  var list = <int>[];
  list.add(value);
  return list;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-at-create)"?>
{% prettify dart %}
List<int> singletonList(int value) {
  var list = []; // List<dynamic>.
  list.add(value);
  return list.cast<int>();
}
{% endprettify %}

Here is **casting each element on access:**

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-iterate)" replace="/\(n as int\)/[!$&!]/g"?>
{% prettify dart %}
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (var n in objects) {
    if ([!(n as int)!].isEven) print(n);
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-iterate)"?>
{% prettify dart %}
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (var n in objects.cast<int>()) {
    if (n.isEven) print(n);
  }
}
{% endprettify %}

Here is **casting eagerly using `List.from()`:**

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-from)"?>
{% prettify dart %}
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = List<int>.from(objects);
  ints.sort();
  return ints[ints.length ~/ 2];
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-from)"?>
{% prettify dart %}
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = objects.cast<int>();
  ints.sort();
  return ints[ints.length ~/ 2];
}
{% endprettify %}

These alternatives don't always work, of course, and sometimes `cast()` is the
right answer. But consider that method a little risky and undesirable&mdash;it
can be slow and may fail at runtime if you aren't careful.
{% endcomment %}

### **避免** 使用 `cast()` 。

这是对先前规则的一个宽松的定义。
有些时候，并没有合适的方式来修改对象类型，即便如此，
也应该尽可能的避免使用 `cast()` 来“改变”集合中元素的类型。

推荐使用下面的方式来替代：

*   **用恰当的类型创建集合。** 修改集合被首次创建时的代码，
    为集合提供有一个恰当的类型。

*   **在访问元素时进行 cast 操作。** 如果要立即对集合进行迭代，
    在迭代内部 cast 每个元素。

*   **逼不得已进行 cast，请使用 `List.from()` 。** 如果最终你会使用到集合中的大部分元素，
    并且不需要对象还原到原始的对象类型，使用 `List.from()` 来转换它。

    `cast()` 方法返回一个惰性集合（lazy collection），*每个操作*都会对元素进行检查。
    如果只对少数元素执行少量操作，那么这种惰性方式就非常合适。
    但在许多情况下，惰性验证和包裹（wrapping）所产生的开销已经超过了它们所带来的好处。

下面是 **用恰当的类型创建集合** 的示例：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-at-create)"?>
{% prettify dart %}
List<int> singletonList(int value) {
  var list = <int>[];
  list.add(value);
  return list;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-at-create)"?>
{% prettify dart %}
List<int> singletonList(int value) {
  var list = []; // List<dynamic>.
  list.add(value);
  return list.cast<int>();
}
{% endprettify %}

下面是 **在访问元素时进行 cast 操作** 的示例：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-iterate)" replace="/\(n as int\)/[!$&!]/g"?>
{% prettify dart %}
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (var n in objects) {
    if ([!(n as int)!].isEven) print(n);
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-iterate)"?>
{% prettify dart %}
void printEvens(List<Object> objects) {
  // We happen to know the list only contains ints.
  for (var n in objects.cast<int>()) {
    if (n.isEven) print(n);
  }
}
{% endprettify %}

下面是 **使用 `List.from()` 进行 cast 操作** 的示例：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cast-from)"?>
{% prettify dart %}
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = List<int>.from(objects);
  ints.sort();
  return ints[ints.length ~/ 2];
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cast-from)"?>
{% prettify dart %}
int median(List<Object> objects) {
  // We happen to know the list only contains ints.
  var ints = objects.cast<int>();
  ints.sort();
  return ints[ints.length ~/ 2];
}
{% endprettify %}

当然，这些替代方案并不总能解决问题，显然，这时候就应该选择 `cast()` 方式了。
但是考虑到这种方式的风险和缺点——如果使用不当，可能会导致执行缓慢和运行失败。

{% comment %}
## Functions

In Dart, even functions are objects. Here are some best practices
involving functions.
{% endcomment %}

## 函数

在 Dart 中，就连函数也是对象。以下是一些涉及函数的最佳实践。


{% comment %}
### DO use a function declaration to bind a function to a name.

Modern languages have realized how useful local nested functions and closures
are. It's common to have a function defined inside another one. In many cases,
this function is used as a callback immediately and doesn't need a name. A
function expression is great for that.

But, if you do need to give it a name, use a function declaration statement
instead of binding a lambda to a variable.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (func-decl)"?>
{% prettify dart %}
void main() {
  localFunction() {
    ...
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (func-decl)"?>
{% prettify dart %}
void main() {
  var localFunction = () {
    ...
  };
}
{% endprettify %}
{% endcomment %}


### **要** 使用函数声明的方式为函数绑定名称。

现代语言已经意识到本地嵌套函数和闭包的益处。
在一个函数中定义另一个函数非常常见。
在许多情况下，这些函数被立即执行并返回结果，而且不需要名字。
这种情况下非常适合使用函数表达式来实现。

但是，如果你确实需要给方法一个名字，请使用方法定义而不是把
lambda 赋值给一个变量。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (func-decl)"?>
{% prettify dart %}
void main() {
  localFunction() {
    ...
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (func-decl)"?>
{% prettify dart %}
void main() {
  var localFunction = () {
    ...
  };
}
{% endprettify %}

{% comment %}
### DON'T create a lambda when a tear-off will do.

If you refer to a method on an object but omit the parentheses, Dart gives you
a "tear-off"&mdash;a closure that takes the same parameters as the method and
invokes it when you call it.

If you have a function that invokes a method with the same arguments as are
passed to it, you don't need to manually wrap the call in a lambda.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-tear-off)"?>
{% prettify dart %}
names.forEach(print);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (use-tear-off)"?>
{% prettify dart %}
names.forEach((name) {
  print(name);
});
{% endprettify %}
{% endcomment %}

### **不要** 使用 lambda 表达式来替代 tear-off。

如果你在一个对象上调用函数并省略了括号， 
Dart 称之为"tear-off"&mdash;一个和函数使用同样参数的闭包，
当你调用闭包的时候执行其中的函数。

如果你有一个方法，这个方法调用了参数相同的另一个方法。
那么，你不需要人为将这个方法包装到一个 lambda 表达式中。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-tear-off)"?>
{% prettify dart %}
names.forEach(print);
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (use-tear-off)"?>
{% prettify dart %}
names.forEach((name) {
  print(name);
});
{% endprettify %}

{% comment %}
## Parameters
{% endcomment %}

## 参数

{% comment %}
### DO use `=` to separate a named parameter from its default value.

For legacy reasons, Dart allows both `:` and `=` as the default value separator
for named parameters. For consistency with optional positional parameters, use
`=`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (default-separator)"?>
{% prettify dart %}
void insert(Object item, {int at = 0}) { ... }
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (default-separator)"?>
{% prettify dart %}
void insert(Object item, {int at: 0}) { ... }
{% endprettify %}
{% endcomment %}

### **要** 使用 `=` 来分隔参数名和参数默认值。

由于遗留原因，Dart 同时支持 `:` 和 `=` 作为参数名和默认值的分隔符。
为了与可选的位置参数保持一致，请使用 `=` 。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (default-separator)"?>
{% prettify dart %}
void insert(Object item, {int at = 0}) { ... }
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (default-separator)"?>
{% prettify dart %}
void insert(Object item, {int at: 0}) { ... }
{% endprettify %}

{% comment %}
### DON'T use an explicit default value of `null`.

If you make a parameter optional but don't give it a default value, the language
implicitly uses `null` as the default, so there's no need to write it.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (default-value-null)"?>
{% prettify dart %}
void error([String message]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (default-value-null)"?>
{% prettify dart %}
void error([String message = null]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}
{% endcomment %}

### **不要** 显式的为参数设置 `null` 值。

如果你创建了一个可选参数，那么就不要为其赋默认值，
Dart 默认使用 `null` 作为默认值，所以这里不需要为其 `null` 赋值语句。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (default-value-null)"?>
{% prettify dart %}
void error([String message]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (default-value-null)"?>
{% prettify dart %}
void error([String message = null]) {
  stderr.write(message ?? '\n');
}
{% endprettify %}

{% comment %}
## Variables

The following best practices describe how to best use variables in Dart.
{% endcomment %}

## 变量

下面是关于如何在 Dart 中使用变量的的最佳实践。

{% comment %}
### DON'T explicitly initialize variables to `null`.

In Dart, a variable or field that is not explicitly initialized automatically
gets initialized to `null`. This is reliably specified by the language. There's
no concept of "uninitialized memory" in Dart. Adding `= null` is redundant and
unneeded.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-null-init)"?>
{% prettify dart %}
int _nextId;

class LazyId {
  int _id;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-null-init)"?>
{% prettify dart %}
int _nextId = null;

class LazyId {
  int _id = null;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
{% endprettify %}
{% endcomment %}

### **不要** 显示的为参数初始化 `null` 值。

在Dart中，未自动显式初始化的变量或字段将初始化为 `null` 。
语言保证了赋值的可靠性。在 Dart 中没有“未初始化内存”的概念。
所以使用 `= null` 是多余的。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-null-init)"?>
{% prettify dart %}
int _nextId;

class LazyId {
  int _id;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-null-init)"?>
{% prettify dart %}
int _nextId = null;

class LazyId {
  int _id = null;

  int get id {
    if (_nextId == null) _nextId = 0;
    if (_id == null) _id = _nextId++;

    return _id;
  }
}
{% endprettify %}

{% comment %}
### AVOID storing what you can calculate.

When designing a class, you often want to expose multiple views into the same
underlying state. Often you see code that calculates all of those views in the
constructor and then stores them:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cacl-vs-store1)"?>
{% prettify dart %}
class Circle {
  num radius;
  num area;
  num circumference;

  Circle(num radius)
      : radius = radius,
        area = pi * radius * radius,
        circumference = pi * 2.0 * radius;
}
{% endprettify %}

This code has two things wrong with it. First, it's likely wasting memory. The
area and circumference, strictly speaking, are *caches*. They are stored
calculations that we could recalculate from other data we already have. They are
trading increased memory for reduced CPU usage. Do we know we have a performance
problem that merits that trade-off?

Worse, the code is *wrong*. The problem with caches is *invalidation*&mdash;how
do you know when the cache is out of date and needs to be recalculated? Here, we
never do, even though `radius` is mutable. You can assign a different value and
the `area` and `circumference` will retain their previous, now incorrect values.

To correctly handle cache invalidation, we need to do this:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cacl-vs-store2)"?>
{% prettify dart %}
class Circle {
  num _radius;
  num get radius => _radius;
  set radius(num value) {
    _radius = value;
    _recalculate();
  }

  num _area;
  num get area => _area;

  num _circumference;
  num get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
{% endprettify %}

That's an awful lot of code to write, maintain, debug, and read. Instead, your
first implementation should be:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cacl-vs-store)"?>
{% prettify dart %}
class Circle {
  num radius;

  Circle(this.radius);

  num get area => pi * radius * radius;
  num get circumference => pi * 2.0 * radius;
}
{% endprettify %}

This code is shorter, uses less memory, and is less error-prone. It stores the
minimal amount of data needed to represent the circle. There are no fields to
get out of sync because there is only a single source of truth.

In some cases, you may need to cache the result of a slow calculation, but only
do that after you know you have a performance problem, do it carefully, and
leave a comment explaining the optimization.
{% endcomment %}

### **避免** 保存可计算的结果。

在设计类的时候，你常常希望暴露底层状态的多个表现属性。
常常你会发现在类的构造函数中计算这些属性，然后保存起来：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cacl-vs-store1)"?>
{% prettify dart %}
class Circle {
  num radius;
  num area;
  num circumference;

  Circle(num radius)
      : radius = radius,
        area = pi * radius * radius,
        circumference = pi * 2.0 * radius;
}
{% endprettify %}

上面的代码有两个不妥之处。首先，这样浪费了内存。
严格来说面积和周长是*缓存*数据。
他们保存的结果可以通过已知的数据计算出来。
他们减少了 CPU 消耗却增加了内存消耗。
我们还没有权衡，到底存不存在性能问题？

更坏的情况是，上面的代码是 *错的* 。上面的缓存是*无效的*&mdash;
你如何知道什么时候缓存失效了需要重新计算？
在这里，我们永远不会从新计算，即使 `radius` 是可变的。
你可以给 `radius` 设置一个不同的值，但是 `area` 和 `circumference` 还是之前的值。

为了正确处理缓存失效，我们需要这样做：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (cacl-vs-store2)"?>
{% prettify dart %}
class Circle {
  num _radius;
  num get radius => _radius;
  set radius(num value) {
    _radius = value;
    _recalculate();
  }

  num _area;
  num get area => _area;

  num _circumference;
  num get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
{% endprettify %}

这需要编写、维护、调试以及阅读更多的代码。
如果你一开始这样写代码：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (cacl-vs-store)"?>
{% prettify dart %}
class Circle {
  num radius;

  Circle(this.radius);

  num get area => pi * radius * radius;
  num get circumference => pi * 2.0 * radius;
}
{% endprettify %}

上面的代码更加简洁、使用更少的内存、减少出错的可能性。
它尽可能少的保存了表示圆所需要的数据。
这里没有字段需要同步，因为这里只有一个有效数据源。

在某些情况下，当计算结果比较费时的时候可能需要缓存，
但是只应该在你只有你有这样的性能问题的时候再去处理，
处理时要仔细，并留下挂关于优化的注释。

{% comment %}
## Members

In Dart, objects have members which can be functions (methods) or data (instance
variables). The following best practices apply to an object's members.
{% endcomment %}

## 成员

在 Dart 中，对象成员可以是函数（方法）或数据（实例变量）。
下面是关于对象成员的最佳实践。

{% comment %}
### DON'T wrap a field in a getter and setter unnecessarily.

In Java and C#, it's common to hide all fields behind getters and setters (or
properties in C#), even if the implementation just forwards to the field. That
way, if you ever need to do more work in those members, you can without needing
to touch the callsites. This is because calling a getter method is different
than accessing a field in Java, and accessing a property isn't binary-compatible
with accessing a raw field in C#.

Dart doesn't have this limitation. Fields and getters/setters are completely
indistinguishable. You can expose a field in a class and later wrap it in a
getter and setter without having to touch any code that uses that field.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-wrap-field)"?>
{% prettify dart %}
class Box {
  var contents;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-wrap-field)"?>
{% prettify dart %}
class Box {
  var _contents;
  get contents => _contents;
  set contents(value) {
    _contents = value;
  }
}
{% endprettify %}
{% endcomment %}

### **不要** 为字段创建不必要的 getter 和 setter 方法。

在 Java 和 C# 中，通常情况下会将所有的字段隐藏到 getter 和 setter 方法中（在 C# 中被称为属性），
即使实现中仅仅是指向这些字段。在这种方式下，即使你在这些成员上做多少的事情，你也不需要直接访问它们。
这是因为，在 Java 中，调用 getter 方法和直接访问字段是不同的。
在 C# 中，访问属性与访问字段不是二进制兼容的。

Dart 不存在这个限制。字段和 getter/setter 是完全无法区分的。
你可以在类中公开一个字段，然后将其包装在 getter 和 setter 中，
而不会影响任何使用该字段的代码。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-wrap-field)"?>
{% prettify dart %}
class Box {
  var contents;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-wrap-field)"?>
{% prettify dart %}
class Box {
  var _contents;
  get contents => _contents;
  set contents(value) {
    _contents = value;
  }
}
{% endprettify %}

{% comment %}
### PREFER using a `final` field to make a read-only property.

If you have a field that outside code should be able to see but not assign to, a
simple solution that works in many cases is to simply mark it `final`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (final)"?>
{% prettify dart %}
class Box {
  final contents = [];
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (final)"?>
{% prettify dart %}
class Box {
  var _contents;
  get contents => _contents;
}
{% endprettify %}

Of course, if you need to internally assign to the field outside of the
constructor, you may need to do the "private field, public getter" pattern, but
don't reach for that until you need to.
{% endcomment %}

### **推荐** 使用 `final` 关键字来创建只读属性。

如果你有一个变量，对于外部代买来说只能读取不能修改，
最简单的做法就是使用 `final` 关键字来标记这个变量。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (final)"?>
{% prettify dart %}
class Box {
  final contents = [];
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (final)"?>
{% prettify dart %}
class Box {
  var _contents;
  get contents => _contents;
}
{% endprettify %}

当然，如果你需要构造一个内部可以赋值，外部可以访问的字段，
你可以需要这种“私有成员变量，公开访问函数”的模式，
但是，如非必要，请不要使用这种模式。

{% comment %}
### CONSIDER using `=>` for simple members.

In addition to using `=>` for function expressions, Dart also lets you define
members with it. That style is a good fit for simple members that just calculate
and return a value.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-arrow)"?>
{% prettify dart %}
double get area => (right - left) * (bottom - top);

bool isReady(num time) => minTime == null || minTime <= time;

String capitalize(String name) =>
    '${name[0].toUpperCase()}${name.substring(1)}';
{% endprettify %}

People *writing* code seem to love `=>`, but it's very easy to abuse it and end
up with code that's hard to *read*. If your declaration is more than a couple of
lines or contains deeply nested expressions&mdash;cascades and conditional
operators are common offenders&mdash;do yourself and everyone who has to read
your code a favor and use a block body and some statements.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (arrow-long)"?>
{% prettify dart %}
Treasure openChest(Chest chest, Point where) {
  if (_opened.containsKey(chest)) return null;

  var treasure = Treasure(where);
  treasure.addAll(chest.contents);
  _opened[chest] = treasure;
  return treasure;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (arrow-long)"?>
{% prettify dart %}
Treasure openChest(Chest chest, Point where) =>
    _opened.containsKey(chest) ? null : _opened[chest] = Treasure(where)
      ..addAll(chest.contents);
{% endprettify %}

You can also use `=>` on members that don't return a value. This is idiomatic
when a setter is small and has a corresponding getter that uses `=>`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (arrow-setter)"?>
{% prettify dart %}
num get x => center.x;
set x(num value) => center = Point(value, center.y);
{% endprettify %}

It's rarely a good idea to use `=>` for non-setter void members. The `=>`
implies "returns a value", so readers may misinterpret what the void member does
if you use it.
{% endcomment %}


### **考虑** 对简单成员使用 `=>` 。

除了使用 `=>` 可以用作函数表达式以外，
Dart 还允许使用它来定义成员。
这种风格非常适合，仅进行计算并返回结果的简单成员。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (use-arrow)"?>
{% prettify dart %}
double get area => (right - left) * (bottom - top);

bool isReady(num time) => minTime == null || minTime <= time;

String capitalize(String name) =>
    '${name[0].toUpperCase()}${name.substring(1)}';
{% endprettify %}

*编写*代码的人似乎很喜欢 `=>` 语法，但是它很容易被滥用，最后导致代码不容易被*阅读*。
如果你有很多行声明或包含深层的嵌套表达式（级联和条件运算符就是常见的罪魁祸首），
你以及其他人有谁会愿意读这样的代码！
你应该换做使用代码块和一些语句来实现。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (arrow-long)"?>
{% prettify dart %}
Treasure openChest(Chest chest, Point where) {
  if (_opened.containsKey(chest)) return null;

  var treasure = Treasure(where);
  treasure.addAll(chest.contents);
  _opened[chest] = treasure;
  return treasure;
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (arrow-long)"?>
{% prettify dart %}
Treasure openChest(Chest chest, Point where) =>
    _opened.containsKey(chest) ? null : _opened[chest] = Treasure(where)
      ..addAll(chest.contents);
{% endprettify %}

您还可以对不返回值的成员使用 `=>` 。 
这里有个惯例，就是当 setter 和 getter 都比较简单的时候使用 `=>` 。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (arrow-setter)"?>
{% prettify dart %}
num get x => center.x;
set x(num value) => center = Point(value, center.y);
{% endprettify %}

对非 setter，void 返回值的成员，使用 `=>` 是一个不错的注意，
`=>` 语法暗示会“返回一个值”，如果你在 void 返回值的成员上使用，会让读代码的人误解成员的行为。


{% comment %}
### DON'T use `this.` when not needed to avoid shadowing.

JavaScript requires an explicit `this.` to refer to members on the object whose
method is currently being executed, but Dart&mdash;like C++, Java, and
C#&mdash;doesn't have that limitation.

The only time you need to use `this.` is when a local variable with the same
name shadows the member you want to access.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (this-dot)"?>
{% prettify dart %}
class Box {
  var value;

  void clear() {
    this.update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (this-dot)"?>
{% prettify dart %}
class Box {
  var value;

  void clear() {
    update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

Note that constructor parameters never shadow fields in constructor
initialization lists:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (param-dont-shadow-field-ctr-init)"?>
{% prettify dart %}
class Box extends BaseBox {
  var value;

  Box(value)
      : value = value,
        super(value);
}
{% endprettify %}

This looks surprising, but works like you want. Fortunately, code like this is
relatively rare thanks to initializing formals.
{% endcomment %}

### **不要** 使用 `this.` ，除非遇到了变量冲突的情况。

JavaScript 需要使用 `this.` 来引用对象的成员变量，
但是 Dart&mdash;和 C++, Java, 以及C#&mdash;没有这种限制。

只有当局部变量和成员变量名字一样的时候，你才需要使用 `this.` 来访问成员变量。

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (this-dot)"?>
{% prettify dart %}
class Box {
  var value;

  void clear() {
    this.update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (this-dot)"?>
{% prettify dart %}
class Box {
  var value;

  void clear() {
    update(null);
  }

  void update(value) {
    this.value = value;
  }
}
{% endprettify %}

注意，构造函数初始化列表中的字段有永远不会与构造函数参数列表参数产生冲突。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (param-dont-shadow-field-ctr-init)"?>
{% prettify dart %}
class Box extends BaseBox {
  var value;

  Box(value)
      : value = value,
        super(value);
}
{% endprettify %}

这看起来很令人惊讶，但是实际结果是你想要的。
幸运的是，由于初始化规则的特殊性，上面的代码很少见到。


{% comment %}
### DO initialize fields at their declaration when possible.

If a field doesn't depend on any constructor parameters, it can and should be
initialized at its declaration. It takes less code and makes sure you won't
forget to initialize it if the class has multiple constructors.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (field-init-at-decl)"?>
{% prettify dart %}
class Folder {
  final String name;
  final List<Document> contents;

  Folder(this.name) : contents = [];
  Folder.temp() : name = 'temporary'; // Oops! Forgot contents.
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-at-decl)"?>
{% prettify dart %}
class Folder {
  final String name;
  final List<Document> contents = [];

  Folder(this.name);
  Folder.temp() : name = 'temporary';
}
{% endprettify %}

Of course, if a field depends on constructor parameters, or is initialized
differently by different constructors, then this guideline does not apply.
{% endcomment %}


### **要** 尽可能的在定义变量的时候初始化变量值。

如果一个字段不依赖于构造函数中的参数，
则应该在定义的时候就初始化字段值。
这样可以减少需要的代码并可以确保在有多个构造函数的时候你不会忘记初始化该字段。

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (field-init-at-decl)"?>
{% prettify dart %}
class Folder {
  final String name;
  final List<Document> contents;

  Folder(this.name) : contents = [];
  Folder.temp() : name = 'temporary'; // Oops! Forgot contents.
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-at-decl)"?>
{% prettify dart %}
class Folder {
  final String name;
  final List<Document> contents = [];

  Folder(this.name);
  Folder.temp() : name = 'temporary';
}
{% endprettify %}

当然，对于变量取值依赖构造函数参数的情况以及不同的构造函数取值也不一样的情况，
则不适合本条规则。


{% comment %}
## Constructors

The following best practices apply to declaring constructors for a class.
{% endcomment %}

## 构造函数

下面对于类的构造函数的最佳实践。

{% comment %}
### DO use initializing formals when possible.

Many fields are initialized directly from a constructor parameter, like:

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (field-init-as-param)"?>
{% prettify dart %}
class Point {
  num x, y;
  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
}
{% endprettify %}

We've got to type `x` _four_ times here define a field. Lame. We can do better:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-as-param)"?>
{% prettify dart %}
class Point {
  num x, y;
  Point(this.x, this.y);
}
{% endprettify %}

This `this.` syntax before a constructor parameter is called an "initializing
formal". You can't always take advantage of it. In particular, using it means
the parameter is not visible in the initialization list. But, when you can, you
should.
{% endcomment %}

### **要** 尽可能的使用初始化形式。

许多字段直接使用构造函数参数来初始化，如：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (field-init-as-param)"?>
{% prettify dart %}
class Point {
  num x, y;
  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
}
{% endprettify %}

为了初始化一个字段，我们需要取_四_次 `x` 。使用下面的方式会更好：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-as-param)"?>
{% prettify dart %}
class Point {
  num x, y;
  Point(this.x, this.y);
}
{% endprettify %}

这里的位于构造函数参数之前的 `this.` 语法被称之为初始化形式（initializing formal）。
有些情况下这无法使用这种形式。特别是，这种形式下在初始化列表中无法看到变量。 
但是如果能使用该方式，就应该尽量使用。


{% comment %}
### DON'T type annotate initializing formals.

If a constructor parameter is using `this.` to initialize a field, then the type
of the parameter is understood to be the same type as the field.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-type-init-formals)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-type-init-formals)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(int this.x, int this.y);
}
{% endprettify %}
{% endcomment %}

### **不要** 在初始化形式中做类型注释。

如果构造函数参数使用 `this.` 的方式来初始化字段，
这时参数的类型被认为和字段类型相同。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (dont-type-init-formals)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (dont-type-init-formals)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(int this.x, int this.y);
}
{% endprettify %}


{% comment %}
### DO use `;` instead of `{}` for empty constructor bodies.

In Dart, a constructor with an empty body can be terminated with just a
semicolon. (In fact, it's required for const constructors.)

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (semicolon-for-empty-body)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (semicolon-for-empty-body)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y) {}
}
{% endprettify %}
{% endcomment %}

### **要** 用 `;` 来替代空的构造函数体 `{}`。

在 Dart 中，没有具体函数体的构造函数可以使用分号结尾。
（事实上，这是不可变构造函数的要求。）

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (semicolon-for-empty-body)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (semicolon-for-empty-body)"?>
{% prettify dart %}
class Point {
  int x, y;
  Point(this.x, this.y) {}
}
{% endprettify %}

{% comment %}
### DON'T use `new`.

Dart 2 makes the `new` keyword optional. Even in Dart 1, its meaning was never
clear because factory constructors mean a `new` invocation may still not
actually return a new object.

The language still permits `new` in order to make migration less painful, but
consider it deprecated and remove it from your code.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-new)"?>
{% prettify dart %}
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(
        child: Text('Increment'),
      ),
      Text('Click!'),
    ],
  );
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-new)" replace="/new/[!$&!]/g"?>
{% prettify dart %}
Widget build(BuildContext context) {
  return [!new!] Row(
    children: [
      [!new!] RaisedButton(
        child: [!new!] Text('Increment'),
      ),
      [!new!] Text('Click!'),
    ],
  );
}
{% endprettify %}
{% endcomment %}

### **不要** 使用 `new` 。

Dart 2 `new` 关键字成为可选项。
即使在Dart 1中，其含义也从未明确过，
以为在工厂构造函数中，调用 `new` 可能并不意味着一定会返回一个新对象。

为了减少代码迁移时的痛苦， Dart 语言仍允许使用 `new` 关键字，
但请考在你的代码中弃用和删除 `new` 。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-new)"?>
{% prettify dart %}
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(
        child: Text('Increment'),
      ),
      Text('Click!'),
    ],
  );
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-new)" replace="/new/[!$&!]/g"?>
{% prettify dart %}
Widget build(BuildContext context) {
  return [!new!] Row(
    children: [
      [!new!] RaisedButton(
        child: [!new!] Text('Increment'),
      ),
      [!new!] Text('Click!'),
    ],
  );
}
{% endprettify %}

{% comment %}
### DON'T use `const` redundantly.

In contexts where an expression *must* be constant, the `const` keyword is
implicit, doesn't need to be written, and shouldn't. Those contexts are any
expression inside:

* A const collection literal.
* A const constructor call
* A metadata annotation.
* The initializer for a const variable declaration.
* A switch case expression&mdash;the part right after `case` before the `:`, not
  the body of the case.

(Default values are not included in this list because future versions of Dart
may support non-const default values.)

Basically, any place where it would be an error to write `new` instead of
`const`, Dart 2 allows you to omit the `const`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-const)"?>
{% prettify dart %}
const primaryColors = [
  Color("red", [255, 0, 0]),
  Color("green", [0, 255, 0]),
  Color("blue", [0, 0, 255]),
];
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-const)" replace="/ (const)/ [!$1!]/g"?>
{% prettify dart %}
const primaryColors = [!const!] [
  [!const!] Color("red", [!const!] [255, 0, 0]),
  [!const!] Color("green", [!const!] [0, 255, 0]),
  [!const!] Color("blue", [!const!] [0, 0, 255]),
];
{% endprettify %}
{% endcomment %}

### **不要** 冗余地使用 `const` 。

在表达式一定是常量的上下文中，`const` 关键字是隐式的，不需要写，也不应该。
这里包括：

* 一个字面量常量集合。
* 调用一个常量构造函数。
* 元数据注解。
* 一个常量声明的初始化方法。
* switch case 表达式—— `case` 和 `:` 中间的部分，不是 case 执行体。

（默认值并不包含在这个列表中，因为在 Dart 将来的版本中可能会在支持非常量的默认值。）

基本上，任何地方用 `new` 替代 `const` 的写法都是错的，
因为 Dart 2 中允许省略 `const` 。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (no-const)"?>
{% prettify dart %}
const primaryColors = [
  Color("red", [255, 0, 0]),
  Color("green", [0, 255, 0]),
  Color("blue", [0, 0, 255]),
];
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (no-const)" replace="/ (const)/ [!$1!]/g"?>
{% prettify dart %}
const primaryColors = [!const!] [
  [!const!] Color("red", [!const!] [255, 0, 0]),
  [!const!] Color("green", [!const!] [0, 255, 0]),
  [!const!] Color("blue", [!const!] [0, 0, 255]),
];
{% endprettify %}

{% comment %}
## Error handling

Dart uses exceptions when an error occurs in your program. The following
best practices apply to catching and throwing exceptions.
{% endcomment %}

## 错误处理

Dart 使用异常来表示程序执行错误。
下面是关于如何捕获和抛出异常的最佳实践。

{% comment %}
### AVOID catches without `on` clauses.

A catch clause with no `on` qualifier catches *anything* thrown by the code in
the try block. [Pokémon exception handling][pokemon] is very likely not what you
want. Does your code correctly handle [StackOverflowError][] or
[OutOfMemoryError][]? If you incorrectly pass the wrong argument to a method in
that try block do you want to have your debugger point you to the mistake or
would you rather that helpful [ArgumentError][] get swallowed? Do you want any
`assert()` statements inside that code to effectively vanish since you're
catching the thrown [AssertionError][]s?

The answer is probably "no", in which case you should filter the types you
catch. In most cases, you should have an `on` clause that limits you to the
kinds of runtime failures you are aware of and are correctly handling.

In rare cases, you may wish to catch any runtime error. This is usually in
framework or low-level code that tries to insulate arbitrary application code
from causing problems. Even here, it is usually better to catch [Exception][]
than to catch all types. Exception is the base class for all *runtime* errors
and excludes errors that indicate *programmatic* bugs in the code.
{% endcomment %}

### **避免** 使用没有 `on` 语句的 catch。

没有 `on` 限定的 catch 语句会捕获 try 代码块中抛出的*任何*异常。
[Pokémon exception handling][pokemon] 可能并不是你想要的。
你的代码是否正确的处理 [StackOverflowError][] 或者 [OutOfMemoryError][] 异常？
如果你使用错误的参数调用函数，你是期望调试器定位出你的错误使用情况还是，
把这个有用的 [ArgumentError][] 给吞噬了？
由于你捕获了 [AssertionError][] 异常，
导致所有 try 块内的 `assert()` 语句都失效了，这是你需要的结果吗？

答案和可能是 "no"，在这种情况下，您应该过滤掉捕获的类型。
在大多数情况下，您应该有一个 `on` 子句，
这样它能够捕获程序在运行时你所关注的限定类型的异常并进行恰当处理。

{% comment %}
### DON'T discard errors from catches without `on` clauses.

If you really do feel you need to catch *everything* that can be thrown from a
region of code, *do something* with what you catch. Log it, display it to the
user or rethrow it, but do not silently discard it.
{% endcomment %}

### **不要** 丢弃没有使用 `on` 语句捕获的异常。

如果你真的期望捕获一段代码内的 *所有* 异常，
请*在捕获异常的地方做些事情*。 记录下来并显示给用户，
或者重新抛出（rethrow）异常信息，记得不要默默的丢弃该异常信息。

{% comment %}
### DO throw objects that implement `Error` only for programmatic errors.

The [Error][] class is the base class for *programmatic* errors. When an object
of that type or one of its subinterfaces like [ArgumentError][] is thrown, it
means there is a *bug* in your code. When your API wants to report to a caller
that it is being used incorrectly throwing an Error sends that signal clearly.

Conversely, if the exception is some kind of runtime failure that doesn't
indicate a bug in the code, then throwing an Error is misleading. Instead, throw
one of the core Exception classes or some other type.
{% endcomment %}

### **要** 只在代表编程错误的情况下才抛出实现了 `Error` 的异常。

[Error][] 类是所有 *编码* 错误的基类。当一个该类型或者其子类型，
例如 [ArgumentError][] 对象被抛出了，这意味着是你代码中的一个 *bug*。
当你的 API 想要告诉调用者使用错误的时候可以抛出一个 Error 来表明你的意图。

同样的，如果一个异常表示为运行时异常而不是代码 bug， 则抛出 Error 则会误导调用者。
应该抛出核心定义的 Exception 类或者其他类型。

{% comment %}
### DON'T explicitly catch `Error` or types that implement it.

This follows from the above. Since an Error indicates a bug in your code, it
should unwind the entire callstack, halt the program, and print a stack trace so
you can locate and fix the bug.

[error]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/Error-class.html

Catching errors of these types breaks that process and masks the bug. Instead of
*adding* error-handling code to deal with this exception after the fact, go back
and fix the code that is causing it to be thrown in the first place.
{% endcomment %}

### **不要** 显示的捕获 `Error` 或者其子类。

本条衔接上一天内容。既然 Error 表示代码中的 bug，
应该展开整个调用堆栈，暂停程序并打印堆栈跟踪，以便找到错误并修复。

[error]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/Error-class.html

捕获这类错误打破了处理流程并且代码中有 bug。
不要在这里使用错误处理代码，而是需要到导致该错误出现的地方修复你的代码。

{% comment %}
### DO use `rethrow` to rethrow a caught exception.

If you decide to rethrow an exception, prefer using the `rethrow` statement
instead of throwing the same exception object using `throw`.
`rethrow` preserves the original stack trace of the exception. `throw` on the
other hand resets the stack trace to the last thrown position.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (rethrow)"?>
{% prettify dart %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (rethrow)" replace="/rethrow/[!$&!]/g"?>
{% prettify dart %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) [!rethrow!];
  handle(e);
}
{% endprettify %}
{% endcomment %}

### **要** 使用 `rethrow` 来重新抛出捕获的异常。

如果你想重新抛出一个异常，推荐使用 `rethrow` 语句。
`rethrow` 保留了原来的异常堆栈信息。 
而 `throw` 会把异常堆栈信息重置为最后抛出的位置。

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (rethrow)"?>
{% prettify dart %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (rethrow)" replace="/rethrow/[!$&!]/g"?>
{% prettify dart %}
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) [!rethrow!];
  handle(e);
}
{% endprettify %}

{% comment %}
## Asynchrony

Dart has several language features to support asynchronous programming.
The following best practices apply to asynchronous coding.
{% endcomment %}

## 异步

Dart 具有几个语言特性来支持异步编程。
下面是针对异步编程的最佳实践。

{% comment %}
### PREFER async/await over using raw futures.

Asynchronous code is notoriously hard to read and debug, even when using a nice
abstraction like futures. The `async`/`await` syntax improves readability and
lets you use all of the Dart control flow structures within your async code.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (async-await)" replace="/async|await/[!$&!]/g"?>
{% prettify dart %}
Future<int> countActivePlayers(String teamName) [!async!] {
  try {
    var team = [!await!] downloadTeam(teamName);
    if (team == null) return 0;

    var players = [!await!] team.roster;
    return players.where((player) => player.isActive).length;
  } catch (e) {
    log.error(e);
    return 0;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (async-await)"?>
{% prettify dart %}
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName).then((team) {
    if (team == null) return Future.value(0);

    return team.roster.then((players) {
      return players.where((player) => player.isActive).length;
    });
  }).catchError((e) {
    log.error(e);
    return 0;
  });
}
{% endprettify %}
{% endcomment %}

### **推荐** 使用 async/await 而不是直接使用底层的特性。

显式的异步代码是非常难以阅读和调试的，
即使使用很好的抽象（比如 future）也是如此。
这就是为何 Dart 提供了 `async`/`await`。
这样可以显著的提高代码的可读性并且让你可以在异步代码中使用语言提供的所有流程控制语句。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (async-await)" replace="/async|await/[!$&!]/g"?>
{% prettify dart %}
Future<int> countActivePlayers(String teamName) [!async!] {
  try {
    var team = [!await!] downloadTeam(teamName);
    if (team == null) return 0;

    var players = [!await!] team.roster;
    return players.where((player) => player.isActive).length;
  } catch (e) {
    log.error(e);
    return 0;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (async-await)"?>
{% prettify dart %}
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName).then((team) {
    if (team == null) return Future.value(0);

    return team.roster.then((players) {
      return players.where((player) => player.isActive).length;
    });
  }).catchError((e) {
    log.error(e);
    return 0;
  });
}
{% endprettify %}

{% comment %}
### DON'T use `async` when it has no useful effect.

It's easy to get in the habit of using `async` on any function that does
anything related to asynchrony. But in some cases, it's extraneous. If you can
omit the `async` without changing the behavior of the function, do so.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (unnecessary-async)"?>
{% prettify dart %}
Future afterTwoThings(Future first, Future second) {
  return Future.wait([first, second]);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (unnecessary-async)"?>
{% prettify dart %}
Future afterTwoThings(Future first, Future second) async {
  return Future.wait([first, second]);
}
{% endprettify %}

Cases where `async` *is* useful include:

* You are using `await`. (This is the obvious one.)

* You are returning an error asynchronously. `async` and then `throw` is shorter
  than `return Future.error(...)`.

* You are returning a value and you want it implicitly wrapped in a future.
  `async` is shorter than `Future.value(...)`.

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (async)"?>
{% prettify dart %}
Future usesAwait(Future later) async {
  print(await later);
}

Future asyncError() async {
  throw 'Error!';
}

Future asyncValue() async => 'value';
{% endprettify %}
{% endcomment %}

### **不要** 在没有有用效果的情况下使用 `async` 。

当成为习惯之后，你可能会在所有和异步相关的函数使用 `async`。但是在有些情况下，
如果可以忽略 `async`  而不改变方法的行为，则应该这么做：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (unnecessary-async)"?>
{% prettify dart %}
Future afterTwoThings(Future first, Future second) {
  return Future.wait([first, second]);
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (unnecessary-async)"?>
{% prettify dart %}
Future afterTwoThings(Future first, Future second) async {
  return Future.wait([first, second]);
}
{% endprettify %}

下面这些情况 `async` 是有用的：

* 你使用了 `await`。 (这是一个很明显的例子。)

* 你在异步的抛出一个异常。 `async` 然后 `throw` 比 `return new Future.error(...)` 要简短很多。

* 你在返回一个值，但是你希望他显式的使用 Future。`async` 比 `new Future.value(...)` 要简短很多。

* 你不希望在事件循环发生事件之前执行任何代码。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (async)"?>
{% prettify dart %}
Future usesAwait(Future later) async {
  print(await later);
}

Future asyncError() async {
  throw 'Error!';
}

Future asyncValue() async => 'value';
{% endprettify %}


{% comment %}
### CONSIDER using higher-order methods to transform a stream.

This parallels the above suggestion on iterables. Streams support many of the
same methods and also handle things like transmitting errors, closing, etc.
correctly.
{% endcomment %}

### **考虑** 使用高阶函数来转换事件流（stream）

This parallels the above suggestion on iterables. Streams support many of the
same methods and also handle things like transmitting errors, closing, etc.
correctly.

{% comment %}
### AVOID using Completer directly.

Many people new to asynchronous programming want to write code that produces a
future. The constructors in Future don't seem to fit their need so they
eventually find the Completer class and use that.

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (avoid-completer)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) {
  var completer = Completer<bool>();

  File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
{% endprettify %}

Completer is needed for two kinds of low-level code: new asynchronous
primitives, and interfacing with asynchronous code that doesn't use futures.
Most other code should use async/await or [`Future.then()`][then], because
they're clearer and make error handling easier.

[then]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/then.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-completer)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) {
  return File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-completer-alt)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) async {
  var contents = await File(path).readAsString();
  return contents.contains('bear');
}
{% endprettify %}
{% endcomment %}

### **避免** 直接使用 Completer  。

很多异步编程的新手想要编写生成一个 future 的代码。
而 Future 的构造函数看起来并不满足他们的要求，
然后他们就发现 Completer 类并使用它：

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (avoid-completer)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) {
  var completer = Completer<bool>();

  File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
{% endprettify %}

Completer 是用于两种底层代码的：
新的异步原子操作和集成没有使用 Future 的异步代码。
大部分的代码都应该使用 async/await 或者 [`Future.then()`][then]，
这样代码更加清晰并且异常处理更加容易。

[then]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future/then.html

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-completer)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) {
  return File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
{% endprettify %}

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (avoid-completer-alt)"?>
{% prettify dart %}
Future<bool> fileContainsBear(String path) async {
  var contents = await File(path).readAsString();
  return contents.contains('bear');
}
{% endprettify %}

{% comment %}
### DO test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`.

Before you can do anything useful with a `FutureOr<T>`, you typically need to do
an `is` check to see if you have a `Future<T>` or a bare `T`. If the type
argument is some specific type as in `FutureOr<int>`, it doesn't matter which
test you use, `is int` or `is Future<int>`. Either works because those two types
are disjoint.

However, if the value type is `Object` or a type parameter that could possibly
be instantiated with `Object`, then the two branches overlap. `Future<Object>`
itself implements `Object`, so `is Object` or `is T` where `T` is some type
parameter that could be instantiated with `Object` returns true even when the
object is a future. Instead, explicitly test for the `Future` case:

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (test-future-or)"?>
{% prettify dart %}
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is Future<T>) {
    var result = await value;
    print(result);
    return result;
  } else {
    print(value);
    return value as T;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (test-future-or)"?>
{% prettify dart %}
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is T) {
    print(value);
    return value;
  } else {
    var result = await value;
    print(result);
    return result;
  }
}
{% endprettify %}

In the bad example, if you pass it a `Future<Object>`, it incorrectly treats it
like a bare, synchronous value.
{% endcomment %}

### **要** 使用 `Future<T>` 对 `FutureOr<T>` 参数进行测试，以消除参数可能是 `Object` 类型的歧义。

在使用 `FutureOr<T>` 执行任何有用的操作之前，
通常需要做 `is` 检查，来确定你拥有的是 `Future<T>` 还是一个空的 `T`。
如果类型参数是某个特定类型，如 `FutureOr <int>`，
使用 `is int` 或 `is Future<int>` 那种测试都可以。
两者都有效，因为这两种类型是不相交的。

但是，如果值的类型是 `Object` 或者可能使用 `Object` 实例化的类型参数，这时要分两种情况。
`Future<Object>` 本身继承 `Object` ，使用 `is Object` 或 `is T` ，
其中 `T` 表示参数的类型，该参数可能是 `Object` 的实例，
在这种情况下，即使是 future 对象也会返回 true 。
相反，下面是确切测试 `Future` 的例子：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/usage_good.dart (test-future-or)"?>
{% prettify dart %}
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is Future<T>) {
    var result = await value;
    print(result);
    return result;
  } else {
    print(value);
    return value as T;
  }
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/usage_bad.dart (test-future-or)"?>
{% prettify dart %}
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is T) {
    print(value);
    return value;
  } else {
    var result = await value;
    print(result);
    return result;
  }
}
{% endprettify %}

在错误的示例中，如果给它传一个 `Future<Object>` ，
它会错误地将其视为一个空的同步对象值。

[pokemon]: https://blog.codinghorror.com/new-programming-jargon/
[StackOverflowError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/StackOverflowError-class.html
[OutOfMemoryError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/OutOfMemoryError-class.html
[ArgumentError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError-class.html
[AssertionError]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/AssertionError-class.html
[Exception]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Exception-class.html