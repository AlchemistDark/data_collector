class Session{
  final String number;
  final Gender gender;
  final PhoneModel phoneModel;
  final Distance distance;
  final MatrixSize size;
  final double screenTime;
  final double photoTime;
  final bool? showBackground;
  final bool? autoFocusEnable;

  Session(
    this.number,
    this.gender,
    this.phoneModel,
    this.distance,
    this.size,
    this.screenTime,
    this.photoTime,
    this.showBackground,
    this.autoFocusEnable
  );
}

enum Gender {male, female}

enum Distance {x15, x30}
enum MatrixSize {x5x7, x7x10, x9x13}

enum PhoneModel {redmy, sony, samsung}