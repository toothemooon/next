/// Pixel Zen Pomodoro 主入口文件
/// 包含核心业务逻辑、状态管理和主要UI组件
/// 本文件是应用的核心，包含：
/// - 阶段枚举定义
/// - 任务数据模型
/// - Pomodoro 状态管理（ChangeNotifier）
/// - 所有核心 Widget 组件
/// - 应用入口和根组件
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'widgets/pixel_tomato.dart';
import 'widgets/settings_page.dart';
import 'widgets/statistics_page.dart';

// ════════════════════════════════════════
// 🔄 阶段枚举
// ════════════════════════════════════════
/// 番茄钟的三个计时阶段
enum Phase {
  focus,      // 专注阶段
  shortBreak, // 短休息阶段
  longBreak;  // 长休息阶段

  /// 阶段的中文显示名称
  String get label {
    switch (this) {
      case Phase.focus:      return '专注';
      case Phase.shortBreak: return '短休';
      case Phase.longBreak:  return '长休';
    }
  }

  /// 阶段的默认持续时间（秒）
  int get durationSeconds {
    switch (this) {
      case Phase.focus:      return 25 * 60;
      case Phase.shortBreak: return 5 * 60;
      case Phase.longBreak:  return 15 * 60;
    }
  }
}

// ════════════════════════════════════════
// 📋 任务模型
// ════════════════════════════════════════
/// 任务数据模型，代表今日任务列表中的单个任务
class Task {
  final String id;      // 任务唯一标识
  final String text;    // 任务内容
  bool isDone;          // 任务是否完成

  Task({
    required this.id,
    required this.text,
    this.isDone = false,
  });

  /// 复制任务并更新部分属性，用于不可变数据更新
  Task copyWith({bool? isDone}) =>
      Task(id: id, text: text, isDone: isDone ?? this.isDone);
}

// ════════════════════════════════════════
// 🧠 状态管理
// ════════════════════════════════════════
/// 番茄钟全局状态管理类，使用 ChangeNotifier 实现状态通知
/// 管理计时器状态、任务列表、番茄完成数等核心数据
class PomodoroState extends ChangeNotifier {
  static const int totalTomatoes = 4;  /// 每轮番茄工作法的番茄总数

  Phase _phase      = Phase.focus;      /// 当前计时阶段
  int _timeLeft     = Phase.focus.durationSeconds; /// 剩余时间（秒）
  bool _isRunning   = false;            /// 计时器是否正在运行
  int _completed    = 0;                /// 累计完成的番茄总数
  bool _justDone    = false;            /// 是否刚刚完成一个番茄（用于触发完成动画）

  List<Task> _tasks = [                 /// 任务列表数据
    Task(id: '1', text: '整理读书笔记'),
    Task(id: '2', text: '完成项目文档'),
    Task(id: '3', text: '运动 30 分钟'),
  ];

  Timer? _timer;                        /// 计时器实例

  // Getters - 对外提供只读的状态访问
  Phase get phase       => _phase;                /// 获取当前阶段
  int get timeLeft      => _timeLeft;             /// 获取剩余时间（秒）
  bool get isRunning    => _isRunning;            /// 获取计时器运行状态
  int get completed     => _completed % totalTomatoes; /// 获取当前轮已完成番茄数（0-3）
  int get totalCompleted=> _completed;            /// 获取累计完成番茄总数
  bool get justDone     => _justDone;             /// 获取是否刚完成番茄
  List<Task> get tasks  => List.unmodifiable(_tasks); /// 获取只读的任务列表

  /// 计时器进度，范围 0.0 ~ 1.0，用于环形进度条显示
  double get progress =>
      1.0 - (_timeLeft / _phase.durationSeconds);

  /// 格式化的时间字符串，如 "25:00"
  String get timeString {
    final m = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_timeLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// 开始计时
  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _justDone = false;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    notifyListeners();
  }

  /// 暂停计时
  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  /// 放弃当前计时，重置时间
  void abandon() {
    _timer?.cancel();
    _isRunning = false;
    _timeLeft = _phase.durationSeconds;
    _justDone = false;
    notifyListeners();
  }

  /// 切换计时阶段
  void switchPhase(Phase p) {
    _timer?.cancel();
    _isRunning = false;
    _phase = p;
    _timeLeft = p.durationSeconds;
    _justDone = false;
    notifyListeners();
  }

  /// 计时器每秒回调函数
  void _tick(Timer t) {
    if (_timeLeft <= 1) {
      _timer?.cancel();
      _isRunning = false;
      _timeLeft = 0;
      if (_phase == Phase.focus) {  // 只有专注阶段完成才计数番茄
        _completed++;
        _justDone = true;
      }
      notifyListeners();
      return;
    }
    _timeLeft--;
    notifyListeners();
  }

  /// 切换任务完成状态
  void toggleTask(String id) {
    _tasks = _tasks.map((t) {
      if (t.id == id) return t.copyWith(isDone: !t.isDone);
      return t;
    }).toList();
    _sortTasks();
    notifyListeners();
  }

  /// 添加新任务
  void addTask(String text) {
    if (text.trim().isEmpty) return;
    _tasks = [Task(id: DateTime.now().toString(), text: text), ..._tasks];
    _sortTasks();
    notifyListeners();
  }

  /// 任务排序：未完成的任务在前，已完成的在后
  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
  }

  /// 删除指定任务
  void deleteTask(String id) {
    _tasks = _tasks.where((t) => t.id != id).toList();
    notifyListeners();
  }

  /// 资源清理：销毁时取消计时器
  @override
  void dispose() {
    _timer?.cancel(); // 必须取消 Timer，否则内存泄漏
    super.dispose();
  }
}

// ════════════════════════════════════════
// 🧭 阶段标签栏
// ════════════════════════════════════════
/// 阶段切换标签栏，在专注/短休/长休三个阶段之间切换
class PhaseTabBar extends StatelessWidget {
  final Phase current;                /// 当前选中的阶段
  final ValueChanged<Phase> onChanged;/// 阶段切换时的回调

  const PhaseTabBar({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.track,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: Phase.values.map((p) {
          final isActive = p == current;
          return GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accentD : Colors.transparent,
                border: isActive
                    ? Border.all(color: AppColors.accent, width: 2)
                    : null,
              ),
              child: Text(
                p.label,
                style: isActive
                    ? AppTextStyles.tabActive
                    : AppTextStyles.tabInactive,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ════════════════════════════════════════
// 🍅 番茄进度行
// ════════════════════════════════════════
/// 番茄进度展示行，显示当前轮已完成的番茄数量
class TomatoRow extends StatelessWidget {
  final int total;      /// 总番茄数，默认4个
  final int completed;  /// 已完成的番茄数

  const TomatoRow({
    super.key,
    this.total = 4,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: PixelTomato(filled: i < completed),
        );
      }),
    );
  }
}

// ════════════════════════════════════════
// ⏱️ 像素环形计时器
// ════════════════════════════════════════
/// 像素风格环形进度条，使用 CustomPainter 绘制80个点组成的圆环
class PixelRingTimer extends StatelessWidget {
  final double progress; /// 进度 0.0 ~ 1.0
  final Color color;     /// 进度条颜色
  final double size;     /// 组件尺寸

  const PixelRingTimer({
    super.key,
    required this.progress,
    this.color = AppColors.accent,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PixelRingPainter(progress: progress, color: color),
    );
  }
}

/// 像素环形进度条的绘制实现
class _PixelRingPainter extends CustomPainter {
  final double progress; /// 进度 0.0 ~ 1.0
  final Color color;     /// 进度条颜色

  _PixelRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.55;

    const dotSize = 5.0;
    const steps   = 80;

    final trackPaint = Paint()..color = AppColors.track;
    final activePaint = Paint()..color = color;

    for (int i = 0; i < steps; i++) {
      final angle = -pi / 2 + (2 * pi * i / steps);
      final px = cx + r * cos(angle);
      final py = cy + r * sin(angle);

      final isActive = (i / steps) <= progress;
      final p = isActive ? activePaint : trackPaint;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(px, py),
          width: dotSize,
          height: dotSize,
        ),
        p,
      );
    }

    if (progress > 0.01) {
      final endAngle = -pi / 2 + (2 * pi * progress);
      final ex = cx + r * cos(endAngle);
      final ey = cy + r * sin(endAngle);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(ex, ey), width: 9, height: 9),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_PixelRingPainter old) =>
      old.progress != progress || old.color != color;
}

// ════════════════════════════════════════
// 🔘 像素按钮
// ════════════════════════════════════════
/// 像素风格按钮，带按压动画效果
class PixelButton extends StatefulWidget {
  final String label;        /// 按钮文字
  final VoidCallback onTap;  /// 点击回调
  final Color fillColor;     /// 填充颜色
  final Color shadowColor;   /// 阴影颜色
  final Color textColor;     /// 文字颜色，默认白色
  final double width;        /// 按钮宽度，默认180
  final double height;       /// 按钮高度，默认50
  final TextStyle? textStyle;/// 自定义文字样式

  const PixelButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.fillColor,
    required this.shadowColor,
    this.textColor = Colors.white,
    this.width = 180,
    this.height = 50,
    this.textStyle,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

/// 像素按钮的状态管理，处理按压动画
class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false; /// 按钮是否被按下

  @override
  Widget build(BuildContext context) {
    final offset = _pressed ? 0.0 : 3.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: SizedBox(
        width: widget.width + 3,
        height: widget.height + 3,
        child: Stack(
          children: [
            Positioned(
              left: 3, top: 3,
              child: Container(
                width: widget.width,
                height: widget.height,
                color: widget.shadowColor,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              left: _pressed ? 3 : 0,
              top: _pressed ? 3 : 0,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.fillColor,
                  border: Border.all(color: widget.shadowColor, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: widget.textStyle ??
                      TextStyle(
                        color: widget.textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════
// 📝 任务列表
// ════════════════════════════════════════
/// 任务列表组件，支持任务的增删改操作
class TaskList extends StatefulWidget {
  final List<Task> tasks;               /// 任务列表数据
  final ValueChanged<String> onToggle;  /// 切换任务完成状态的回调
  final ValueChanged<String> onDelete;  /// 删除任务的回调
  final ValueChanged<String> onAdd;     /// 添加新任务的回调

  const TaskList({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

/// 任务列表的状态管理
class _TaskListState extends State<TaskList> {
  bool _isAdding = false;                      /// 是否正在添加新任务
  final TextEditingController _controller = TextEditingController(); /// 输入框控制器
  final FocusNode _focusNode = FocusNode();    /// 输入框焦点管理

  void _submit() {
    if (_controller.text.isNotEmpty) {
      widget.onAdd(_controller.text);
      _controller.clear();
    }
    setState(() => _isAdding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.track, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('// 今日任务', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 8),
          ...widget.tasks.map((t) => _TaskRow(
                task: t,
                onToggle: () => widget.onToggle(t.id),
                onDelete: () => widget.onDelete(t.id),
              )),
          const SizedBox(height: 8),
          _buildAddRow(),
        ],
      ),
    );
  }

  Widget _buildAddRow() {
    if (_isAdding) {
      return Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              style: AppTextStyles.taskItem,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '输入任务...',
                hintStyle: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 18, color: AppColors.accentD),
            onPressed: _submit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _isAdding = true);
        _focusNode.requestFocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '＋ 添加任务...',
          style: AppTextStyles.taskItem.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

/// 任务列表中的单个任务行
class _TaskRow extends StatelessWidget {
  final Task task;              /// 任务数据
  final VoidCallback onToggle;  /// 切换完成状态的回调
  final VoidCallback onDelete;  /// 删除任务的回调

  const _TaskRow({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 隐藏 Dismissible 背景（极简风格），或者显示红色背景
    // 这里采用极简风格：左滑直接删除，背景显示红色提示
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: AppColors.tomRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white, size: 20),
      ),
      child: GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8), // 增加一点点击区域
          child: Row(
            children: [
              Container(
                width: 18, // 稍微加大
                height: 18,
                decoration: BoxDecoration(
                  color: task.isDone ? AppColors.accent.withOpacity(0.2) : Colors.transparent,
                  border: Border.all(
                    color: task.isDone ? AppColors.accent : AppColors.textSecondary.withOpacity(0.5),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4), //稍微圆角一点点
                ),
                child: task.isDone
                    ? const Icon(Icons.check, size: 12, color: AppColors.accentD)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.text,
                  style: task.isDone
                      ? AppTextStyles.taskDone.copyWith(color: AppColors.textSecondary.withOpacity(0.5))
                      : AppTextStyles.taskItem,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════
// 🏠 主屏幕
// ════════════════════════════════════════
/// 应用主屏幕，包含底部导航栏和三个子页面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// 主屏幕状态管理，处理底部导航切换
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; /// 当前选中的页面索引

  /// 三个子页面：计时页、统计页、设置页
  final List<Widget> _pages = [
    const TimerView(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
            ),
            _buildNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    final items = [
      (Icons.timer_outlined, '计时'),
      (Icons.bar_chart, '统计'),
      (Icons.settings_outlined, '设置'),
    ];
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.navBg,
        border: Border(top: BorderSide(color: AppColors.track, width: 2)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final (icon, label) = items[index];
          final active = _selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _selectedIndex = index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (active)
                    Container(height: 3, width: 32, color: AppColors.accent),
                  const SizedBox(height: 4),
                  Icon(
                    icon,
                    size: 20,
                    color: active ? AppColors.accentD : AppColors.textSecondary,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: active ? AppColors.accentD : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// 计时页面，展示番茄钟的核心功能
class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroState>(
      builder: (context, state, _) {
        return Column(
          children: [
            const SizedBox(height: 6),
            PhaseTabBar(
              current: state.phase,
              onChanged: (p) => state.switchPhase(p),
            ),
            const SizedBox(height: 12),
            TomatoRow(completed: state.completed),
            const SizedBox(height: 4),
            Text('${state.completed} / 4', style: AppTextStyles.count),
            _buildPixelDivider(),
            const SizedBox(height: 8),
            _buildRingWithTime(state),
            _buildPixelDivider(),
            const SizedBox(height: 12),
            _buildControls(context, state),
            const SizedBox(height: 12),
            Expanded(
              child: TaskList(
                tasks: state.tasks,
                onToggle: state.toggleTask,
                onDelete: state.deleteTask,
                onAdd: state.addTask,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建像素风格的分割线，由间断的点组成
  Widget _buildPixelDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 40),
      child: Row(
        children: List.generate(
          20,
          (i) => Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: i.isEven ? AppColors.track : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建带时间显示的环形计时器，Stack 叠加环形进度条和时间文字
  Widget _buildRingWithTime(PomodoroState state) {
    final ringColor = state.justDone ? AppColors.tomRed : AppColors.accent;

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PixelRingTimer(
            progress: state.progress,
            color: ringColor,
            size: 190,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.timeString, style: AppTextStyles.time),
              Text(
                state.phase.label,
                style: AppTextStyles.label.copyWith(
                  color: ringColor,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建控制按钮区域，根据不同状态显示不同的按钮组合
  /// - 番茄刚完成：显示完成按钮和提示
  /// - 计时未开始：显示开始按钮
  /// - 计时中：显示暂停和放弃按钮
  Widget _buildControls(BuildContext context, PomodoroState state) {
    if (state.justDone) {
      return Column(
        children: [
          PixelButton(
            label: '✓  完成！',
            onTap: () => state.switchPhase(state.phase),
            fillColor: AppColors.tomRed,
            shadowColor: AppColors.tomRedD,
            width: 180,
          ),
          const SizedBox(height: 8),
          Text('已完成第 ${state.totalCompleted} 个番茄', style: AppTextStyles.label),
        ],
      );
    }

    if (!state.isRunning) {
      return PixelButton(
        label: '▶  开始专注',
        onTap: state.start,
        fillColor: AppColors.accent,
        shadowColor: AppColors.accentD,
        width: 180,
      );
    }

    return Column(
      children: [
        PixelButton(
          label: '⏸  暂停',
          onTap: state.pause,
          fillColor: AppColors.accent,
          shadowColor: AppColors.accentD,
          width: 140,
        ),
        const SizedBox(height: 10),
        PixelButton(
          label: '打断 / 废弃',
          onTap: state.abandon,
          fillColor: AppColors.track,
          shadowColor: AppColors.tomEmptyD,
          textColor: AppColors.secondary,
          width: 160,
          height: 40,
          textStyle: AppTextStyles.btnSecondary,
        ),
      ],
    );
  }
}
// ════════════════════════════════════════
// 🚀 入口函数
// ════════════════════════════════════════
/// 应用入口函数
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); /// 锁定竖屏
  runApp(
    ChangeNotifierProvider(
      create: (_) => PomodoroState(), /// 全局注入状态管理
      child: const TomatoApp(),
    ),
  );
}

/// 应用根组件
class TomatoApp extends StatelessWidget {
  const TomatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomato',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'SF Pro Text',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}