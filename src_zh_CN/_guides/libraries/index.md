---
layout: default
title: "概述: 库"
description: "Learn about Dart's core libraries and APIs."
permalink: /guides/libraries
short-title: "Libraries"
toc: false
---

Dart 程序依赖于 _库_.
这里为您提供了几个常用的库。
例如，`dart：core` 提供了一组小而重要的内置功能，
例如数字，集合和字符串处理。 另一个重要的库
`dart：async`，它支持进行异步编程的类
像 Future 和 Stream 。
您可以通过 _packages_ 来导入获取其他库。

通过下面链接，了解更多关于使用，创建和分享Dart库和 packages 的信息。


<div class="card-grid">
  <div class="card">
    <h3><a href="/guides/libraries/library-tour">Dart 库之旅</a></h3>
    <p>介绍 Dart 核心库的主要功能。</p>
  </div>

  <div class="card">
    <h3><a href="/guides/libraries/useful-libraries">常用的库</a></h3>
    <p>您应该了解的常用库。</p>
  </div>

  <div class="card">
    <h3><a href="/guides/libraries/create-library-packages">创建 Packages</a></h3>
    <p>如何创建自己的库。</p>
  </div>
</div>

## 其他资源

API参考
: * [api.dartlang.org:]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}})
    dart:* 库的 API 文档
  * [docs.flutter.io:](http://docs.flutter.io/)
    Flutter 库的 API 文档
  * [dartdocs.org:](https://www.dartdocs.org/)
    pub.dartlang.org 上发布的 packages 的 API 文档

[异步编程中的错误处理](/guides/libraries/futures-error-handling)
: 如何在编写异步代码时处理错误。

[安装分享 packages](/tutorials/libraries/shared-pkgs)
: 初学者指南，用于在代码中安装 packages 和使用他人的库。

[不应该提交的内容](/guides/libraries/private-files)
: 您开发工具生成的文件不应提交到代码仓库。

[pub](/tools/pub)
: 用于管理Dart包的工具。

[pub.dartlang.org](https://pub.dartlang.org/)
: 由 Dart 社区提供的 packages 。

[关于库的文章](/articles/libraries)
: API topics ranging from zones to streams to converters.
