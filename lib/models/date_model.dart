class DateModel {
  String weekDay;
  String date;

  DateModel({required this.weekDay, required this.date});
}

void main() {
  // Tentukan tanggal awal untuk minggu ini
  DateTime now = DateTime.now();
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

  // Buat list dari tanggal-tanggal yang sesuai untuk minggu ini
  List<DateModel> dates = [];
  for (int i = 0; i < 7; i++) {
    DateTime currentDate = startOfWeek.add(Duration(days: i));
    String weekDay = _getWeekDay(currentDate.weekday);
    String date = currentDate.day.toString();
    dates.add(DateModel(weekDay: weekDay, date: date));
  }

  // Tampilkan tanggal-tanggal
  dates.forEach((date) {
    print('${date.weekDay}, ${date.date}');
  });
}

// Fungsi untuk mengembalikan nama hari berdasarkan nomor hari dalam seminggu
String _getWeekDay(int weekDay) {
  switch (weekDay) {
    case 1:
      return 'Sun';
    case 2:
      return 'Mon';
    case 3:
      return 'Tue';
    case 4:
      return 'Wed';
    case 5:
      return 'Thu';
    case 6:
      return 'Fri';
    case 7:
      return 'Sat';
    default:
      return '';
  }
}



