class Session{
  final int number;
  final double screenTime;
  final double photoTime;

  Session(
    this.number,
    [this.screenTime = 2.0,
    this.photoTime = 0.25]
  );
}
