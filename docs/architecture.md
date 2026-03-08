# 项目架构 · Project Architecture

## 项目简介
**Pixel Zen Pomodoro** 是一个像素风格的番茄钟应用，使用 Flutter + Material 风格构建，核心功能包括：
- 专注 / 短休 / 长休三种计时模式
- 像素风格环形进度条和番茄图标
- 任务列表（今日任务）
- Provider 状态管理

---

## 当前文件结构（MVP 单文件版）

Currently **everything lives in one file**: `lib/main.dart`.  
This is fine for learning, but the architecture map shows the future split:

```
lib/main.dart  (917 lines — 全部放在这里)
```

---

## 目标文件结构（架构图版）

```
lib/
├── main.dart                  # 入口：runApp + ChangeNotifierProvider
├── app/
│   └── app.dart               # MaterialApp 配置
├── screens/
│   └── home_screen.dart       # 主界面 (HomeScreen)
├── widgets/
│   ├── tomato_row.dart        # 🍅 番茄进度行
│   ├── pixel_ring.dart        # ⏱ 像素环形计时器
│   ├── phase_tabs.dart        # 🧭 阶段标签栏 (专注/短休/长休)
│   ├── task_list.dart         # 📝 任务列表
│   └── pixel_button.dart      # 🔘 像素风格按钮
├── state/
│   └── pomodoro_state.dart    # 🧠 状态管理 (PomodoroState + ChangeNotifier)
├── models/
│   ├── task.dart              # 📋 Task 数据模型
│   └── phase.dart             # 🔄 Phase 枚举 (focus/shortBreak/longBreak)
├── theme/
│   ├── colors.dart            # 🎨 AppColors 颜色常量
│   └── text_styles.dart       # ✍️ AppTextStyles 文字样式
└── utils/
    └── timer_service.dart     # ⏲ Timer 工具 (计划中)
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
| `AppColors` | 常量类 | 所有颜色定义 |
| `AppTextStyles` | 常量类 | 所有文字样式 |
| `Phase` | enum | 三种计时阶段及时长 |
| `Task` | Model | 任务数据 (id, text, isDone) |
| `PomodoroState` | ChangeNotifier | 计时器逻辑、任务状态、通知 UI |
| `PhaseTabBar` | StatelessWidget | 阶段切换 Tab |
| `TomatoRow` | StatelessWidget | 4个番茄像素图标的进度行 |
| `_TomatoPainter` | CustomPainter | 逐像素绘制番茄图标 |
| `PixelRingTimer` | StatelessWidget | 环形进度条容器 |
| `_PixelRingPainter` | CustomPainter | 逐点绘制环形进度 |
| `PixelButton` | StatefulWidget | 像素风按压效果按钮 |
| `TaskList` | StatelessWidget | 任务列表 + 勾选 |
| `HomeScreen` | StatelessWidget | 组合所有 widget 的主界面 |
| `TomatoApp` | StatelessWidget | MaterialApp 根节点 |

---

## 依赖关系

```
pubspec.yaml 外部依赖:
  provider: ^6.1.2   ← 状态管理
  flutter (SDK)
  dart:async         ← Timer
  dart:math          ← cos/sin (环形绘制)
  package:flutter/services.dart ← 锁定竖屏方向
```
