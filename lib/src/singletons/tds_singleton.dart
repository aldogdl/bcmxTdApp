import '../entity/td_entity.dart';

/// Damos de alta una nueva tarjeta con este singleton.
class TdsSingleton {

  static TdsSingleton _tdsSng = TdsSingleton._();
  TdsSingleton._();
  factory TdsSingleton() {
    if(_tdsSng == null) {
      return TdsSingleton._();
    }
    return _tdsSng;
  }

  TdEntity tdEntity = TdEntity();
  int idUser = 0;
  int idTd = 0;
  int idDisenio = 0;
  bool isEdit = false;
  Map<String, dynamic> _dataTd = new Map();
  Map<String, dynamic> get dataTd => this._dataTd;
  void setDataTd(Map<String, dynamic> dataTd) => this._dataTd = dataTd;

  ///
  void dispose() {
    idUser = 0;
    idTd = 0;
    idDisenio = 0;
    this._dataTd = new Map();
    tdEntity.dispose();
  }

  ///
  String get getUsername => this._dataTd['username'];

  ///
  Map<String, dynamic> toJsonDataUser() {
    return {
      'username'     : this._dataTd['username'],
      'nombreCliente': this._dataTd['nombreCliente'],
      'whatsapp' : this._dataTd['whatsapp'],
      'telfijo'  : this._dataTd['telfijo'],
    };
  }

  ///
  void setDataContac(TdEntity tdEntity) {
    this._dataTd['username']      = tdEntity.username;
    this._dataTd['nombreCliente'] = tdEntity.nombreCliente;
    this._dataTd['nombreEmpresa'] = tdEntity.nombreEmpresa;
    this._dataTd['giro']          = tdEntity.giro;
    this._dataTd['queVende']      = tdEntity.queVende;
    this._dataTd['domicilio']     = tdEntity.domicilio;
    this._dataTd['referencias']   = tdEntity.referencias;
    this._dataTd['email']         = tdEntity.email;
    this._dataTd['requireFac']    = tdEntity.requireFac;
  }

  ///
  Map<String, dynamic> toJsonDataContac() {
    return {
      'idUser'       : idUser,
      'username'     : this._dataTd['username'],
      'nombreCliente': this._dataTd['nombreCliente'],
      'nombreEmpresa': this._dataTd['nombreEmpresa'],
      'giro'         : this._dataTd['giro'],
      'queVende'     : this._dataTd['queVende'],
      'domicilio'    : this._dataTd['domicilio'],
      'referencias'  : this._dataTd['referencias'],
      'email'        : this._dataTd['email'],
      'requireFac'   : this._dataTd['requireFac']
    };
  }

  ///
  void setDataLinks(TdEntity tdEntity) {
    this._dataTd['whatsapp'] = tdEntity.whatsapp;
    this._dataTd['telfijo']  = tdEntity.telFijo;
    this._dataTd['lstLinks'] = tdEntity.lstLink;
  }

  ///
  Map<String, dynamic> toJsonDataLinks() {
    return {
      'whatsapp' : this._dataTd['whatsapp'],
      'telfijo'  : this._dataTd['telfijo'],
      'lstLinks' : this._dataTd['lstLinks'],
    };
  }
  
  ///
  Map<String, dynamic> toJsonDataGenerales() {
    return {
      'costo': this._dataTd['costo'],
      'franq': this._dataTd['franq'],
      'scat' : this._dataTd['scat'],
      'div'  : this._dataTd['div'],
    };
  }

  ///
  List<Map<String, dynamic>> get lstFotos {
    if(this._dataTd['lstFotos'] == null){
      return new List();
    }
    if(this._dataTd['lstFotos'].isEmpty){
      return new List();
    }

    return new List<Map<String, dynamic>>.from(this._dataTd['lstFotos']);
  }
  
  ///
  void setAllfotos(TdEntity tdEntity) {
    this._dataTd['lstFotos'] = tdEntity.lstFotos;
  }

  ///
  Future<bool> deleteFotoById(String id) async {
    List<Map<String, dynamic>> fotos = List<Map<String, dynamic>>.from(this._dataTd['lstFotos']);
    int cantAct = fotos.length;

    if(cantAct > 0) {
      fotos.removeWhere((foto) => (foto['id'] == id));
      this._dataTd['lstFotos'] = fotos;
    }
    return (cantAct != fotos.length) ? true : false;
  }

  ///
  void setDataDisenio(TdEntity tdEntity) {
    this._dataTd['descriptLogo']= tdEntity.descriptLogo;
    this._dataTd['colorFondo']  = tdEntity.colorFondo;
    this._dataTd['colorTexto']  = tdEntity.colorTexto;
    this._dataTd['colorIconos'] = tdEntity.colorIconos;
    this._dataTd['notasAdds']   = tdEntity.notasAdds;
  }

  ///
  void setDataFranqCostoCategos(TdEntity tdEntity) {
    this._dataTd['costo']= tdEntity.costo;
    this._dataTd['franq']  = tdEntity.franquicia;
    this._dataTd['scat']  = tdEntity.scat;
    this._dataTd['div'] = tdEntity.div;
  }

  ///
  Map<String, dynamic> toJsonDataDisenio() {
    return {
      'descriptLogo': this._dataTd['descriptLogo'],
      'colorFondo'  : this._dataTd['colorFondo'],
      'colorTexto'  : this._dataTd['colorTexto'],
      'colorIconos' : this._dataTd['colorIconos'],
      'notasAdds'   : this._dataTd['notasAdds'],
    };
  }
}