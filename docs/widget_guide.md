# Widget 指南 · Widget Guide

## Widget 树结构

```
TomatoApp (MaterialApp)
└── HomeScreen (Scaffold)
    └── SafeArea
        └── Consumer<PomodoroState>
            └── Column
                ├── _buildStatusBar()       → 顶部状态栏 (时间 + 信号格)
                ├── _buildAppBadge()        → "TOMATO" 标题徽章
                ├── PhaseTabBar             → 专注 / 短休 / 长休 Tab
                ├── TomatoRow               → 4个番茄进度图标
                ├── Text (计数)              → "1 / 4"
                ├── _buildPixelDivider()    → 像素分割线
                ├── _buildRingWithTime()    → Stack{ PixelRingTimer + 时间文字 }
                ├── _buildPixelDivider()
                ├── _buildControls()        → PixelButton (开始/暂停/废弃)
                ├── TaskList (Expanded)     → 任务列表
                └── _buildNavBar()          → 底部导航栏
```

---

## 各 Widget 详解

### PhaseTabBar
**文件位置**: `main.dart` line ~270  
**类型**: `StatelessWidget`

```dart
PhaseTabBar(
  current: state.phase,          // 当前选中的阶段
  onChanged: (p) => state.switchPhase(p),  // 切换时回调
)
```

- 接收外部传入的 `current` 和 `onChanged`，自己不管理状态
- 内部用 `Phase.values.map(...)` 遍历生成三个 Tab
- 用 `AnimatedContainer` 实现切换动画

---

### TomatoRow
**文件位置**: `main.dart` line ~325  
**类型**: `StatelessWidget`

```dart
TomatoRow(
  completed: state.completed,  // 0-4, 已完成几个番茄
  total: 4,                    // 总共显示几个 (默认4)
)
```

- 使用 `List.generate(total, ...)` 生成图标
- 每个图标是 `_PixelTomato` → `CustomPaint` → `_TomatoPainter`
- `filled: true/false` 控制是红色（已完成）还是灰色（未完成）

**`_TomatoPainter` 核心原理**:
使用 9×10 的像素网格，通过 `canvas.drawRect()` 逐个点绘制出番茄形状
```dart
void dot(int gx, int gy, Color c) {
  // 把格子坐标转换成屏幕像素坐标，画一个小方块
  canvas.drawRect(Rect.fromLTWH(gx*px, gy*px, px, px), Paint()..color = c);
}
```

---

### PixelRingTimer
**文件位置**: `main.dart` line ~420  
**类型**: `StatelessWidget`

```dart
PixelRingTimer(
  progress: state.progress,   // 0.0 到 1.0
  color: AppColors.accent,
  size: 190,
)
```

- `progress` 由 `PomodoroState` 计算: `1.0 - (timeLeft / totalDuration)`
- `_PixelRingPainter` 把圆分成 80 个点，用 `cos/sin` 计算每个点的位置
- 已完成的点用 `activeColor`，未完成的用 `trackColor`

---

### PixelButton
**文件位置**: `main.dart` line ~500  
**类型**: `StatefulWidget`

```dart
PixelButton(
  label: '▶  开始专注',
  onTap: state.start,
  fillColor: AppColors.accent,
  shadowColor: AppColors.accentD,
  width: 180,
)
```

- 用 `StatefulWidget` 因为需要记录 `_pressed` 状态（按下/弹起）
- 按下时用 `AnimatedPositioned` 把按钮向右下移动 3px，模拟像素按压效果
- 实际上是两层叠加的 `Container`：一个阴影层 + 一个前景层

---

### TaskList
**文件位置**: `main.dart` line ~590  
**类型**: `StatelessWidget`

```dart
TaskList(
  tasks: state.tasks,         // List<Task>，只读副本
  onToggle: state.toggleTask, // 传入方法引用
)
```

- 接收 `List<Task>` 和 `onToggle` 回调，本身无状态
- 每行是一个 `_TaskRow`，点击时调用 `onToggle(task.id)`
- 勾选框用 `Container + border` 手动绘制，不用系统 `Checkbox`

---

### HomeScreen
**文件位置**: `main.dart` line ~650  
**类型**: `StatelessWidget`

- 整个界面用 `Consumer<PomodoroState>` 包裹
- `Consumer` 监听 `PomodoroState`，每次 `notifyListeners()` 后重建
- 把复杂的 `build()` 拆成多个私有方法 (`_buildStatusBar`, `_buildControls` 等) 保持代码可读

---

## Widget vs StatefulWidget vs StatelessWidget

| | `StatelessWidget` | `StatefulWidget` |
|---|---|---|
| **有内部状态？** | 否 | 是 |
| **何时重建？** | 父级重建时 | 父级重建 OR `setState()` |
| **本项目例子** | `PhaseTabBar`, `TomatoRow`, `TaskList`, `HomeScreen` | `PixelButton` |

> `HomeScreen` 是 `StatelessWidget`，但它通过 `Consumer<PomodoroState>` 监听外部状态变化来重建，所以不需要自己管理状态。

---

## child vs children 速查

```dart
// child — 只接受一个 widget
Center(child: Text('hello'))
Padding(padding: EdgeInsets.all(8), child: Text('hello'))
Container(child: Column(...))

// children — 接受多个 widget 的 List
Column(children: [TimerDisplay(), StartButton()])
Row(children: [Icon(Icons.star), Text('hello')])
Stack(children: [Background(), Foreground()])
```
