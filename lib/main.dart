import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════
// 🎨 主题颜色
// ════════════════════════════════════════
class AppColors {
  static const Color bg        = Color(0xFFF2EFE2);
  static const Color bg2       = Color(0xFFE8E4D4);
  static const Color pixelGrid = Color(0xFFDEDACA);
  static const Color card      = Color(0xFFECE8DA);
  static const Color navBg     = Color(0xFFEAE6D8);
  static const Color track     = Color(0xFFD8D4C4);

  static const Color textPrimary   = Color(0xFF2A2822);
  static const Color textSecondary = Color(0xFF9A927E);

  static const Color accent    = Color(0xFF7A9E78);
  static const Color accentD   = Color(0xFF567A54);
  static const Color accentL   = Color(0xFFA8C4A6);

  static const Color tomRed    = Color(0xFFC84A32);
  static const Color tomRedL   = Color(0xFFE07258);
  static const Color tomRedD   = Color(0xFF96301E);

  static const Color tomEmpty  = Color(0xFFD8D2C0);
  static const Color tomEmptyD = Color(0xFFB8B2A0);

  static const Color leaf      = Color(0xFF568A54);
  static const Color leafD     = Color(0xFF3A6238);
  static const Color leafEmpty = Color(0xFFC0C8B8);

  static const Color secondary = Color(0xFFB87858);
}

// ════════════════════════════════════════
// ✍️ 文字样式
// ════════════════════════════════════════
class AppTextStyles {
  static const TextStyle time = TextStyle(
    fontFamily: 'Courier',
    fontSize: 64,
    fontWeight: FontWeight.bold,
    letterSpacing: -2,
    color: AppColors.textPrimary,
  );

  static const TextStyle timeSmall = TextStyle(
    fontFamily: 'Courier',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelAccent = TextStyle(
    fontSize: 14,
    letterSpacing: 2,
    color: AppColors.accent,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tabActive = TextStyle(
    fontSize: 13,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tabInactive = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle btnPrimary = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle btnSecondary = TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle taskItem = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskDone = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    color: AppColors.accentD,
    fontFamily: 'Courier',
    letterSpacing: 0.5,
  );

  static const TextStyle count = TextStyle(
    fontFamily: 'Courier',
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}

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
    notifyListeners();
  }

  void addTask(String text) {
    _tasks = [..._tasks, Task(id: DateTime.now().toString(), text: text)];
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
          child: _PixelTomato(filled: i < completed),
        );
      }),
    );
  }
}

class _PixelTomato extends StatelessWidget {
  final bool filled;
  final double size;

  const _PixelTomato({this.filled = false, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.2),
      painter: _TomatoPainter(filled: filled),
    );
  }
}

class _TomatoPainter extends CustomPainter {
  final bool filled;
  _TomatoPainter({required this.filled});

  @override
  void paint(Canvas canvas, Size size) {
    final px = size.width / 9;

    final bodyColor  = filled ? AppColors.tomRed    : AppColors.tomEmpty;
    final hiColor    = filled ? AppColors.tomRedL   : AppColors.bg;
    final leafColor  = filled ? AppColors.leaf      : AppColors.leafEmpty;
    final shadowColor= filled ? AppColors.tomRedD   : AppColors.tomEmptyD;
    final outlineColor= filled ? null : AppColors.tomEmptyD;

    void dot(int gx, int gy, Color c) {
      final rect = Rect.fromLTWH(
        (gx) * px, (gy) * px,
        px - 0.5, px - 0.5,
      );
      canvas.drawRect(rect, Paint()..color = c);
    }

    // Stem & Leaves
    dot(4, 0, leafColor);
    dot(4, 1, leafColor);
    dot(2,1,leafColor); dot(3,1,leafColor);
    dot(1,2,leafColor); dot(2,2,leafColor);
    dot(5,1,leafColor); dot(6,1,leafColor);
    dot(6,2,leafColor); dot(7,2,leafColor);
    dot(3,2,leafColor); dot(4,2,leafColor); dot(5,2,leafColor);

    // Body
    for (final gx in [2,3,4,5,6]) dot(gx,3,bodyColor);
    dot(1,3,shadowColor); dot(7,3,shadowColor);
    for (int gx=1; gx<=7; gx++) dot(gx,4,bodyColor);
    dot(0,4,shadowColor); dot(8,4,shadowColor);
    for (int gx=0; gx<=8; gx++) dot(gx,5,bodyColor);
    for (int gx=0; gx<=8; gx++) dot(gx,6,bodyColor);
    dot(0,6,shadowColor); dot(8,6,shadowColor);
    for (int gx=1; gx<=7; gx++) dot(gx,7,bodyColor);
    dot(1,7,shadowColor); dot(7,7,shadowColor);
    for (final gx in [2,3,4,5,6]) dot(gx,8,bodyColor);
    dot(2,8,shadowColor); dot(6,8,shadowColor);
    for (final gx in [3,4,5]) dot(gx,9,shadowColor);

    // Highlight
    if (filled) {
      dot(1,4,hiColor); dot(2,4,hiColor);
      dot(1,5,hiColor);
    }

    // Outline for empty
    if (outlineColor != null) {
      dot(1,3,outlineColor); dot(7,3,outlineColor);
      dot(0,4,outlineColor); dot(8,4,outlineColor);
    }
  }

  @override
  bool shouldRepaint(_TomatoPainter old) => old.filled != filled;
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
    final r  = size.width * 0.44;

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
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final ValueChanged<String> onToggle;

  const TaskList({super.key, required this.tasks, required this.onToggle});

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
          ...tasks.map((t) => _TaskRow(task: t, onToggle: () => onToggle(t.id))),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const _TaskRow({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: task.isDone ? AppColors.accent : Colors.transparent,
                border: Border.all(
                  color: task.isDone ? AppColors.accentD : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: task.isDone
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                task.text,
                style: task.isDone
                    ? AppTextStyles.taskDone
                    : AppTextStyles.taskItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════
// 🏠 主屏幕
// ════════════════════════════════════════
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Consumer<PomodoroState>(
          builder: (context, state, _) {
            return Column(
              children: [
                _buildStatusBar(),
                _buildAppBadge(),
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
                  ),
                ),
                _buildNavBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      color: AppColors.bg2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('9:41', style: AppTextStyles.label),
          Row(
            children: List.generate(
              3,
              (i) => Container(
                width: 8, height: 8,
                margin: const EdgeInsets.only(left: 3),
                color: i < 3 ? AppColors.accent : AppColors.track,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentD,
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: const Text(
        'TOMATO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFamily: 'Courier',
          letterSpacing: 2,
        ),
      ),
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

  Widget _buildNavBar() {
    final items = [
      (Icons.timer_outlined, '计时', true),
      (Icons.bar_chart,       '统计', false),
      (Icons.settings_outlined,'设置', false),
    ];
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.navBg,
        border: Border(top: BorderSide(color: AppColors.track, width: 2)),
      ),
      child: Row(
        children: items.map((item) {
          final (icon, label, active) = item;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (active)
                  Container(height: 3, width: 32, color: AppColors.accent),
                const SizedBox(height: 4),
                Icon(icon, size: 20,
                    color: active ? AppColors.accentD : AppColors.textSecondary),
                Text(label,
                    style: TextStyle(
                      fontSize: 10,
                      color: active ? AppColors.accentD : AppColors.textSecondary,
                    )),
              ],
            ),
          );
        }).toList(),
      ),
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