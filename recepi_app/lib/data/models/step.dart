class RecepiStep {
  String header;
  String description;
  RecepiStep(this.header, this.description);
  RecepiStep.fromJson(Map step) {
    this.header = step['header'];
    this.description = step['description'];
  }

  Map<String, String> toMap(RecepiStep data) {
    return {"header": data.header, "description": data.description};
  }
}
