---
title: "Effective Dart: 文档"
description: Clear, helpful comments and documentation.
nextpage:
  url: /guides/language/effective-dart/usage
  title: 使用
prevpage:
  url: /guides/language/effective-dart/style
  title: 风格
---

{% include effective-dart-banner.html %}

你可能没有意识到，今天你很容易想出来的代码，有多么依赖你当时思路。
人们不熟悉你的代码，甚至你也忘记了当时代码功能中有这样的思路。
简明，扼要的注释只需花费几秒钟的时间去写，但可以让每个这样的人节约几个小时。

我们知道代码应该子文档（self-documenting），并不是所有的注释都是有用的。
但实际情况是，我们大多数人都没有写出尽可能多的评论。
和练习一样：从技术上你*可以*做很多，但是实际上你
只做了一点点。尝试着逐步提高。

* TOC
{:toc}

## 注释

下面的要点用于注释，这里的注释不包含生成的文档注释。

### **要** 像句子一样来格式化注释。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (comments-like-sentences)"?>
{% prettify dart %}
// Not if there is nothing before it.
if (_chunks.isEmpty) return false;
{% endprettify %}

如果第一个单词不是大小写相关的标识符，则首字母要大写。
使用句号，叹号或者问号结尾。所有的注释都应该这样：
文档注释，单行注释，甚至 TODO。即使它是一个句子的片段。

### **不要** 使用块注释作用作解释说明。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (block-comments)"?>
{% prettify dart %}
greet(name) {
  // Assume we have a valid name.
  print('Hi, $name!');
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_bad.dart (block-comments)"?>
{% prettify dart %}
greet(name) {
  /* Assume we have a valid name. */
  print('Hi, $name!');
}
{% endprettify %}

可以使用块注释 (`/* ... */`) 来临时的注释掉一段代码，
但是其他的所有注释都应该使用 `//`。

## 文档注释

文档注释特别有用，应为通过 [dartdoc][] 解析这些注释可以生成 [漂亮的文档网页][docs]。
文档注释包括所有出现在声明之前并使用 `///` 语法的注释，这些注释使用使用 dartdoc 检索。

[dartdoc]: https://github.com/dart-lang/dartdoc
[docs]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}

### **要** 使用 `///` 文档注释来注释成员和类型。

使用文档注释可以让 [dartdoc][] 来为你生成代码 API 文档。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (use-doc-comments)"?>
{% prettify dart %}
/// The number of characters in this chunk when unsplit.
int get length => ...
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (use-doc-comments)" replace="/^\///g"?>
{% prettify dart %}
// The number of characters in this chunk when unsplit.
int get length => ...
{% endprettify %}

由于历史原因，dartdoc 支持两种格式的文档注释：`///` ("C# 格式") 和 `/** ... */` ("JavaDoc 格式")。
我们推荐使用 `///` 是因为其更加简洁。
`/**` 和 `*/` 在多行注释中间添加了开头和结尾的两行多余内容。
`///` 在一些情况下也更加易于阅读，例如，当文档注释中包含有使用 `*` 标记的列表内容的时候。

如果你现在还在使用 JavaDoc 风格格式，请考虑使用新的格式。

### **推荐** 为公开发布的 API 编写文档注释。

不必为所有独立的库，顶级变量，类型以及成员编写文档注释。
但是它们大多数应该有文档注释。

### **考虑** 编写库级别（library-level）的文档注释。

与Java等类似的语言不同，Java 中类是程序组织的唯一单元。
在 Dart 中，库本身就是一个实体，用户可以直接使用，导入及构思它。
这使得`库`成为一个展示文档的好地方。
这样可以向读者介绍其中提供的主要概念和功能。
其中可以考虑包括下列内容：

* 关于库用途的单句摘要。
* 解释库中用到的术语。
* 一些配合 API 的示例代码
* 最重要和最常用的类和函数的链接。
* 和库相关领域的外部链接。

你可以通过在文件开头的 `library` 的上方放置 doc 注释来文档注释一个库。
如果库没有 `library` 指令，您可以添加一个，只是挂起 doc 注释。
（If the library doesn't have a `library`
directive, you can add one just to hang the doc comment off of it.）

### **推荐** 为私有API 编写文档注释。

文档注释不仅仅适用于外部用户使用你库的公开 API.
它也同样有助于理解那些私有成员，这些私有成员会被库的其他部分调用。

### **要** 要在文档注释开头有一个单句总结。

注释文档要以一个以用户为中心，简要的描述作为开始。
通常句子片段就足够了。为读者提供足够的上下文来定位自己，
并决定是否应该继续阅读，或寻找其他解决问题的方法。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (first-sentence)"?>
{% prettify dart %}
/// Deletes the file at [path] from the file system.
void delete(String path) => ...
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_bad.dart (first-sentence)"?>
{% prettify dart %}
/// Depending on the state of the file system and the user's permissions,
/// certain operations may or may not be possible. If there is no file at
/// [path] or it can't be accessed, this function throws either [IOError]
/// or [PermissionError], respectively. Otherwise, this deletes the file.
void delete(String path) => ...
{% endprettify %}

### **要** 让文档注释的第一句从段落中分开。 

在第一句之后添加一个空行，将其拆分为自己的段落。 
如果不止一个解释句子有用，请将其余部分放在后面的段落中。

这有助于您编写一个紧凑的第一句话来总结文档。 
此外，像Dartdoc这样的工具使用第一段作为类和类成员列表等地方的简短摘要。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (first-sentence-a-paragraph)"?>
{% prettify dart %}
/// Deletes the file at [path].
///
/// Throws an [IOError] if the file could not be found. Throws a
/// [PermissionError] if the file is present but could not be deleted.
void delete(String path) => ...
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_bad.dart (first-sentence-a-paragraph)"?>
{% prettify dart %}
/// Deletes the file at [path]. Throws an [IOError] if the file could not
/// be found. Throws a [PermissionError] if the file is present but could
/// not be deleted.
void delete(String path) => ...
{% endprettify %}

### **避免** 与周围上下文冗余。

阅读类的文档注释的可以清楚地看到类的名称，它实现的接口等等。
当读取成员的文档时，命名和封装它的类是显而易见的。 
这些都不需要写在文档注释中。 
相反，应该专注于解释读者所不知道的内容。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (redundant)"?>
{% prettify dart %}
class RadioButtonWidget extends Widget {
  /// Sets the tooltip to [lines], which should have been word wrapped using
  /// the current font.
  void tooltip(List<String> lines) => ...
}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_bad.dart (redundant)"?>
{% prettify dart %}
class RadioButtonWidget extends Widget {
  /// Sets the tooltip for this radio button widget to the list of strings in
  /// [lines].
  void tooltip(List<String> lines) => ...
}
{% endprettify %}


### **推荐** 用第三人称来开始函数或者方法的文档注释。

注释应该关注于代码 *所实现的* 功能。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (third-person)"?>
{% prettify dart %}
/// Returns `true` if every element satisfies the [predicate].
bool all(bool predicate(T element)) => ...

/// Starts the stopwatch if not already running.
void start() => ...
{% endprettify %}

### **推荐** 使用名词短语来开始变量、getter、setter 的注释。

注释文档应该表述这个属性*是*什么。虽然 getter 函数会做些计算，
但是也要求这样，调用者关心的是其*结果*而不是如何计算的。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (noun-phrases-for-var-etc)"?>
{% prettify dart %}
/// The current day of the week, where `0` is Sunday.
int weekday;

/// The number of checked buttons on the page.
int get checkedCount => ...
{% endprettify %}

避免同时为 setter 和 getter 加文档注释，
DartDoc 只会展示其中一个（getter上的文档注释）。

### **推荐** 使用名词短语来开始库和类型注释。

在程序中，类的注释通常是最重要的文档。
类的注释描述了类型的不变性、介绍其使用的术语、
提供类成员使用的上下文信息。为类提供一些注释可以让
其他类成员的注释更易于理解和编写。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (noun-phrases-for-type-or-lib)"?>
{% prettify dart %}
/// A chunk of non-breaking output text terminated by a hard or soft newline.
///
/// ...
class Chunk { ... }
{% endprettify %}

### **考虑** 在文档注释中添加示例代码。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (code-sample)"?>
{% prettify dart %}
/// Returns the lesser of two numbers.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
{% endprettify %}

人类非常擅长从示例中抽象出实质内容，所以即使提供
一行最简单的示例代码都可以让 API 更易于理解。

### **要** 使用方括号在文档注释中引用作用域内的标识符。

如果给变量，方法，或类型等名称加上方括号，则 dartdoc 会查找名称并链接到相关的 API 文档。
括号是可选的，但是当你在引用一个方法或者构造函数时，可以让注释更清晰。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (identifiers)"?>
{% prettify none %}
/// Throws a [StateError] if ...
/// similar to [anotherMethod()], but ...
{% endprettify %}

要链接到特定类的成员，请使用以点号分割的类名和成员名：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (member)"?>
{% prettify none %}
/// Similar to [Duration.inDays], but handles fractional days.
{% endprettify %}

点语法也可用于引用命名构造函数。 对于未命名的构造函数，在类名后面加上括号：

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (ctor)"?>
{% prettify none %}
/// To create a point, call [Point()] or use [Point.polar()] to ...
{% endprettify %}

### **要** 使用散文的方式来描述参数、返回值以及异常信息。

其他语言使用各种标签和额外的注释来描述参数和返回值。

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_bad.dart (no-annotations)"?>
{% prettify dart %}
/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbr) => ...
{% endprettify %}

而 Dart 把参数、返回值等描述放到文档注释中，
并使用方括号来引用以及高亮这些参数和返回值。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (no-annotations)"?>
{% prettify dart %}
/// Defines a flag.
///
/// Throws an [ArgumentError] if there is already an option named [name] or
/// there is already an option using abbreviation [abbr]. Returns the new flag.
Flag addFlag(String name, String abbr) => ...
{% endprettify %}

### **要** 把注释文档放到注解之前。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (doc-before-meta)"?>
{% prettify dart %}
/// A button that can be flipped on and off.
@Component(selector: 'toggle')
class ToggleComponent {}
{% endprettify %}

{:.bad-style}
<?code-excerpt "misc/lib/effective_dart/docs_bad.dart (doc-before-meta)" replace="/\n\n/\n/g"?>
{% prettify dart %}
@Component(selector: 'toggle')
/// A button that can be flipped on and off.
class ToggleComponent {}
{% endprettify %}


## Markdown

文档注释中允许使用大多数 [markdown][] 格式，
并且 dartdoc 会更具 [markdown package][] 进行解析。
You are allowed to use most [markdown][] formatting in your doc comments and
dartdoc will process it accordingly using the [markdown package][].

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package]: https://pub.dartlang.org/packages/markdown


有很多指南已经向您介绍Markdown。 它普遍受欢迎是我们选择它的原因。 这里只是一个简单的例子，让您了解所支持的内容：

现在到处都有介绍 Markdown 的文档，
我们之所以选择它，是因为它受到了普遍的欢迎。
为了让你了解它所支持的内容，我们提供了一个简单的例子：
下面这个简单的例子可以让你了解他所支持的内容：

<?code-excerpt "misc/lib/effective_dart/docs_good.dart (markdown)"?>
{% prettify dart %}
/// This is a paragraph of regular text.
///
/// This sentence has *two* _emphasized_ words (italics) and **two**
/// __strong__ ones (bold).
///
/// A blank line creates a separate paragraph. It has some `inline code`
/// delimited using backticks.
///
/// * Unordered lists.
/// * Look like ASCII bullet lists.
/// * You can also use `-` or `+`.
///
/// 1. Numbered lists.
/// 2. Are, well, numbered.
/// 1. But the values don't matter.
///
///     * You can nest lists too.
///     * They must be indented at least 4 spaces.
///     * (Well, 5 including the space after `///`.)
///
/// Code blocks are fenced in triple backticks:
///
/// ```
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// The code language (for syntax highlighting) defaults to Dart. You can
/// specify it by putting the name of the language after the opening backticks:
///
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
///
/// Links can be:
///
/// * http://www.just-a-bare-url.com
/// * [with the URL inline](http://google.com)
/// * [or separated out][ref link]
///
/// [ref link]: http://google.com
///
/// # A Header
///
/// ## A subheader
///
/// ### A subsubheader
///
/// #### If you need this many levels of headers, you're doing it wrong
{% endprettify %}

### **避免** 过度使用 markdown。

如果有格式缺少的问题，格式化已有的内容来阐明你的想法，而不是替换它，
内容才是最重要的。

### **避免** 使用 HTML 来格式化文字。

例如表格，在极少数情况下它*可能*很有用。
但几乎所有的情况下，在 Markdown 中表格的表示都非常复杂。
这种情况下最好不要使用表格。

### **推荐** 使用反引号标注代码。

Markdown 有两种方式来标注一块代码：
每行代码缩进4个空格，或者在代码上下各标注三个反引号。
当缩进已经包含其他意义，或者代码段自身就包含缩进时，
在 Markdown 中使用前一种语法就显得很脆弱。

反引号语法避免了那些缩进的问题，
而且能够指出代码的语言类型，
内联代码同样可以使用反引号标注。

{:.good-style}
{% prettify dart %}
/// You can use [CodeBlockExample] like this:
///
/// ```
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Yes."
/// ```
{% endprettify %}

{:.bad-style}
{% prettify dart %}
/// You can use [CodeBlockExample] like this:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Yes."
{% endprettify %}

## 如何写注释

虽然我们认为我们是程序员，但是大部分情况下源代码中的内容都是为了让人类更易于阅读和理解代码。
对于任何编程语言，都值得努力练习来提高熟练程度。

This section lists a few guidelines for our docs. You can learn more about
best practices for technical writing, in general, from articles such as
[Technical writing style](https://en.wikiversity.org/wiki/Technical_writing_style).

### **推荐** 简洁.

要清晰和准确，并且简洁。

### **避免** 缩写和首字母缩写词，除非很常见。

很多人都不知道 "i.e."、 "e.g." 和 "et. al." 的意思。
你所在领域的首字母缩略词对于其他人可能并不了解。

### **推荐** 使用 "this" 而不是 "the" 来引用实例成员。

注释中提及到类的成员，通常是指被调用的对象实例的成员。
使用 "the" 可能会导致混淆。

{:.good-style}
<?code-excerpt "misc/lib/effective_dart/docs_good.dart (this)"?>
{% prettify dart %}
class Box {
  /// The value this wraps.
  var _value;

  /// True if this box contains a value.
  bool get hasValue => _value != null;
}
{% endprettify %}

