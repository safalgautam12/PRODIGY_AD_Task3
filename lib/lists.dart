// Purpose: This file contains the Lists class which is used to create lists of hours and minutes for the time picker.
class Lists {
  List<int> hour = [];
  List<int> minutes = [];
  List<int> seconds = [];
  Lists() {
    for (int i = 0; i < 99; i++) {
      hour.add(i);
    }
    for (int i = 0; i < 60; i++) {
      minutes.add(i);
      seconds.add(i);
    }
  }
}
