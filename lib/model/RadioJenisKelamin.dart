class RadioJenisKel {
  final int index;
  final String jenisKelamin;

  RadioJenisKel({this.index, this.jenisKelamin});
}

final List<RadioJenisKel> jenisKelaminChoice = [
  RadioJenisKel(
    index: 1,
    jenisKelamin: "Laki - Laki",
  ),
  RadioJenisKel(
    index: 2,
    jenisKelamin: "Perempuan",
  ),
];
