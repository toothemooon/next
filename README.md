# Pixel Zen Pomodoro 🍅

一个像素风格的番茄钟 Flutter 应用 · A pixel-art Pomodoro timer built with Flutter.

## 功能 Features

- **三种计时模式** — 专注 25min / 短休 5min / 长休 15min，时长可自定义
- **像素环形进度条** — 用 `CustomPainter` 绘制的 80 点环形计时器
- **番茄像素图标** — 9×10 像素网格自绘番茄，记录每轮完成数
- **任务列表** — 今日任务增删改管理，支持左滑删除
- **像素风格按钮** — 带按压动画的像素按钮
- **统计页面** — 专注数据可视化，本周趋势、时间段分布等
- **设置页面** — 自定义计时时长、通知开关、主题切换等
- Provider 状态管理
- 多平台支持（Android/iOS/Windows/macOS/Linux/Web）

## 运行 Getting Started

```bash
flutter pub get
flutter run
```

## 依赖 Dependencies

| 包 | 用途 |
|----|------|
| `provider: ^6.1.2` | 状态管理 |
| `fl_chart: ^1.1.1` | 统计图表绘制 |
| `flutter/material` | UI 框架 |
| `dart:async` | Timer 计时 |
| `dart:math` | 环形绘制 cos/sin |

## 文件结构

```
lib/
├── main.dart                  # 入口文件 + 核心逻辑
├── constants.dart             # 全局常量（颜色、文字样式）
├── widgets/
│   ├── pixel_tomato.dart      # 像素番茄图标组件
│   ├── statistics_page.dart   # 统计页面（图表、数据展示）
│   └── settings_page.dart     # 设置页面（参数配置）
```

### 核心类/组件
| 类名 | 职责 |
|------|------|
| `AppColors` | 全局颜色常量定义 |
| `AppTextStyles` | 全局文字样式定义 |
| `Phase` | 计时阶段枚举（专注/短休/长休） |
| `Task` | 任务数据模型 |
| `PomodoroState` | 状态管理（ChangeNotifier） |
| `PhaseTabBar` | 阶段切换标签栏 |
| `TomatoRow` | 番茄进度展示行 |
| `PixelRingTimer` | 像素环形进度条 |
| `PixelButton` | 像素风格按压按钮 |
| `TaskList` | 任务列表（支持增删改） |
| `HomeScreen` | 主页面容器（底部导航 + 页面切换） |
| `TimerView` | 计时页面 |
| `StatisticsPage` | 统计页面 |
| `SettingsPage` | 设置页面 |
| `TomatoApp` | MaterialApp 根节点 |

## 文档 Documentation

学习文档在 [`doc/`](doc/) 文件夹:

| 文件 | 内容 |
|------|------|
| [doc/architecture.md](doc/architecture.md) | 项目架构、数据流、目标文件结构 |
| [doc/widget_guide.md](doc/widget_guide.md) | 各 Widget 详解、Widget 树结构 |
| [doc/state_management.md](doc/state_management.md) | Provider 用法、PomodoroState 解析 |
| [doc/flutter_concepts.md](doc/flutter_concepts.md) | Flutter 核心概念、布局速查、Hot Reload 说明 |
