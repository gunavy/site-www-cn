---
title: 为独立 Dart VM 提供原生扩展
description: 学习如何使 Dart 的命令行应用调用 C/C++ 函数。
date: 2012-05-01
category: dart-vm
---

{% comment %}
_Written by William Hesse <br>
May 2012_
{% endcomment %}

_作者：William Hesse <br>
2012年5月_


{% comment %}
Dart programs running on the standalone Dart VM (_command-line apps_) can call C
or C++ functions in a shared library, by means of native extensions. This
article shows how to write and build such native extensions on Windows,
macOS, and Linux.

You can provide two types of native extensions: asynchronous or synchronous. An
_asynchronous extension_ runs a native function on a separate thread, scheduled
by the Dart VM. A _synchronous extension_ uses the Dart virtual machine
library's C API (the Dart Embedding API) directly and runs on the same thread as
the Dart isolate. An asynchronous function is called by sending a message to a
Dart port, receiving the response on a reply port.
{% endcomment %}


在独立 Dart VM（命令行应用程序）上运行的 Dart 程序可以通过本地扩展调用共享库中的 C 或 C++ 函数。
本文将讲解如何在 Windows，macOS，以及 Linux 上编写和构建这样的本地扩展。

你可以提供两种类型的本地扩展：异步扩展或同步扩展。_异步扩展_在一个单独的线程中执行一个本地函数，由
Dart VM 调度。_同步扩展_直接使用 Dart 虚拟机库的 C API （ Dart 内嵌 API ） 并在 Dart 的独占
线程中执行。通过向 Dart 端口（ Dart port ）发送消息来调用异步函数，在应答端口（ reply port ）接受响应。


{% comment %}
## Anatomy of a native extension

A Dart native extension contains two files: a Dart library and a native library.
The Dart library defines classes and top-level functions as usual, but declares
that some of these functions are implemented in native code, using the
**native** keyword. The native library is a shared library, written in C or C++,
that contains the implementations of those functions.

The Dart library specifies the native library using an `import` statement
and the **dart-ext**: URI scheme. As of 1.20, the URI must either be an absolute
path like `dart-ext:/path/to/extension`, or only the name of the extension,
like `dart-ext:extension`. The VM modifies the URI to add platform
specific prefixes and suffixes to the extension name. For example,
`extension` becomes `libextension.so` on Linux. If the URI is an
absolute path, the import fails if the file does not exist. If the
URI is only the name of the extension, the VM first looks for the
file adjacent to the importing Dart library. If it is not found there
the VM passes the file name to the platform specific call for loading
dynamic libraries (e.g. `dlopen` on Linux), which is free to follow its
own search procedure.
{% endcomment %}


## 本地扩展解析

一个 Dart 本地扩展包含两部分： Dart 库和本地库。 Dart 库的类及顶层函数的定义方式不变，
但在这些函数中，使用本地代码中实现的函数需要使用 **native** 关键字声明。本地库是使用
C 或 C++ 编写的共享库，库中包含了这些函数（使用 **native** 关键字声明的函数）的实现。

Dart 库使用 `import` 语句和 **dart-ext**: URI 的方案指定本机库。截至 1.20 ，
URI 必须是绝对路径，如 `dart-ext:/path/to/extension` ，或者只使用扩展名，
如 `dart-ext:extension` 。 VM 修改 URI 将平台特定的前缀和后缀添加到扩展名。例如，在
Linux 上 `extension` 会变成 `libextension.so` 。如果 URI 是绝对路径，那么文件不存
在的情况下会导入失败。如果 URI 只是扩展的名称，那么 VM 会首先查找与导入 Dart 库相邻的文
件。如果没有找到，那么 VM 会将扩展的文件名传递给平台的特殊调用，以加载动态库
（例如，Linux 上的 `dlopen` ），此时该库的加载将遵循它所在平台的搜索过程。


{% comment %}
## Example code

The code for the sample extensions featured in this article is in the
[samples/sample_extension](https://github.com/dart-lang/sdk/tree/master/samples/sample_extension)
directory of the Dart repository.

The sample extensions call the C standard library's rand() and srand()
functions, returning pseudorandom numbers to a Dart program. Because the native
parts of the asynchronous and synchronous native extensions share most of their
code, a single native source file (and resulting shared library) implements both
extensions. The two extensions have separate Dart library files. Two additional
Dart files provide examples of using and testing the asynchronous and
synchronous extensions.

The shared library (native code) for the extensions shown in this article is
called sample_extension. Its C++ file,
[sample_extension.cc](https://github.com/dart-lang/sdk/blob/master/samples/sample_extension/sample_extension.cc), contains
six functions that are called from Dart:

sample_extension_Init():
: Called when the extension is loaded.

ResolveName():
: Called the first time a native function with a given name is called, to
resolve the Dart name of the native function into a C function pointer.

SystemRand() and SystemSrand():
: Implement the synchronous extension. These are native functions called
directly from Dart, and that call rand() and srand() from the C standard library.

wrappedRandomArray() and randomArrayServicePort():
: Implement the asynchronous extension. randomArrayServicePort() creates
a native port and associates it with wrappedRandomArray(). When Dart sends
a message to the native port, the Dart VM schedules wrappedRandomArray() to
run on a separate thread.

Some of the code in the shared library is setup and initialization code,
which can be the same for all extensions.  The functions sample_extension_Init()
and ResolveName() should be almost the same in all extensions, and a version of
randomArrayServicePort() must be in all asynchronous extensions.
{% endcomment %}


## 示例代码

文中介绍的扩展示例的代码位于 Dart 仓库的
[samples/sample_extension](https://github.com/dart-lang/sdk/tree/master/samples/sample_extension)
目录中。

扩展示例调用 C 标准库的 rand() 和 srand() 函数，将伪随机数返回到 Dart 程序。由于本地的异步扩展
和同步扩展共享了大部分本地代码，所以示例使用了单个本地源文件（以及生成单个共享库）实现了这两个扩展。
这两个扩展的 Dart 部分分别在两个库文件中实现。另外两个 Dart 文件提供了异步和同步扩展的使用和测试示例。

本文中扩展的共享库（本地代码）称为 sample_extension 。 它是一个 C++ 文件，
[sample_extension.cc](https://github.com/dart-lang/sdk/blob/master/samples/sample_extension/sample_extension.cc)，
其中包括 6 个被 Dart 调用的函数。

sample_extension_Init():
: 在扩展被加载时被调用。

ResolveName():
: 第一次调用给定名称的本地函数时，将本地函数的 Dart 名称解析为 C 函数指针。

SystemRand() and SystemSrand():
: 同步扩展的实现。这些本地方法由 Dart 直接调用，它们调用 C 标准库的 rand() 和 srand() 函数。

wrappedRandomArray() and randomArrayServicePort():
: 异步扩展的实现。 randomArrayServicePort() 函数创建一个本地端口，并将这个端口和
wrappedRandomArray() 函数关联在一起。当 Dart 向本地端口发送一个消息， Dart VM 就会调度
wrappedRandomArray() 函数在一个单独的线程中执行。

共享库中的一些代码用来设置和初始化，对于所有的扩展这些代码几乎是相同的。函数
sample_extension_Init() 和 ResolveName() 在所有的扩展中几乎相同，同样在所有的异步扩展中都
必须有一个类似于 randomArrayServicePort() 的函数。


{% comment %}
## The synchronous sample extension

Because the asynchronous extension works like a synchronous extension with some
added functions, we'll show the synchronous extension first. First we'll show
the Dart part of the extension and the sequence of function calls that happen
when the extension is loaded.  Then we explain how to use the Dart Embedding
API, show the native code, and show what happens when the extension is called.

Here is the Dart part of the synchronous extension, called
<b>sample_synchronous_extension.dart</b>:

{% prettify dart %}
library sample_synchronous_extension;

import 'dart-ext:sample_extension';

// The simplest way to call native code: top-level functions.
int systemRand() native "SystemRand";
bool systemSrand(int seed) native "SystemSrand";
{% endprettify %}

The code that implements a native extension executes at two different times.
First, it runs when the native extension is loaded. Later, it runs when a
function with a native implementation is called.

Here is the sequence of events at load time, when a Dart app that imports
sample_synchronous_extension.dart starts running:

1. The Dart library sample_synchronous_extension.dart is loaded, and the
  Dart VM hits the code <b><code>import 'dart-ext:sample_extension'</code></b>.
2. The VM loads the shared library 'sample_extension' from the directory
  containing the Dart library.
3. The function sample_extension_Init() in the shared library is called.
  It registers the shared library function ResolveName() as the name resolver
  for all native functions in the library sample_extension.dart. We'll see what
  the name resolver does when we look at synchronous native functions, below.

<aside class="alert alert-info">
<strong>Note:</strong>
The filename of the shared library depends on the platform. On Windows,
the VM loads sample_extension.dll, on Linux it loads libsample_extension.so,
and on Mac it loads libsample_extension.dylib. We show how to build and link
these shared libraries in an appendix at the end of the article.
</aside>
{% endcomment %}


## 示例中的同步扩展

因为异步扩展非常像是在同步扩展的基础上增加了一些函数，所以这里我们首先说明同步扩展。
首先，我们将展示扩展的 Dart 部分以及加载扩展时发生的函数调用序列。然后我们将解释如何使用 Dart 中嵌入的
API ，解释本地代码，以及描述扩展被调用时会发生了什么。

这是同步扩展的 Dart 部分，文件名
<b>sample_synchronous_extension.dart</b>：

{% prettify dart %}
library sample_synchronous_extension;

import 'dart-ext:sample_extension';

// The simplest way to call native code: top-level functions.
int systemRand() native "SystemRand";
bool systemSrand(int seed) native "SystemSrand";
{% endprettify %}

本地扩展的代码存在两个不同的执行时间。首先，它会在本地扩展加载的时候执行。后面，它会在
本地扩展实现被调用时执行。

下面是加载时的事件序列，当一个 Dart 应用导入 sample_synchronous_extension.dart 时开始执行：

1. Dart 库 sample_synchronous_extension.dart 被加载，Dart VM 处理
  <b><code>import 'dart-ext:sample_extension'</code></b> 代码。
2. Dart VM 从 Dart 库的目录中加载共享库 'sample_extension' 。
3. 共享库中的 sample_extension_Init() 函数被调用。它将共享库函数 ResolveName() 注册为
  sample_extension.dart 库中所有本地函数的名称解析器。通过解析器可以查找 Dart 中对应的同步
  扩展的本地函数。

<aside class="alert alert-info">
<strong>提示：</strong>
共享库的文件名取决于平台。
在 Windows 上，VM 加载 sample_extension.dll ，
在 Linux 上加载 libsample_extension.so ，
在 Mac 上加载 libsample_extension.dylib 。
我们将在本文末尾的附录中展示如何构建和链接这些共享库。
</aside>


{% comment %}
## Using the Dart Embedding API from native code

As the sample extensions show, the native shared library contains an
initialization function, a name resolution function, and the native
implementations of functions declared as native in the Dart part of the
extension. The initialization function registers the native name resolution
function as responsible for looking up native function names in this library.
When a function declared as **<code>native "<em>function_name</em>"</code>** in
the Dart library is called, the native library's name resolution function is
called with the string "<em>function_name</em>" as an argument, plus the number
of arguments in the function call. The name resolution function then returns a
function pointer to the native implementation of that function. The
initialization function and the name resolution function look pretty much the
same in all Dart native extensions.

The functions in the native library use the Dart Embedding API to communicate
with the VM, so the native code includes the header <b>dart_api.h</b>, which
is in the SDK at dart-sdk/include/dart_api.h or in the repository at
[runtime/include/dart_api.h](https://github.com/dart-lang/sdk/blob/master/runtime/include/dart_api.h).
The Dart Embedding API is the interface that embedders use to include the Dart
VM in a web browser or in the standalone VM for the command line. It consists
of about 100 function interfaces and many data type and data structure
definitions. These are all shown, with comments, in dart_api.h. Examples of
using them are in the unit test file
[runtime/vm/dart_api_impl_test.cc](https://github.com/dart-lang/sdk/blob/master/runtime/vm/dart_api_impl_test.cc).

A native function to be called from Dart must have the
type **Dart\_NativeFunction**, which is defined in dart_api.h as:

{% prettify cpp %}
typedef void (*Dart_NativeFunction)(Dart_NativeArguments arguments);
{% endprettify %}

So a Dart_NativeFunction is a pointer to a function taking a
Dart_NativeArguments object, and returning no value. The arguments object is a
Dart object accessed by API functions that return the number of arguments, and
return a Dart_Handle to the argument at a specified index. The native function
returns a Dart object to the Dart app, as the return value, by storing it in
the arguments object using the Dart_SetReturnValue() function.
{% endcomment %}


## 在本地代码中使用 Dart 内嵌 API

如扩展示例所示，本地共享库包含初始化函数，名称解析函数以及在扩展中由 Dart 部分声明并在本地实现的函数。
初始化函数注册本地名称解析函数，用作查找该库的本地函数名称。
当 Dart 库中以 **<code>native "<em>function_name</em>"</code>** 声明的函数被调用时，
本地库使用字符串 "<em>function_name</em>"，以及 "<em>function_name</em>" 函数的参数个数作为参数
调用名称解析函数。然后，名称解析函数会返回一个函数指针，这个函数指针指向对应 "<em>function_name</em>" 
函数的本地函数实现。所有 Dart 的原生扩展中的初始化函数以及名称解析函数看上去几乎是一样的。

本地库中的函数使用 Dart 内嵌 API 与 VM 进行通信，因此本地代码要包含 <b>dart_api.h</b> 头文件，
它位于 SDK 中的 dart-sdk/include/dart_api.h 或者在仓库
[runtime/include/dart_api.h](https://github.com/dart-lang/sdk/blob/master/runtime/include/dart_api.h)。
Dart 内嵌 API 作为接口内嵌在包含 Dart VM 的浏览器或者运行命令行程序的独立 VM 中。API 由大约
100 个函数接口和许多数据类型和数据结构定义组成。它们在 dart_api.h 中声明，并备有注释。它们的使用示例在单元测试文件
[runtime/vm/dart_api_impl_test.cc](https://github.com/dart-lang/sdk/blob/master/runtime/vm/dart_api_impl_test.cc)。

由 Dart 调用的本地函数必须是 **Dart\_NativeFunction** 类型，类型在 dart_api.h 中定义为：

{% prettify cpp %}
typedef void (*Dart_NativeFunction)(Dart_NativeArguments arguments);
{% endprettify %}

可以看到 Dart_NativeFunction 是一个函数指针，函数指针指向只接受一个 Dart_NativeArguments 
参数对象，且无返回值的函数。接受的参数对象是一个 Dart 对象，通过 API 访问该参数对象，可以得到
参数个数，以及指定索引的参数 Dart_Handle 。本地函数向 Dart 应用返回一个 Dart 对象作为返回值。
该返回值被 Dart_SetReturnValue() 函数保存到参数对象里。


{% comment %}
## Dart handles

The extension's native implementations of functions use Dart_Handles
extensively. Calls in the Dart Embedding API return a Dart_Handle and often take
Dart_Handles as arguments. A Dart_Handle is an opaque indirect pointer to an
object on the Dart heap, and Dart_Handles are copied by value. These handles
remain valid even when a garbage-collection phase moves Dart objects on the
heap, so native code must use handles to store references to heap objects.
Because these handles take resources to store and maintain, you must free them
when they're no longer used. Until a handle is freed, the VM's garbage collector
cannot collect the object it points to, even if there are no other references to
it.

The Dart Embedding API automatically creates a new scope to manage
the lifetime of handles in a native function.  A local handle
scope is created when the native function is entered, and is deleted when
the function is exited.  The scope is deleted if the function exits with
PropagateError, as well as if it returns normally. Most handles and memory
pointers returned by the Dart Embedding API are
allocated in the current local scope, and will be invalid after the function
returns. If the extension wants to keep a pointer to a Dart object for a long time,
it should use a _persistent handle_ (see Dart_NewPersistentHandle() and
Dart_NewWeakPersistentHandle()), which remains valid after a local scope ends.

Calls into the Dart Embedding API might return errors in their Dart_Handle
return values. These errors, which might be exceptions, should be passed up to
the caller of the function as the return value.

Most of the functions in a native extension&mdash;the functions of type
Dart_NativeFunction&mdash;have no return value and must pass the error up to the
proper handler in another way. They call Dart_PropagateError to pass errors and
control flow to where the error should be handled. The sample uses a helper
function, called HandleError(), to make this convenient.  A call to
Dart_PropagateError() never returns.
{% endcomment %}


## Dart handle

扩展的本地函数实现广泛的使用 Dart_Handles 。调用 Dart 内嵌 API 会返回一个 Dart_Handle 并且
常常将 Dart_Handle 作为函数参数。Dart_Handle 是一个间接不透明指针，指向一个在 Dart 堆上的对象，
Dart_Handles 属于值拷贝（浅拷贝）。在垃圾收集阶段会移动堆上的 Dart 对象，但即使是在垃圾收集阶段
这些句柄仍保持有效，因此本地代码必须使用句柄来存储堆上对象的引用。由于这些句柄的存储和持有需要占用
资源，所以必须要在不使用它们的时候对它们进行释放。在释放句柄之前，VM 的垃圾收集器无法收集它指向的对
象，即使这些对象已经不存在其他的引用。

Dart 内嵌 API 会自动创建一个作用域来管理本地函数中句柄的生命周期。本地函数进入时会创建本地句柄的
作用域，并在该函数退出时将作用域删除。如果函数正常返回，或以 PropagateError 退出，则作用域删除。
Dart 内嵌 API 返回的大多数句柄和内存指针都在当前本地作用域内分配，并在函数返回后失效。如果扩展应用
想要长时间保持指向 Dart 对象的指针，可以使用 _持久句柄_（参见 Dart_NewPersistentHandle() 和 
Dart_NewWeakPersistentHandle() ），这样可以使句柄在本地作用域结束后仍然有效。

调用 Dart 内嵌 API 可能会在 Dart_Handle 返回值中返回错误。这些错误或者是异常应该作为返回值传递
给函数的调用者。

本地扩展中的大多数函数&mdash;类型为 Dart_NativeFunction 的函数&mdash;没有返回值，必须以另一种
方式将错误传递给错误处理程序。函数中调用 Dart_PropagateError 来传递错误并控制程序流程到错误处理的
位置。该示例使用一个名为 HandleError() 的辅助函数使上述实现更加便捷。Dart_PropagateError() 函数
没有返回。 


{% comment %}
## The native code: sample_extension.cc

Now we'll show the native code for the sample extension, starting with the
initialization function, then the native function implementations, and ending
with the name resolution function. The two native functions implementing the
asynchronous extension are shown later.

{% prettify cpp %}
#include <string.h>
#include "dart_api.h"
// Forward declaration of ResolveName function.
Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool* auto_setup_scope);

// The name of the initialization function is the extension name followed
// by _Init.
DART_EXPORT Dart_Handle sample_extension_Init(Dart_Handle parent_library) {
  if (Dart_IsError(parent_library)) return parent_library;

  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code)) return result_code;

  return Dart_Null();
}

Dart_Handle HandleError(Dart_Handle handle) {
 if (Dart_IsError(handle)) Dart_PropagateError(handle);
 return handle;
}

// Native functions get their arguments in a Dart_NativeArguments structure
// and return their results with Dart_SetReturnValue.
void SystemRand(Dart_NativeArguments arguments) {
  Dart_Handle result = HandleError(Dart_NewInteger(rand()));
  Dart_SetReturnValue(arguments, result);
}

void SystemSrand(Dart_NativeArguments arguments) {
  bool success = false;
  Dart_Handle seed_object =
      HandleError(Dart_GetNativeArgument(arguments, 0));
  if (Dart_IsInteger(seed_object)) {
    bool fits;
    HandleError(Dart_IntegerFitsIntoInt64(seed_object, &fits));
    if (fits) {
      int64_t seed;
      HandleError(Dart_IntegerToInt64(seed_object, &seed));
      srand(static_cast<unsigned>(seed));
      success = true;
    }
  }
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(success)));
}

Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool* auto_setup_scope) {
  // If we fail, we return NULL, and Dart throws an exception.
  if (!Dart_IsString(name)) return NULL;
  Dart_NativeFunction result = NULL;
  const char* cname;
  HandleError(Dart_StringToCString(name, &cname));

  if (strcmp("SystemRand", cname) == 0) result = SystemRand;
  if (strcmp("SystemSrand", cname) == 0) result = SystemSrand;
  return result;
}
{% endprettify %}

Here is the sequence of events that happens at runtime, when the function
systemRand() (defined in sample_synchronous_extension.dart) is called for the
first time.

1. The function ResolveName() in the shared library is called with a Dart string containing "SystemRand" and the integer 0, representing the number of arguments in the call. The string “SystemRand” is the string literal following the <b>native</b> keyword in the declaration of systemRand().
2. ResolveName() returns a pointer to the native function SystemRand() in the shared library.
3. The arguments to the systemRand() call in Dart are packaged into a Dart_NativeArguments object, and SystemRand() is called with this object as its only argument.
4. SystemRand() does its computations, puts its return value into the Dart_NativeArguments object, and returns.
5. The Dart VM extracts the return value from the Dart_NativeArguments object, returning it as the result of the Dart call to systemRand().

On later calls to systemRand(), the result of the function lookup has been cached, so ResolveName() is not called again.
{% endcomment %}


## 本地代码：sample_extension.cc

这里我们将展示扩展示例的本地代码，从初始化函数开始，然后是本地函数实现，最后是称解析函数。
两个异步扩展的本地函数会在后面内容展示。

{% prettify cpp %}
#include <string.h>
#include "dart_api.h"
// 提前声明 ResolveName 函数。
Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool* auto_setup_scope);

// 以 _Init 扩展名结尾的初始化函数。
DART_EXPORT Dart_Handle sample_extension_Init(Dart_Handle parent_library) {
  if (Dart_IsError(parent_library)) return parent_library;

  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code)) return result_code;

  return Dart_Null();
}

Dart_Handle HandleError(Dart_Handle handle) {
 if (Dart_IsError(handle)) Dart_PropagateError(handle);
 return handle;
}

// 本地函数通过 Dart_NativeArguments 结构体获取函数参数，
// 并使用函数 Dart_SetReturnValue 返回执行结果。
void SystemRand(Dart_NativeArguments arguments) {
  Dart_Handle result = HandleError(Dart_NewInteger(rand()));
  Dart_SetReturnValue(arguments, result);
}

void SystemSrand(Dart_NativeArguments arguments) {
  bool success = false;
  Dart_Handle seed_object =
      HandleError(Dart_GetNativeArgument(arguments, 0));
  if (Dart_IsInteger(seed_object)) {
    bool fits;
    HandleError(Dart_IntegerFitsIntoInt64(seed_object, &fits));
    if (fits) {
      int64_t seed;
      HandleError(Dart_IntegerToInt64(seed_object, &seed));
      srand(static_cast<unsigned>(seed));
      success = true;
    }
  }
  Dart_SetReturnValue(arguments, HandleError(Dart_NewBoolean(success)));
}

Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool* auto_setup_scope) {
  // 如果执行失败，返回 NULL， Dart 会抛出异常。
  if (!Dart_IsString(name)) return NULL;
  Dart_NativeFunction result = NULL;
  const char* cname;
  HandleError(Dart_StringToCString(name, &cname));

  if (strcmp("SystemRand", cname) == 0) result = SystemRand;
  if (strcmp("SystemSrand", cname) == 0) result = SystemSrand;
  return result;
}
{% endprettify %}

以下是第一次调用函数 systemRand() 时在运行时产生的事件序列 （ systemRand() 定义在 sample_synchronous_extension.dart 中）。

1. 使用包含 "SystemRand" 的 Dart 字符串和整数 0 来调用共享库中的 ResolveName() 函数，这里整数表示调用中的参数数量。
“SystemRand” 是 systemRand（）声明中 <b>native</b> 关键字后面的字符串。
2. ResolveName() 返回共享库中本地函数 SystemRand() 的函数指针。
3. Dart 中 systemRand() 调用的参数被打包到 Dart_NativeArguments 对象中，并使用 Dart_NativeArguments 对象作为
参数调用 SystemRand() 函数，且该对象是 SystemRand() 的唯一参数。
4. SystemRand() 函数执行，将函数返回值存储到 Dart_NativeArguments 对象中，并返回。
5. Dart VM 从 Dart_NativeArguments 对象中提取返回值，并将其作为对 systemRand() 在 Dart 调用的返回结果。

后续再调用 systemRand() 时，函数查找的结果已经被缓存，因此不会再调用 ResolveName() 。


{% comment %}
## The asynchronous native extension

As we saw above, a synchronous extension uses the Dart Embedding API to work
with Dart heap objects, and it runs on the main Dart thread for the current
isolate. An asynchronous extension, on the other hand, does not use most of the
Dart Embedding API, and it runs on a separate thread so as not to block the main
Dart thread.

In many ways, asynchronous extensions are simpler to program than synchronous
extensions.  They use the native ports functions in the Dart Embedding API to
schedule C functions on independent threads. To Dart code that uses the
extension, it appears simply as a Dart SendPort.  The messages posted to this
port are automatically translated into a C structure called a Dart_CObject,
containing C data types such as int, double, and char*. This C structure is then
passed to a C function, which is run in an independent thread drawn from a pool
of threads managed by the VM. The C function can respond by a Dart_CObject to a
reply port. The Dart_CObject is translated back into a tree of Dart objects, and
appears as a reply on the Dart async call's reply port. This automatic
conversion of Dart objects into a Dart_CObject C structure replaces the use of
the Dart Embedding API to fetch fields from objects and to convert Dart objects
into C value types.

To create an asynchronous native extension, we do three things:

1. Wrap the C function we wish to call with a wrapper that converts the
  Dart_CObject input argument to the desired input parameters, converts the
  result of the function to a Dart_CObject, and posts it back to Dart.
2. Write a native function that creates a native port and attaches it to the
  wrapped function.  This native function is a synchronous native method, and
  it's in a native extension that looks just like the synchronous extension
  above. We have just added the wrapped function from step 1 to the extension,
  as well.
3. Write a Dart class that fetches the native port and caches it. In that class,
  provide a function that forwards its arguments to the native port as a
  message, and calls a callback argument when it receives a reply to that
  message.
{% endcomment %}


## 本地异步扩展

如上所述，同步扩展使用 Dart 内嵌 API 来处理 Dart 的堆对象，并且在当前隔离的主 Dart 线程上执行。
那么与之相反，异步扩展基本上不使用 Dart 内嵌 API ，并且它在独立的线程上执行，这样就不会阻塞主
Dart 线程。

在某些方面，异步扩展的编写比同步扩展更容易。异步扩展使用 Dart 内嵌 API 中的本地端口函数在独立线程
上调度 C 函数执行。对于异步扩展 Dart 端的代码仅仅暴露为 Dart SendPort （端口）。发送到端口的消
息会自动转换为名为 Dart_CObject 的 C 结构体，该结构体包含 C 数据类型，如 int， double，和 char* 。
然后将结构体传递给 C 函数，C 函数在一个独立的线程中执行，此线程由 VM 管理的线程池分配。C 函数可以
通过 Dart_CObject 响应应答端口。 Dart_CObject 被转换回 Dart 对象树，并在 Dart 异步调用的应答
端口上作为应答返回。与同步扩展相比较，异步扩展将 Dart 对象自动转换为 Dart_CObject C 结构取代了
同步扩展中使用 Dart 内嵌 API 从对象获取字段并将 Dart 对象转换为 C 值类型的过程。

要创建异步本地扩展，需要做三件事情：

1. 包装一个我们希望调用的 C 函数（包装器），在这个包装器中将 Dart_CObject 输入参数转换为期望
  的输入参数，将函数的结果转换为 Dart_CObject ，并将其发送回 Dart 。
2. 编写一个本地函数，创建一个本地端口并将其关联到包装器。这个本地函数是一个同步本地方法，在
  本地扩展中看起来像是上述的同步扩展函数。这样，我们就将刚刚在步骤 1 中的包装器添加到了扩展中。
3. 编写一个 Dart 类来获取本地端口并持有这个端口。在该类中，提供一个函数，将其参数作为消息转发
  到本地端口，并在收到消息回复时调用一个回调处理。


{% comment %}
### Wrapping the C function

Here is an example of a C function (actually, a C++ function, due to the use of
reinterpret_cast) that creates an array of random bytes,
given a seed and a length.  It returns the data in a newly allocated array,
which will be freed by the wrapper:

{% prettify cpp %}
uint8_t* random_array(int seed, int length) {
  if (length <= 0 || length > 10000000) return NULL;

  uint8_t* values = reinterpret_cast<uint8_t*>(malloc(length));
  if (NULL == values) return NULL;

  srand(seed);
  for (int i = 0; i < length; ++i) {
    values[i] = rand() % 256;
  }
  return values;
}
{% endprettify %}

To call this from Dart, we put it in a wrapper that unpacks the Dart_CObject
containing seed and length, and that packs the result values into a
Dart_CObject.  A Dart_CObject can hold an integer (of various sizes), a double,
a string, or an array of Dart_CObjects. It is implemented in
[dart_api.h](https://github.com/dart-lang/sdk/blob/master/runtime/include/dart_api.h)
as a struct
containing a union. Look in dart_api.h to see the fields and tags used to access
the union's members. After the Dart_CObject is posted, it and all its resources
can be freed, since they have been copied into Dart objects on the Dart heap.

{% prettify cpp %}
void wrappedRandomArray(Dart_Port dest_port_id,
                        Dart_Port reply_port_id,
                        Dart_CObject* message) {
  if (message->type == Dart_CObject::kArray &&
      2 == message->value.as_array.length) {
    // Use .as_array and .as_int32 to access the data in the Dart_CObject.
    Dart_CObject* param0 = message->value.as_array.values[0];
    Dart_CObject* param1 = message->value.as_array.values[1];
    if (param0->type == Dart_CObject::kInt32 &&
        param1->type == Dart_CObject::kInt32) {
      int length = param0->value.as_int32;
      int seed = param1->value.as_int32;

      uint8_t* values = randomArray(seed, length);

      if (values != NULL) {
        Dart_CObject result;
        result.type = Dart_CObject::kUint8Array;
        result.value.as_byte_array.values = values;
        result.value.as_byte_array.length = length;
        Dart_PostCObject(reply_port_id, &result);
        free(values);
        // It is OK that result is destroyed when function exits.
        // Dart_PostCObject has copied its data.
        return;
      }
    }
  }
  Dart_CObject result;
  result.type = Dart_CObject::kNull;
  Dart_PostCObject(reply_port_id, &result);
}
{% endprettify %}

Dart_PostCObject() is the only Dart Embedding API function that should be called
from the wrapper or the C function. Most of the API is illegal to call here,
because there is no current isolate. No errors or exceptions can be thrown, so
any error must be encoded in the reply message, to be decoded and thrown by the
Dart part of the extension.
{% endcomment %}


### 包装 C 函数
 
下面是一个 C 函数的例子（由于使用了 reinterpret_cast，它实际上是一个 C++ 函数），
函数在给定种子和长度的情况下创建了一个随机字节数组。返回的数据存储在一个新分配数组中，
该数组会在后续处理中释放：

{% prettify cpp %}
uint8_t* random_array(int seed, int length) {
  if (length <= 0 || length > 10000000) return NULL;

  uint8_t* values = reinterpret_cast<uint8_t*>(malloc(length));
  if (NULL == values) return NULL;

  srand(seed);
  for (int i = 0; i < length; ++i) {
    values[i] = rand() % 256;
  }
  return values;
}
{% endprettify %}

在从 Dart 调用这个 C 函数之前，我们将它放到了一个包装器中，这个包装器用于解包 Dart_CObject 中包含的
随机种子和要生成的随机数长度，以及包装返回结果到 Dart_CObject 中。 Dart_CObject 可以包含一个整数
（任意大小值），一个浮点数，一个字符串或者一个 Dart_CObject 数组。Dart_CObject 在
[dart_api.h](https://github.com/dart-lang/sdk/blob/master/runtime/include/dart_api.h) 中
实现，是一个包含 union 的结构体。查看 dart_api.h 来查找用于访问的 union 成员字段和标记。发送
Dart_CObject 之后，可以释放 Dart_CObject 及其所有资源，因为它们已经被复制到了 Dart 堆上的 Dart
对象中。

{% prettify cpp %}
void wrappedRandomArray(Dart_Port dest_port_id,
                        Dart_Port reply_port_id,
                        Dart_CObject* message) {
  if (message->type == Dart_CObject::kArray &&
      2 == message->value.as_array.length) {
    // 使用 .as_array 和 .as_int32 来访问 Dart_CObject 中的数据。
    Dart_CObject* param0 = message->value.as_array.values[0];
    Dart_CObject* param1 = message->value.as_array.values[1];
    if (param0->type == Dart_CObject::kInt32 &&
        param1->type == Dart_CObject::kInt32) {
      int length = param0->value.as_int32;
      int seed = param1->value.as_int32;

      uint8_t* values = randomArray(seed, length);

      if (values != NULL) {
        Dart_CObject result;
        result.type = Dart_CObject::kUint8Array;
        result.value.as_byte_array.values = values;
        result.value.as_byte_array.length = length;
        Dart_PostCObject(reply_port_id, &result);
        free(values);
        // 在函数退出时，结果是可以被释放的。
        // Dart_PostCObject 已经拷贝了这些数据。
        return;
      }
    }
  }
  Dart_CObject result;
  result.type = Dart_CObject::kNull;
  Dart_PostCObject(reply_port_id, &result);
}
{% endprettify %}

Dart_PostCObject() 是 Dart 内嵌 API 中唯一一个可以被包装器或 C 函数调用的函数。由于这的
包装器或 C 函数不再当前隔离作用域，所以多数 API 在这里调用是非法的。在这里不能抛出任何错误或
异常，因此任何错误必须被编码到在应答消息中，以便由扩展的 Dart 部分进行解码和抛出。


{% comment %}
### Setting up the native port

Now we set up the mechanism that calls this wrapped C function from Dart code,
by sending a message. We create a native port that calls this function, and
return a send port connected to that port. The Dart library gets the port from
this function, and forwards calls to the port.

{% prettify cpp %}
void randomArrayServicePort(Dart_NativeArguments arguments) {
  Dart_SetReturnValue(arguments, Dart_Null());
  Dart_Port service_port =
      Dart_NewNativePort("RandomArrayService", wrappedRandomArray, true);
  if (service_port != kIllegalPort) {
    Dart_Handle send_port = Dart_NewSendPort(service_port);
    Dart_SetReturnValue(arguments, send_port);
  }
}
{% endprettify %}
{% endcomment %}


### 设置本地端口

现在我们来设置从 Dart 代码发送消息到调用这个包装后的 C 函数的路径。我们创建一个调用此函数的
本地端口，并返回连接到这个端口的发送端口（ send port ）。 Dart 库从此函数获取端口，并对端口
发送调用。

{% prettify cpp %}
void randomArrayServicePort(Dart_NativeArguments arguments) {
  Dart_SetReturnValue(arguments, Dart_Null());
  Dart_Port service_port =
      Dart_NewNativePort("RandomArrayService", wrappedRandomArray, true);
  if (service_port != kIllegalPort) {
    Dart_Handle send_port = Dart_NewSendPort(service_port);
    Dart_SetReturnValue(arguments, send_port);
  }
}
{% endprettify %}


{% comment %}
### Calling the native port from Dart

On the Dart side, we need a class that stores this send port, sending messages
to it when a Dart asynchronous function with a callback is called. The Dart
class gets the port the first time the function is called, caching it in the
usual way. Here is the Dart library for the asynchronous extension:

{% prettify dart %}
library sample_asynchronous_extension;

import 'dart-ext:sample_extension';

// A class caches the native port used to call an asynchronous extension.
class RandomArray {
  static SendPort _port;

  void randomArray(int seed, int length, void callback(List result)) {
    var args = new List(2);
    args[0] = seed;
    args[1] = length;
    _servicePort.call(args).then((result) {
      if (result != null) {
        callback(result);
      } else {
        throw new Exception("Random array creation failed");
      }
    });
  }

  SendPort get _servicePort {
    if (_port == null) {
      _port = _newServicePort();
    }
    return _port;
  }

  SendPort _newServicePort() native "RandomArray_ServicePort";
}
{% endprettify %}
{% endcomment %}


### 在 Dart 端调用本地端口

在 Dart 端，为了向端口发送消息后，端口的 Dart 异步函数回调能够被调用，我们需要一个类来存储
这个发送端口。 通常，在Dart 类第一次调用函数获取端口时，将端口缓存。下面异步扩展的 Dart 库部分：

{% prettify dart %}
library sample_asynchronous_extension;

import 'dart-ext:sample_extension';

// 一个缓冲本地端口的类，用于调用异步扩展。
class RandomArray {
  static SendPort _port;

  void randomArray(int seed, int length, void callback(List result)) {
    var args = new List(2);
    args[0] = seed;
    args[1] = length;
    _servicePort.call(args).then((result) {
      if (result != null) {
        callback(result);
      } else {
        throw new Exception("Random array creation failed");
      }
    });
  }

  SendPort get _servicePort {
    if (_port == null) {
      _port = _newServicePort();
    }
    return _port;
  }

  SendPort _newServicePort() native "RandomArray_ServicePort";
}
{% endprettify %}


{% comment %}
## Conclusion and further resources

You've seen both synchronous and asynchronous native extensions. We hope that
you'll use these tools to provide access to existing C and C++ libraries,
thereby adding useful new capabilities to the standalone Dart VM.  We recommend
using asynchronous extensions rather than synchronous extensions, because
asynchronous extensions don't block the main Dart thread and can be simpler to
implement. The built-in Dart I/O libraries are built around asynchronous calls
to achieve high, non-blocking throughput. Extensions should have the same
performance goals.
{% endcomment %}


## 结论及更多资源

到这你已经了解了本地的同步扩展和异步扩展。我们希望你可以使用这些工具来访问现有的 C 和 C++ 库，
从而为独立的 Dart VM 添加新的有用的功能。因为异步扩展不会阻塞主 Dart 线程，而且实现更加简单，
所以我们更建议使用异步而不是使用同步来实现扩展。内置的 Dart I/O 库就是围绕着异步调用构建的，
从而实现了高效的，无阻塞的吞吐。扩展也应当拥有与 Dart I/O 同样的性能目标。


{% comment %}
## Appendix: Compiling and linking extensions

Building a shared library can be tricky, and the tools to do it are platform
dependent. Building Dart native extensions is especially tricky because they are
dynamically loaded, and they link to Dart Embedding API functions in the Dart
library embedded in the executable that dynamically loads them.

As with all shared libraries, the compilation step must generate position-
independent code. The linker step must specify that unresolved functions will be
resolved in the executable when the library is loaded. We will show commands
that do this on the Linux, Windows, and Mac platforms. If you download the dart
source repository, the sample code also includes a platform-independent build
system, called gyp, and a build file sample_extension.gypi that builds the
sample extension.
{% endcomment %}


## 附录：扩展的编译和链接

共享库的构建会比较棘手，而且构建共享库的工具决于平台。 Dart 本地扩展构建会更加棘手，因为本地扩展
是动态加载的，并且工具要链接 Dart 库包含的 Dart 内嵌 API 函数到动态加载的可以执行文件中。

与所有共享库一样，编译步骤必须生成与位置无关的代码。链接步骤中必须指定在加载库时允许在可执行文件中
存在未实现的函数。我们将在 Linux， Windows 和 Mac 平台上说明这些操作命令。如果你下载了 Dart 的
源码仓库，示例代码还包括一个独立于平台的构建系统（被称为 gyp ）以及一个用于构建扩展示例的构建文件
sample_extension.gypi 。


### Building on Linux

On Linux, you can compile the code in the samples/sample_extension directory like this:

{% prettify none %}
g++ -fPIC -m32 -I{path to SDK include directory} -DDART_SHARED_LIB -c sample_extension.cc
{% endprettify %}

To create the shared library from the object file:

{% prettify none %}
gcc -shared -m32 -Wl,-soname,libsample_extension.so -o
libsample_extension.so sample_extension.o
{% endprettify %}

Remove the -m32 to build a 64-bit library that runs with the 64-bit Dart standalone VM.

### Building on Mac

1. Using Xcode (tested with Xcode 3.2.6), create a new project with the same name as the native extension, of type Framework & Library/BSD C Library, type dynamic.
2. Add the source files of your extension to the source section of the project.
3. Make the following changes in Project/Edit Project Settings, choosing the Build tab and All Configurations in the dialog box:
   1. In section Linking, line Other Linker Flags, add -undefined dynamic_lookup.
   2. In section Search Paths, line Header Search Paths, add the path to dart_api.h in the SDK download or the Dart repository checkout.
   3. In section Preprocessing, line Preprocessor Macros, add DART_SHARED_LIB=1
4. Choose the correct architecture (i386 or x86_64), and build by choosing Build/Build.

The resulting lib[extension_name].dylib will be in the <b>build/</b> subdirectory of your project location, so copy it to the desired location (probably the location of the Dart library part of the extension).

### Building on Windows

The Windows DLL compilation is complicated by the fact that we need to link with
library file, dart.lib, that does not contain code itself, but specifies that
calls to the Dart Embedding API will be resolved by linking to the Dart
executable, dart.exe, when the DLL is dynamically loaded. This library file is
generated when building dart and is included in the Dart SDK.

1. Create a new project of type Win32/Win32 project in Visual Studio 2008 or 2010. Give the project the same name as the native extension. On the next screen of the wizard, change the application type to DLL and select "Empty project", then choose finish.
2. Add the C/C++ files for the native extension to the source files folder in the project.  Make sure to include the [extension name]_dllmain_win.cc file.
3. Change the following settings in the project's properties:
   1. Configuration properties / Linker / Input / Additional dependencies: Add dart-sdk\bin\dart.lib, from the downloaded Dart SDK.
   2. Configuration properties / C/C++ / General / Additional Include Directories: Add the path to the directory containing dart_api.h, which is dart-sdk/include in the downloaded Dart SDK.
   3. Configuration properties / C/C++ / Preprocessor / Preprocessor Definitions: Add DART_SHARED_LIB. This is just to export the <extension name>_init function from the DLL, since it has been declared as DART_EXPORT.
4. Build the project, and copy the DLL to the correct directory, relative to the Dart library part of the extension.  Make sure to build a 32-bit DLL for use with the 32-bit SDK download, and a 64-bit DLL for use with the 64-bit download.
