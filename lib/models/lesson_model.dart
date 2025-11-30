class LessonModel {
  final int id;
  final String title; // عنوان درس
  final String imageAsset; // مسیر تصویر درس (اختیاری)

  // محتوای بخش‌های مختلف
  final List<QnA> activities; // جواب فعالیت‌ها
  final List<QnA> worksheets; // جواب کاربرگ‌ها
  final List<String> notes; // نکات مهم درس
  final List<QnA> textQuestions; // سوالات متن درس

  LessonModel({
    required this.id,
    required this.title,
    this.imageAsset = 'assets/images/placeholder.png',
    required this.activities,
    required this.worksheets,
    required this.notes,
    required this.textQuestions,
  });
}

// کلاس کمکی برای پرسش و پاسخ
class QnA {
  final String question;
  final String answer;

  QnA({required this.question, required this.answer});
}
