

/// En listamos las tarjetas que se encuentran con la busqueda en index
class LstTdsSingleton {

  static LstTdsSingleton _lstTdsSng = LstTdsSingleton._();
  LstTdsSingleton._();
  factory LstTdsSingleton() {
    return _lstTdsSng;
  }

  List<Map<String, dynamic>> lstTds = new List();
  
}