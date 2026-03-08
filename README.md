# Pixel Zen Pomodoro 🍅

一个像素风格的番茄钟 Flutter 应用 · A pixel-art Pomodoro timer built with Flutter.

## 功能 Features

- **三种计时模式** — 专注 25min / 短休 5min / 长休 15min
- **像素环形进度条** — 用 `CustomPainter` 绘制的 80 点环形计时器
- **番茄像素图标** — 9×10 像素网格自绘番茄，记录每轮完成数
- **任务列表** — 今日任务勾选管理
- **像素风格按钮** — 带按压动画的像素按钮
- Provider 状态管理

## 运行 Getting Started

```bash
flutter pub get
flutter run
```

## 依赖 Dependencies

| 包 | 用途 |
|----|------|
| `provider: ^6.1.2` | 状态管理 |
| `flutter/material` | UI 框架 |
| `dart:async` | Timer 计时 |
| `dart:math` | 环形绘制 cos/sin |

## 文件结构

```
lib/
└── main.dart        # 所有代码 (MVP 单文件版, 917 行)
    ├── AppColors    # 颜色常量
    ├── AppTextStyles# 文字样式
    ├── Phase        # 阶段枚举 (enum)
    ├── Task         # 任务数据模型
    ├── PomodoroState# 状态管理 (ChangeNotifier)
    ├── PhaseTabBar  # 阶段切换 Tab
    ├── TomatoRow    # 番茄进度行
    ├── PixelRingTimer # 环形计时器
    ├── PixelButton  # 像素风格按钮
    ├── TaskList     # 任务列表
    ├── HomeScreen   # 主界面
    └── TomatoApp    # MaterialApp 根节点
```

## 文档 Documentation

学习文档在 [`doc/`](doc/) 文件夹:

| 文件 | 内容 |
|------|------|
| [doc/architecture.md](doc/architecture.md) | 项目架构、数据流、目标文件结构 |
| [doc/widget_guide.md](doc/widget_guide.md) | 各 Widget 详解、Widget 树结构 |
| [doc/state_management.md](doc/state_management.md) | Provider 用法、PomodoroState 解析 |
| [doc/flutter_concepts.md](doc/flutter_concepts.md) | Flutter 核心概念、布局速查、Hot Reload 说明 |
