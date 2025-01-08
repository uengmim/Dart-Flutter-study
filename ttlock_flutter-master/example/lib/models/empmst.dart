class Empmst {
  final String empno;
  final String deptid;
  final String empnm;
  final String pin;

  Empmst({
    required this.empno,
    required this.deptid,
    required this.empnm,
    required this.pin,
  });

  // JSON to Empmst mapping
  factory Empmst.fromJson(Map<String, dynamic> json) {
    return Empmst(
      empno: json['EMPNO'],
      deptid: json['DEPTID'],
      empnm: json['EMPNM'],
      pin: json['PIN'],
    );
  }
}
