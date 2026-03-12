# Widget 指南 · Widget Guide

## Widget 树结构

```
TomatoApp (MaterialApp)
└── HomeScreen (Scaffold)
    └── SafeArea
        ├── Column
        │   ├── Expanded
        │   │   └── IndexedStack
        │   │       ├── TimerView (计时页面)
        │   │       │   └── Consumer<PomodoroState>
        │   │       │       └── Column
        │   │       │           ├── PhaseTabBar             → 专注 / 短休 / 长休 Tab
        │   │       │           ├── TomatoRow               → 4个番茄进度图标
        │   │       │           ├── Text (计数)              → "1 / 4"
        │   │       │           ├── _buildPixelDivider()    → 像素分割线
        │   │       │           ├── _buildRingWithTime()    → Stack{ PixelRingTimer + 时间文字 }
        │   │       │           ├── _buildPixelDivider()
        │   │       │           ├── _buildControls()        → PixelButton (开始/暂停/废弃)
        │   │       │           └── TaskList (Expanded)     → 任务列表
        │   │       ├── StatisticsPage (统计页面)            → 图表、数据展示
        │   │       └── SettingsPage (设置页面)              → 参数配置
        │   └── _buildNavBar()          → 底部导航栏
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
**类型**: `StatefulWidget`

```dart
TaskList(
  tasks: state.tasks,         // List<Task>，只读副本
  onToggle: state.toggleTask, // 切换任务完成状态
  onDelete: state.deleteTask, // 删除任务
  onAdd: state.addTask,       // 添加新任务
)
```

- 有内部状态 `_isAdding` 控制添加任务输入框的显示
- 支持任务增删改功能，左滑删除任务
- 每行是一个 `_TaskRow`，点击时调用 `onToggle(task.id)`
- 勾选框用 `Container + border` 手动绘制，不用系统 `Checkbox`

### PixelTomato
**文件位置**: `lib/widgets/pixel_tomato.dart`  
**类型**: `StatelessWidget`

```dart
PixelTomato(
  filled: true,  // 是否为填充状态（已完成的番茄）
  size: 24,      // 图标尺寸
)
```

- 独立的像素番茄图标组件，可在多个页面复用
- 使用 9×10 像素网格，通过 `CustomPainter` 逐点绘制
- 支持填充（红色）和空心（灰色）两种状态
- 包含叶子、高光、阴影等像素细节

### StatisticsPage
**文件位置**: `lib/widgets/statistics_page.dart`  
**类型**: `StatelessWidget`

- 统计页面，展示专注数据可视化
- 包含统计卡片（完成数、总时长、专注次数）
- 本周趋势柱状图（使用 `fl_chart` 库）
- 今日番茄完成进度
- 时间段分布展示
- 详细统计数据列表

### SettingsPage
**文件位置**: `lib/widgets/settings_page.dart`  
**类型**: `StatelessWidget`

- 设置页面，提供应用参数配置
- 计时时长设置（专注/短休/长休）
- 休息提醒设置
- 通知开关（声音、震动）
- 其他功能开关（自动开始、任务锁定等）
- 主题颜色选择
- 版本信息展示

---

### HomeScreen
**文件位置**: `main.dart` line ~650  
**类型**: `StatefulWidget`

- 主页面容器，管理底部导航和页面切换
- 使用 `IndexedStack` 实现页面状态保持
- 包含三个子页面：TimerView、StatisticsPage、SettingsPage
- 内部状态 `_selectedIndex` 控制当前显示的页面

### TimerView
**文件位置**: `main.dart` line ~720  
**类型**: `StatelessWidget`

- 计时页面内容，用 `Consumer<PomodoroState>` 包裹
- `Consumer` 监听 `PomodoroState`，每次 `notifyListeners()` 后重建
- 把复杂的 `build()` 拆成多个私有方法 (`_buildPixelDivider`, `_buildRingWithTime`, `_buildControls` 等) 保持代码可读

---

## Widget vs StatefulWidget vs StatelessWidget

| | `StatelessWidget` | `StatefulWidget` |
|---|---|---|
| **有内部状态？** | 否 | 是 |
| **何时重建？** | 父级重建时 | 父级重建 OR `setState()` |
| **本项目例子** | `PhaseTabBar`, `TomatoRow`, `PixelTomato`, `PixelRingTimer`, `StatisticsPage`, `SettingsPage`, `TimerView` | `PixelButton`, `TaskList`, `HomeScreen` |

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
