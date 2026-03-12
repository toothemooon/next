# 项目架构 · Project Architecture

## 项目简介
**Pixel Zen Pomodoro** 是一个像素风格的番茄钟应用，使用 Flutter + Material 风格构建，核心功能包括：
- 专注 / 短休 / 长休三种计时模式
- 像素风格环形进度条和番茄图标
- 任务列表（今日任务）
- Provider 状态管理

---

## 当前文件结构（已实现模块化）

项目已从单文件 MVP 版本重构为模块化结构：

```
lib/
├── main.dart                  # 入口：runApp + ChangeNotifierProvider + 核心逻辑
├── constants.dart             # 全局常量：颜色、文字样式
└── widgets/
    ├── pixel_tomato.dart      # 🍅 像素番茄图标组件
    ├── statistics_page.dart   # 📊 统计页面（图表、数据展示）
    └── settings_page.dart     # ⚙️ 设置页面（参数配置）
```

---

## 目标文件结构（未来拆分计划）

```
lib/
├── main.dart                  # 入口：runApp + ChangeNotifierProvider
├── app/
│   └── app.dart               # MaterialApp 配置
├── screens/
│   ├── timer_screen.dart      # ⏱ 计时页面
│   ├── statistics_screen.dart # 📊 统计页面
│   └── settings_screen.dart   # ⚙️ 设置页面
├── widgets/
│   ├── tomato_row.dart        # 🍅 番茄进度行
│   ├── pixel_ring.dart        # ⏱ 像素环形计时器
│   ├── phase_tabs.dart        # 🧭 阶段标签栏 (专注/短休/长休)
│   ├── task_list.dart         # 📝 任务列表
│   ├── pixel_button.dart      # 🔘 像素风格按钮
│   └── bottom_nav_bar.dart    # 🧭 底部导航栏
├── state/
│   └── pomodoro_state.dart    # 🧠 状态管理 (PomodoroState + ChangeNotifier)
├── models/
│   ├── task.dart              # 📋 Task 数据模型
│   └── phase.dart             # 🔄 Phase 枚举 (focus/shortBreak/longBreak)
├── theme/
│   ├── colors.dart            # 🎨 AppColors 颜色常量
│   └── text_styles.dart       # ✍️ AppTextStyles 文字样式
└── utils/
    ├── timer_service.dart     # ⏲ Timer 工具
    └── storage_service.dart   # 💾 本地存储（数据持久化）
```

---

## 数据流向 (Data Flow)

```
用户点击按钮
      ↓
PixelButton.onTap()
      ↓
PomodoroState.start() / pause() / abandon()   ← ChangeNotifier
      ↓
_timer (dart:async Timer) 每秒 tick
      ↓
notifyListeners()
      ↓
Consumer<PomodoroState> 重建 HomeScreen
      ↓
PixelRingTimer / TomatoRow / TimeDisplay 更新 UI
```

---

## 各类职责总览

| 类 / 文件 | 类型 | 职责 |
|-----------|------|------|
| `AppColors` | 常量类 | 所有颜色定义（constants.dart） |
| `AppTextStyles` | 常量类 | 所有文字样式（constants.dart） |
| `Phase` | enum | 三种计时阶段及时长 |
| `Task` | Model | 任务数据 (id, text, isDone) |
| `PomodoroState` | ChangeNotifier | 计时器逻辑、任务状态、通知 UI |
| `PhaseTabBar` | StatelessWidget | 阶段切换 Tab |
| `TomatoRow` | StatelessWidget | 4个番茄像素图标的进度行 |
| `PixelTomato` | StatelessWidget | 像素番茄图标组件（pixel_tomato.dart） |
| `_TomatoPainter` | CustomPainter | 逐像素绘制番茄图标 |
| `PixelRingTimer` | StatelessWidget | 环形进度条容器 |
| `_PixelRingPainter` | CustomPainter | 逐点绘制环形进度 |
| `PixelButton` | StatefulWidget | 像素风按压效果按钮 |
| `TaskList` | StatefulWidget | 任务列表 + 增删改功能 |
| `HomeScreen` | StatefulWidget | 主界面容器（底部导航 + 页面切换） |
| `TimerView` | StatelessWidget | 计时页面内容 |
| `StatisticsPage` | StatelessWidget | 统计页面（statistics_page.dart） |
| `SettingsPage` | StatelessWidget | 设置页面（settings_page.dart） |
| `TomatoApp` | StatelessWidget | MaterialApp 根节点 |

---

## 依赖关系

```
pubspec.yaml 外部依赖:
  provider: ^6.1.2   ← 状态管理
  fl_chart: ^1.1.1   ← 统计图表绘制
  flutter (SDK)
  dart:async         ← Timer
  dart:math          ← cos/sin (环形绘制)
  package:flutter/services.dart ← 锁定竖屏方向
```

## 多页面数据流

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│  TimerView      │   │ StatisticsPage  │   │ SettingsPage    │
│  (计时页面)     │   │ (统计页面)      │   │ (设置页面)      │
└─────────────────┘   └─────────────────┘   └─────────────────┘
          │                     │                     │
          └─────────────────────┼─────────────────────┘
                                ↓
                ┌─────────────────────────────┐
                │   PomodoroState (全局状态)   │
                │  (ChangeNotifierProvider)   │
                └─────────────────────────────┘
                                ↑
                                │
                ┌─────────────────────────────┐
                │       本地存储 (未来)        │
                └─────────────────────────────┘
```
