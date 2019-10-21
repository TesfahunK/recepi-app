class Ingridient {
  String name;
  String amount;
  Ingridient(this.name, this.amount);
  Ingridient.fromJson(Map ingrid) {
    this.amount = ingrid['amount'];
    this.name = ingrid['name'];
  }

  Map<String, String> toMap(Ingridient data) {
    return {"name": data.name, "amount": data.amount};
  }
}
