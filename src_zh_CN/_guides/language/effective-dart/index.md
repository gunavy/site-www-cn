---
title: Effective Dart
description: Best practices for building consistent, maintainable, efficient Dart libraries.
permalink: /guides/language/effective-dart
toc: true
nextpage:
  url: /guides/language/effective-dart/style
  title: 风格
---

{% include effective-dart-banner.html %}

在过去的几年里，我们编写了大量的 Dart 代码，
也从中收获了很多经验和教训，
我们将与你分享这些经验，这些经验将有助于你编写出一致、健壮、高效的代码。
这里包含两主题：

 1. **保持一致** 当谈论到格式、命名、参数相关规则时，其中那种规则更好，
    得出的结论通常是主观的，而且无法达成一致。
    但是我们知道，客观上保持*一致*是非常有益的。

    如果两段代码看起来不同，那他们就应该有不同的含义。
    当一段突出的代码吸引到你的注意时，那他就应该有吸引你的理由。

 2. **保持精简** 
    Dart 会让开发者感到很亲切，
    因此它继承了许多与 C，Java，JavaScript 及其他语言相同的语句和表达式。
    我们之所以开发 Dart 语言，是因为这些语言提供了很多改进的空间。
    我们提供了很多新的特性，
    比如字符串插值、初始化范式等，
    以帮助你更简单，更轻松地表达意图。

    如果有多种方式来描述一件事情，
    那么你通常应该选择其中最简洁的方式。
    这并不意味着你要像 [code golf][] （代码高尔夫挑战赛）一样，将所有代码塞到一行中。
    目标是让代码*简约*，而不是*密集*。

[code golf]: https://en.wikipedia.org/wiki/Code_golf

## 指南

我们将指南分成几个单独的页面以便于消化：：

  * **[风格指南][]** &ndash; 这定义了布局和组织代码的规则，
    [dartfmt] 的实现使用同样的规则。指南中还指定了标识符的格式：
    `camelCase`，`using_underscores` 等。

  * **[文档注释指南][]** &ndash; 这会告诉你关于如何编写注释文档的一切内容。
    包括文档注释，常规的普通代码注释。

  * **[使用指南][]** &ndash; 这将教你如何充分利用语言功能来实现功能。
    例如语句和表达式相关的内容，则会在这里介绍。

  * **[设计指南][]** &ndash; 这是一份宽松的指南，但是覆盖范围最广。
    这里涵盖了如何为库设计一致的、可用的 API。例如类型签名或声明相关内容，
    则会在这里介绍。


有关所有指南的链接，参考
[summary](#summary-of-all-rules)。

{% comment %}
<aside class="alert alert-info" markdown="1">
  **Have feedback on the guides?** <br>
  Please create a [new issue][] or comment on one of our [existing issues][].

  [new issue]: {{site.repo}}/issues/new
  [existing issues]: {{site.repo}}/issues?q=is%3Aopen+is%3Aissue+label%3AEffectiveDart
</aside>
{% endcomment %}

[dartfmt]: https://github.com/dart-lang/dart_style#readme
[风格指南]: /guides/language/effective-dart/style
[文档注释指南]: /guides/language/effective-dart/documentation
[使用指南]: /guides/language/effective-dart/usage
[设计指南]: /guides/language/effective-dart/design

## 如何阅读本指南

每个指南都分为了几个部分。每个部分包含一些详细的准则。
每条准则都以下面其中的一个词作为开头：

* **要**  准则所描述的内容应该始终被遵守。 
  不应该以任何的理由来偏离违背这些准则。

* **不要**  准则所描述的内容是相反的：
  描述的几乎从来不是一个好注意。
  幸运的是，我们不会像其他语言有那么多这样的准则，因为我们没有太多的历史包袱。

* **推荐** 准则所描述的内容*应该*被遵守。 
  但是在有些情况下，可能有更好的或者更合理的做法。
  请确保在你完全理解准则的情况下，再忽视这些准则。

* **避免** 准则与 "推荐" 准则相反：
  显然，这些事不应该做，但不排除在极少数场合下有充分的理由可以使用。

* **考虑**  准则所描述的内容可以遵守，也可以不遵守。
  取决于具体的情况、先前的做法以及自己的偏好。

这听起来好像有点小题大做。其实并没有那么糟糕。大部分的准则都是常识，也符合我们的认知。
最终要达到的目标是写出优雅，可读，可维护的代码。

## 词汇表

为了使指南保持简洁，
我们使用一些简写术语来指代不同的 Dart 结构。

* **库成员** 是一个顶级字段，getter 方法，setter 方法，或者函数，
  基本上，任何顶级的东西都不会是一种类型。

* **类成员** 是一个类内部声明的构造函数，字段，getter 方法，setter 方法，函数，或者操作符。
  类成员可以是实例的或者静态的，抽象的或者具体的。

* **成员** 是一个库成员或者是类成员。

* **变量** 通常是指顶级变量，参数和局部变量。
  它不包括静态或实例的字段。

* **类型** 是任意命名类型的声明：一个类、 typedef、或者 enum。

* **属性** 是一个顶级变量，getter 方法（在一个类或者顶级实例或静态类中），
  setter（同getter），或者字段（示例或静态类）。
  大致上任何“字段式”命名构造。

## 所有准则摘要

{% include_relative toc.md %}
