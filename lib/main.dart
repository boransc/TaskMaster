import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/models/task_model.dart';
import 'screens/game_screen.dart';
import 'screens/productivity_mode_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/task_screen.dart';
import '/services/notification_service.dart';
import 'screens/statistics_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/services/firebase_env_options.dart';
import '/services/firebase_options.dart';
import 'screens/welcome_screen.dart';

enum AppTheme { light, dark, highContrast, redBlack, redWhite, yellowBlack, yellowWhite }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');
  await NotificationService.initialise();
  await dotenv.load(fileName: "assets/.env");
  // Load .env
  await Firebase.initializeApp(
    options: EnvFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(home: WelcomeScreen()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  AppTheme selectedTheme = AppTheme.light;

  @override
  void initState() {
    super.initState();
    loadThemePreference();
    //clear local saved tasks for testing
    //Hive.box<TaskModel>('tasks').clear();
  }

  //loading theme preferences from shared preferences
  void loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('theme') ?? 'light';
    setState(() {
      selectedTheme = AppTheme.values.firstWhere((e) => e.name == themeString, orElse: () => AppTheme.light);
    });
  }

  //saving themes to shared preferences
  void saveThemePreference(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme.name);
  }

  //gets the selected theme
  ThemeData getThemeData() {
    switch (selectedTheme) {
      case AppTheme.dark:return buildDarkTheme();
      case AppTheme.highContrast:return buildHighContrastTheme();
      case AppTheme.redBlack:return buildRedBlackTheme();
      case AppTheme.yellowBlack:return buildYellowBlackTheme();
      case AppTheme.yellowWhite:return buildYellowWhiteTheme();
      case AppTheme.redWhite:return buildRedWhiteTheme();
      case AppTheme.light:return buildLightTheme();
    }
  }

  //building the light theme
  ThemeData buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true, brightness: Brightness.light);
  }

//building the dark theme
  ThemeData buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark), useMaterial3: true, brightness: Brightness.dark);
  }

//building the high contrast theme
  ThemeData buildHighContrastTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white70,
      colorScheme: ColorScheme.highContrastLight(primary: Colors.black, secondary: Colors.yellow),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      visualDensity: VisualDensity.adaptivePlatformDensity
    );
  }

  //building the red and black theme
  ThemeData buildRedBlackTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.red), bodyMedium: TextStyle(color: Colors.red)),
      iconTheme: const IconThemeData(color: Colors.red),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black)
    );
  }

  //building the red and white theme
  ThemeData buildRedWhiteTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.light),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white70,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.red)),
      iconTheme: const IconThemeData(color: Colors.red),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white70)
    );
  }

  //building the yellow and black theme
  ThemeData buildYellowBlackTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow, brightness: Brightness.dark),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.yellow), bodyMedium: TextStyle(color: Colors.yellow)),
      iconTheme: const IconThemeData(color: Colors.yellow),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black)
    );
  }

  //building the yellow and white theme
  ThemeData buildYellowWhiteTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow, brightness: Brightness.light),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white70,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.yellow), bodyMedium: TextStyle(color: Colors.yellow)),
      iconTheme: const IconThemeData(color: Colors.yellow),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white70)
    );
  }

  //this builds the theme of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: getThemeData(),
      home: TaskManager(
        onThemeChanged: (theme) {setState(() {selectedTheme = theme;});saveThemePreference(theme);},
        selectedTheme: selectedTheme
      )
    );
  }
}

class TaskManager extends StatefulWidget {
  final Function(AppTheme) onThemeChanged;
  final AppTheme selectedTheme;

  const TaskManager({
    super.key,
    required this.onThemeChanged,
    required this.selectedTheme,
  });

  @override
  TaskManagerState createState() => TaskManagerState();
}
//task manager logic
class TaskManagerState extends State<TaskManager> {
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  int coins = 1000;
  String selectedPriority = 'Low Priority';
  String selectedRecurrence = 'None';
  DateTime? selectedDeadline;
  Duration selectedReminderOffset = const Duration(hours: 1);
  bool isTaskFormVisible = false;
  final Box<TaskModel> taskBox = Hive.box<TaskModel>('tasks');


  //adding task
  Future<void> addTask() async {
    if (taskController.text.isNotEmpty && selectedDeadline != null) {
      if (selectedPriority == 'High Priority' &&
          taskBox.values.where((task) => task.priority == 'High Priority').length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You cannot add more than 5 high priority tasks.')));
        return;
      }

      //creating a new task model object
      final newTask = TaskModel(
        title: taskController.text,
        description: descriptionController.text,
        completed: false,
        deadline: selectedDeadline!,
        priority: selectedPriority,
        recurrence: selectedRecurrence,
        reminderOffset: selectedReminderOffset
      );

      //adding the taskmodel object
      await taskBox.add(newTask);

      //setting the state of the task creation form
      setState(() {
        taskController.clear();
        descriptionController.clear();
        selectedDeadline = null;
        selectedPriority = 'Low Priority';
        selectedRecurrence = 'None';
        isTaskFormVisible = false;
      });

      //scheduling the reminder
      await NotificationService.scheduleReminder(
        id: taskBox.length,
        title: 'Task Reminder: ${newTask.title}',
        body: 'Due at ${newTask.deadline}',
        scheduledDate: newTask.deadline.subtract(selectedReminderOffset)
      );
    }
  }

  //task logic
  Future<void> toggleTask(int index) async {
    final task = taskBox.getAt(index);
    if (task != null) {
      task.completed = !task.completed;
      await task.save();
      setState(() {coins += task.completed ? 10 : -10;});

      if (task.completed && task.recurrence != 'None') {
        Duration offset;
        switch (task.recurrence) {
          case 'Daily': offset = const Duration(days: 1); break;
          case 'Weekly': offset = const Duration(days: 7); break;
          case 'Monthly': offset = const Duration(days: 30); break;
          default: offset = Duration.zero;
        }

        final recurringTask = TaskModel(
          title: task.title,
          description: task.description,
          completed: false,
          deadline: task.deadline.add(offset),
          priority: task.priority,
          recurrence: task.recurrence,
          reminderOffset: task.reminderOffset
        );

        await taskBox.add(recurringTask);

        await NotificationService.scheduleReminder(
          id: taskBox.length,
          title: 'Task Reminder: ${recurringTask.title}',
          body: 'Due at ${recurringTask.deadline}',
          scheduledDate: recurringTask.deadline.subtract(selectedReminderOffset)
        );
      }
    }
  }

  //deleting the task
  Future<void> deleteTask(int index) async {
    await taskBox.deleteAt(index);
    setState(() {});
  }

  //picking the deadline
  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDeadline) {
      setState(() {selectedDeadline = picked;});
    }
  }

  //updating coins
  void onCoinsUpdated(int updatedCoins) {
    setState(() {coins = updatedCoins;});
  }

  //building the task screen ui
  Widget buildTaskScreen() => ValueListenableBuilder(
    valueListenable: taskBox.listenable(),
    builder: (context, Box<TaskModel> box,_) => TaskScreen(
      taskController: taskController,
      descriptionController: descriptionController,
      selectedPriority: selectedPriority,
      selectedDeadline: selectedDeadline,
      selectedReminderOffset: selectedReminderOffset,
      selectedRecurrence: selectedRecurrence,
      isTaskFormVisible: isTaskFormVisible,
      tasks: box.values.toList(),
      onToggleFormVisibility: () {
        setState(() {isTaskFormVisible = !isTaskFormVisible;});
      },
      onAddTask: addTask,
      onPriorityChanged: (value) {
        setState(() {selectedPriority = value!;});
      },
      onPickDeadline: () => pickDeadline(context),
      onReminderChanged: (value) {
        setState(() {selectedReminderOffset = value ?? const Duration(hours: 1);});
      },
      onRecurrenceChanged: (value) {
        setState(() {selectedRecurrence = value ?? 'None';});
      },
      onToggleTask: toggleTask,
      onDeleteTask: deleteTask
    )
  );

  //building calendar screen ui
  Widget buildCalendarScreen() => CalendarScreen(
    selectedDate: selectedDate,
    onDateSelected: (date) {
      setState(() {selectedDate = date;});
    },
    tasks: taskBox.values.toList(),
    onCompleteTask: toggleTask,
    onDeleteTask: deleteTask
  );

  //building game screen ui
  Widget buildGameScreen() => GameScreen(
    coins: coins,
    onCoinsUpdated: onCoinsUpdated
  );

  //building settings screen ui
  Widget buildSettingsScreen() => SettingsScreen(
    selectedTheme: widget.selectedTheme,
    onThemeChanged: widget.onThemeChanged
  );

  //building statistics screen
  Widget buildStatisticsScreen() => StatisticsScreen(tasks: taskBox.values.toList());

  @override
  void dispose() {
    taskController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.timer),
            tooltip: 'Enter Productivity Mode',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductivityModeScreen(onCoinsEarned: (earnedCoins) {setState(() {coins += earnedCoins;});}
                  )
                )
              );
            }
          )
        ]
      ),
      //navigation bar
      body: selectedIndex == 0 ? buildTaskScreen()
          : selectedIndex == 1 ? buildCalendarScreen()
          : selectedIndex == 2 ? buildGameScreen()
          : selectedIndex == 3 ? buildStatisticsScreen()
          : buildSettingsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {setState(() {selectedIndex = index;});},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Task Garden'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
      )
    );
  }
}
