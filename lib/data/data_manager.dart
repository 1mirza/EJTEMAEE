import '../models/lesson_model.dart';

// --- ایمپورت فایل‌های درس‌ها ---
import 'lesson_01.dart';
import 'lesson_02.dart';
import 'lesson_03.dart';
import 'lesson_04.dart';
import 'lesson_05.dart';
import 'lesson_06.dart';
import 'lesson_07.dart';
import 'lesson_08.dart';
import 'lesson_09.dart';
import 'lesson_10.dart';
import 'lesson_11.dart';
import 'lesson_12.dart';
import 'lesson_13.dart';
import 'lesson_14.dart';
import 'lesson_15.dart';
import 'lesson_16.dart';
import 'lesson_17.dart';
import 'lesson_18.dart';
import 'lesson_19.dart';
import 'lesson_20.dart';
import 'lesson_21.dart';
import 'lesson_22.dart';
import 'lesson_23.dart';

class DataManager {
  // لیست کل دروس کتاب اجتماعی ششم
  static final List<LessonModel> allLessons = [
    // درس ۱: دوستی
    lesson01,

    // درس ۲: آداب دوستی
    lesson02,

    // درس ۳: تصمیم‌گیری چیست؟
    lesson03,

    // درس ۴: چگونه تصمیم بگیریم؟
    lesson04,

    // درس ۵: عوامل مؤثر در کشاورزی
    lesson05,

    // درس ۶: محصولات کشاورزی از تولید تا مصرف
    lesson06,

    // درس ۷: طلای سیاه
    lesson07,

    // درس ۸: انرژی را بهتر مصرف کنیم
    lesson08,

    // درس ۹: پیشرفت‌های علمی مسلمانان
    lesson09,

    // درس ۱۰: چه عواملی موجب گسترش علوم و فنون در دوره اسلامی شد؟
    lesson10,

    // درس ۱۱: اصفهان نصف جهان
    lesson11,

    // درس ۱۲: چرا فرهنگ و هنر در دوره صفویه شکوفا شد؟
    lesson12,

    // درس ۱۳: برنامه روزانه متعادل
    lesson13,

    // درس ۱۴: برنامه‌ریزی برای اوقات فراغت
    lesson14,

    // درس ۱۵: انواع لباس
    lesson15,

    // درس ۱۶: لباس از تولید تا مصرف
    lesson16,

    // درس ۱۷: ویژگی‌های دریاهای ایران
    lesson17,

    // درس ۱۸: دریا نعمت خداوندی
    lesson18,

    // درس ۱۹: همسایگان ما
    lesson19,

    // درس ۲۰: استعمار چیست؟
    lesson20,

    // درس ۲۱: مبارزه مردم ایران با استعمار
    lesson21,

    // درس ۲۲: خرمشهر در چنگال دشمن
    lesson22,

    // درس ۲۳: خرمشهر در دامان میهن
    lesson23,
  ];

  // متد کمکی برای دریافت درس با شناسه (در صورت نیاز)
  static LessonModel getLessonById(int id) {
    return allLessons.firstWhere(
      (lesson) => lesson.id == id,
      orElse: () => lesson01,
    );
  }
}
