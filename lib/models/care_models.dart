class Medicine {
  Medicine(this.name, this.dose, this.time, this.instructions, {this.taken = false});
  String name, dose, time, instructions;
  bool taken;
}

class Appointment {
  Appointment(this.name, this.date, this.time, this.place, this.doctor, {this.attended = false});
  String name, date, time, place, doctor;
  bool attended;
}
