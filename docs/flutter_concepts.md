# Flutter 核心概念 · Flutter Concepts Used in This Project

## 1. Widget 是什么？

Flutter 中**一切都是 Widget**。Widget 描述 UI 应该长什么样，不是真正的 DOM 或 View，更像是一份"配置说明"。

```
你的 Widget 代码
      ↓
Flutter 引擎读取配置
      ↓
渲染到屏幕上的像素
```

每次 `setState()` 或 `notifyListeners()`，Flutter 重新读取 Widget 配置，找出差异，只更新变化的部分（这叫 **diffing**）。

---

## 2. StatelessWidget vs StatefulWidget

### StatelessWidget
- 没有内部可变状态
- 构建结果完全由 **外部传入的参数** 决定
- 用于纯展示类 Widget

```dart
class TomatoRow extends StatelessWidget {
  final int completed;  // 外部传入，不能在内部改
  const TomatoRow({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Row(...); // 每次都根据 completed 重新构建
  }
}
```

### StatefulWidget
- 有内部可变状态（`_pressed`、`_count` 等）
- 调用 `setState()` 触发重建

```dart
class PixelButton extends StatefulWidget { ... }

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;  // 内部状态

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true), // 触发重建
      ...
    );
  }
}
```

---

## 3. BuildContext

`BuildContext` 代表 Widget 在 Widget 树中的位置。  
通过它可以"向上查找"父级提供的数据：

```dart
// 找到 ChangeNotifierProvider 提供的 PomodoroState
final state = context.read<PomodoroState>();
```

> 规则：只能在 `build()` 方法或 Widget 生命周期方法中使用 `context`

---

## 4. CustomPainter — 自定义绘制

当标准 Widget 无法满足需求（如像素风格图形），用 `CustomPainter` 直接操作画布：

```dart
class _TomatoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // canvas 是画布，Size 是分配给这个 Widget 的尺寸
    canvas.drawRect(rect, paint); // 画矩形
    canvas.drawCircle(offset, radius, paint); // 画圆
  }

  @override
  bool shouldRepaint(_TomatoPainter old) => old.filled != filled;
  // 告诉 Flutter 什么时候需要重画（减少不必要绘制）
}
```

**本项目使用 CustomPainter 的 Widget**:
- `_TomatoPainter` - 9×10 像素网格绘制番茄
- `_PixelRingPainter` - 80个方点绘制环形进度条

---

## 5. Provider 包

`provider` 是 Flutter 官方推荐的轻量状态管理方案。

```
pubspec.yaml:
  dependencies:
    provider: ^6.1.2
```

核心三步：
```dart
// 1. 提供 (在树的顶层)
ChangeNotifierProvider(create: (_) => PomodoroState(), child: app)

// 2. 访问 (在子 Widget 里读取，不监听)
context.read<PomodoroState>().start()

// 3. 监听 (数据变化时重建)
Consumer<PomodoroState>(builder: (ctx, state, _) => Text(state.timeString))
```

## 6. fl_chart 包

`fl_chart` 是 Flutter 常用的图表绘制库，用于统计页面的柱状图展示。

```
pubspec.yaml:
  dependencies:
    fl_chart: ^1.1.1
```

本项目中用于实现：
- 本周番茄完成趋势柱状图
- 支持自定义颜色、样式、坐标轴标签
- 内置交互动画和触摸反馈

---

## 7. dart:async — Timer

Flutter 用 Dart 的 `Timer` 实现定期任务：

```dart
import 'dart:async';

// 每秒执行一次 _tick
Timer.periodic(const Duration(seconds: 1), _tick);

// 取消计时
_timer?.cancel();
```

`?.` 是"空安全调用"：如果 `_timer` 是 `null` 就不调用，不会报错。

---

## 8. enum (枚举)

枚举用于表示一组固定选项：

```dart
enum Phase {
  focus,
  shortBreak,
  longBreak;

  // 给每个枚举值加方法
  String get label {
    switch (this) {
      case Phase.focus:      return '专注';
      case Phase.shortBreak: return '短休';
      case Phase.longBreak:  return '长休';
    }
  }

  int get durationSeconds {
    switch (this) {
      case Phase.focus:      return 25 * 60;
      case Phase.shortBreak: return 5 * 60;
      case Phase.longBreak:  return 15 * 60;
    }
  }
}
```

用法：`Phase.focus.durationSeconds` → `1500`

---

## 9. 常用布局 Widget 速查

```dart
// 垂直排列
Column(
  mainAxisAlignment: MainAxisAlignment.center,  // 垂直方向对齐
  crossAxisAlignment: CrossAxisAlignment.center, // 水平方向对齐
  children: [...],
)

// 水平排列
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [...],
)

// 重叠
Stack(
  alignment: Alignment.center,
  children: [
    PixelRingTimer(...),  // 底层
    Text('25:00'),        // 叠在上面
  ],
)

// 填充剩余空间
Expanded(child: TaskList(...))

// 固定大小 / 间距
SizedBox(height: 20)
SizedBox(width: 100, height: 50, child: ...)

// 内边距
Padding(padding: EdgeInsets.all(16), child: ...)
Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: ...)

// 外边距 + 背景色 + 边框
Container(
  margin: EdgeInsets.all(8),
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  child: ...,
)
```

---

## 10. Hot Reload vs Hot Restart

| | Hot Reload (`r`) | Hot Restart (`R`) |
|---|---|---|
| **速度** | 快 (~100ms) | 慢 (~2s) |
| **保留状态** | ✅ 是 | ❌ 否 |
| **适用情况** | 修改 UI、样式、布局 | 修改 `main()`、`initState()`、全局变量 |
| **局限** | 不能更新 `const`、不能修复某些结构性错误 | 完整重启，什么都能修 |

> 如果 Hot Reload 后看不到变化，试试 Hot Restart。

---

## 11. SafeArea

```dart
SafeArea(child: Column(...))
```

自动在内容周围加上安全边距，避免被 iPhone 刘海、底部 Home Bar 遮挡。  
几乎所有屏幕最外层都应该加。
