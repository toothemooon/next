# 状态管理 · State Management

## 为什么需要状态管理？

Flutter UI 是"状态的函数"：`UI = f(state)`  
每当数据变化，Flutter 重建对应的 Widget。  
问题是：计时器状态需要被 **多个 widget 共享**，不能只放在某一个 widget 里。

---

## Provider 模式（本项目使用）

### 核心概念

```
ChangeNotifier  ←  被观察的数据类
      ↑
ChangeNotifierProvider  ←  把数据注入 Widget 树
      ↑
Consumer / context.watch()  ←  在 Widget 里读取并监听数据
```

### 注入 (main.dart 入口)

```dart
void main() {
  runApp(
    ChangeNotifierProvider(           // 1. 在树的最顶层提供状态
      create: (_) => PomodoroState(), // 2. 创建 PomodoroState 实例
      child: const TomatoApp(),
    ),
  );
}
```

`ChangeNotifierProvider` 会把 `PomodoroState` 放入整个 Widget 树，  
任何子 Widget 都可以通过 `Consumer` 或 `context.read()` 访问它。

### 读取并监听 (HomeScreen)

```dart
Consumer<PomodoroState>(
  builder: (context, state, _) {
    // 每次 state.notifyListeners() 被调用，这里就重建
    return Column(
      children: [
        Text(state.timeString),  // 自动更新
        TomatoRow(completed: state.completed),
        ...
      ],
    );
  },
)
```

### 触发更新 (PomodoroState)

```dart
class PomodoroState extends ChangeNotifier {
  int _timeLeft = 25 * 60;

  void _tick(Timer t) {
    _timeLeft--;
    notifyListeners(); // ← 通知所有 Consumer 重建
  }
}
```

---

## PomodoroState 详细解析

### 字段（Fields）

```dart
static const int totalTomatoes = 4;  // 每轮番茄总数
Phase _phase      = Phase.focus;    // 当前阶段
int _timeLeft     = 25 * 60;       // 剩余秒数
bool _isRunning   = false;         // 是否运行中
int _completed    = 0;             // 累计完成番茄数
bool _justDone    = false;         // 刚完成一个番茄（触发庆祝动画）
List<Task> _tasks = [...];        // 任务列表
Timer? _timer;                    // dart:async 计时器
```

> 字段名以 `_` 开头 = **私有**，外部不能直接修改，只能通过公开方法改

### Getter（计算属性）

```dart
// 进度 0.0 ~ 1.0，供 PixelRingTimer 使用
double get progress => 1.0 - (_timeLeft / _phase.durationSeconds);

// "25:00" 格式的时间字符串
String get timeString {
  final m = (_timeLeft ~/ 60).toString().padLeft(2, '0');
  final s = (_timeLeft % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

// completed 对 4 取余，用于显示当前轮进度
int get completed => _completed % totalTomatoes;

// 累计完成的番茄总数
int get totalCompleted=> _completed;

// 任务列表的只读副本
List<Task> get tasks  => List.unmodifiable(_tasks);
```

### 方法（Methods）

| 方法 | 触发条件 | 作用 |
|------|---------|------|
| `start()` | 点击"开始专注" | 启动 Timer.periodic |
| `pause()` | 点击"暂停" | 取消 Timer |
| `abandon()` | 点击"打断/废弃" | 取消 Timer + 重置时间 |
| `switchPhase(p)` | 点击 Tab | 切换阶段 + 重置时间 |
| `toggleTask(id)` | 点击任务行 | 切换任务完成状态 |
| `addTask(text)` | 点击"添加任务" | 添加新任务 |
| `deleteTask(id)` | 左滑删除任务 | 删除指定任务 |
| `_tick(t)` | 每秒自动调用 | 倒计时 -1秒，完成检测 |
| `_sortTasks()` | 内部调用 | 任务排序（未完成在前，已完成在后） |

### 计时完成逻辑

```dart
void _tick(Timer t) {
  if (_timeLeft <= 1) {
    _timer?.cancel();
    _isRunning = false;
    _timeLeft = 0;
    if (_phase == Phase.focus) {  // 只有专注阶段才计番茄
      _completed++;
      _justDone = true;           // 触发完成状态
    }
    notifyListeners();
    return;
  }
  _timeLeft--;
  notifyListeners();
}
```

---

## context.read() vs Consumer 的区别

```dart
// Consumer — 监听变化，数据更新时重建 Widget
Consumer<PomodoroState>(
  builder: (context, state, _) => Text(state.timeString),
)

// context.read() — 只读一次，不监听变化（适合在 onTap 里用）
onTap: () => context.read<PomodoroState>().start(),
```

本项目的 `HomeScreen` 用 `Consumer` 包裹整个 `Column`，  
按钮的 `onTap` 直接传方法引用 `state.start`（因为按钮在 `Consumer` 的 `builder` 里，可以直接访问 `state`）。

---

## dispose() 清理

```dart
@override
void dispose() {
  _timer?.cancel(); // ← 必须取消 Timer，否则内存泄漏
  super.dispose();
}
```

`ChangeNotifier` 被销毁时调用 `dispose()`，在这里清理 `Timer`。

## 多页面状态共享

由于 `ChangeNotifierProvider` 在应用根节点注入，所有页面都可以访问和修改 `PomodoroState`：

- **TimerView** - 读取计时状态、控制计时器、管理任务
- **StatisticsPage** - 读取统计数据（完成数、总时长等）
- **SettingsPage** - 修改配置参数（未来实现）

这种设计保证了状态在整个应用中的一致性，任何页面修改状态后，其他页面都会自动更新。
