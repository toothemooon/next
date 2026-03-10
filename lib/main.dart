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
enum Phase {
  focus,
  shortBreak,
  longBreak;

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

// ════════════════════════════════════════
// 📋 任务模型
// ════════════════════════════════════════
class Task {
  final String id;
  final String text;
  bool isDone;

  Task({
    required this.id,
    required this.text,
    this.isDone = false,
  });

  Task copyWith({bool? isDone}) =>
      Task(id: id, text: text, isDone: isDone ?? this.isDone);
}

// ════════════════════════════════════════
// 🧠 状态管理
// ════════════════════════════════════════
class PomodoroState extends ChangeNotifier {
  static const int totalTomatoes = 4;

  Phase _phase      = Phase.focus;
  int _timeLeft     = Phase.focus.durationSeconds;
  bool _isRunning   = false;
  int _completed    = 0;
  bool _justDone    = false;

  List<Task> _tasks = [
    Task(id: '1', text: '整理读书笔记'),
    Task(id: '2', text: '完成项目文档'),
    Task(id: '3', text: '运动 30 分钟'),
  ];

  Timer? _timer;

  Phase get phase       => _phase;
  int get timeLeft      => _timeLeft;
  bool get isRunning    => _isRunning;
  int get completed     => _completed % totalTomatoes;
  int get totalCompleted=> _completed;
  bool get justDone     => _justDone;
  List<Task> get tasks  => List.unmodifiable(_tasks);

  double get progress =>
      1.0 - (_timeLeft / _phase.durationSeconds);

  String get timeString {
    final m = (_timeLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_timeLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _justDone = false;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void abandon() {
    _timer?.cancel();
    _isRunning = false;
    _timeLeft = _phase.durationSeconds;
    _justDone = false;
    notifyListeners();
  }

  void switchPhase(Phase p) {
    _timer?.cancel();
    _isRunning = false;
    _phase = p;
    _timeLeft = p.durationSeconds;
    _justDone = false;
    notifyListeners();
  }

  void _tick(Timer t) {
    if (_timeLeft <= 1) {
      _timer?.cancel();
      _isRunning = false;
      _timeLeft = 0;
      if (_phase == Phase.focus) {
        _completed++;
        _justDone = true;
      }
      notifyListeners();
      return;
    }
    _timeLeft--;
    notifyListeners();
  }

  void toggleTask(String id) {
    _tasks = _tasks.map((t) {
      if (t.id == id) return t.copyWith(isDone: !t.isDone);
      return t;
    }).toList();
    _sortTasks();
    notifyListeners();
  }

  void addTask(String text) {
    if (text.trim().isEmpty) return;
    _tasks = [Task(id: DateTime.now().toString(), text: text), ..._tasks];
    _sortTasks();
    notifyListeners();
  }

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
  }

  void deleteTask(String id) {
    _tasks = _tasks.where((t) => t.id != id).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ════════════════════════════════════════
// 🧭 阶段标签栏
// ════════════════════════════════════════
class PhaseTabBar extends StatelessWidget {
  final Phase current;
  final ValueChanged<Phase> onChanged;

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
class TomatoRow extends StatelessWidget {
  final int total;
  final int completed;

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
class PixelRingTimer extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;

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

class _PixelRingPainter extends CustomPainter {
  final double progress;
  final Color color;

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
class PixelButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color fillColor;
  final Color shadowColor;
  final Color textColor;
  final double width;
  final double height;
  final TextStyle? textStyle;

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

class _PixelButtonState extends State<PixelButton> {
  bool _pressed = false;

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
class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onAdd;

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

class _TaskListState extends State<TaskList> {
  bool _isAdding = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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

class _TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

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
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => PomodoroState(),
      child: const TomatoApp(),
    ),
  );
}

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