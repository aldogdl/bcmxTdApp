class TdEntity {

  String _username;
  String _nombreCliente;
  String _nombreEmpresa;
  String _giro;
  String _queVende;
  String _domicilio;
  String _referencias;
  String _email;
  bool   _requireFac;
  String _whatsapp;
  String _telfijo;
  List<Map<String, dynamic>> _lstLinks = new List();
  List<Map<String, dynamic>> _lstFotos = new List();
  String _descriptLogo;
  String _colorFondo;
  String _colorTexto;
  String _colorIconos;
  String _notasAdds;
  double _costo;
  int _franq;
  int _scat;
  String _div;

  void dispose() {
    this._username = null;
    this._nombreCliente = null;
    this._nombreEmpresa = null;
    this._giro = null;
    this._queVende = null;
    this._domicilio = null;
    this._referencias = null;
    this._email = null;
    this._requireFac = null;
    this._whatsapp = null;
    this._telfijo = null;
    this._descriptLogo = null;
    this._colorFondo = null;
    this._colorTexto = null;
    this._colorIconos = null;
    this._notasAdds = null;
    this._lstLinks = new List();
    this._lstFotos = new List();
    this._costo = null;
    this._franq = null;
    this._scat = null;
    this._div = null;
  }

  void setUsername(String username) => this._username = username;
  get username => this._username;

  void setNombreCliente(String nombreCliente) => this._nombreCliente = nombreCliente;
  get nombreCliente => this._nombreCliente;

  void setNombreEmpresa(String nombreEmpresa) => this._nombreEmpresa = nombreEmpresa;
  get nombreEmpresa => this._nombreEmpresa;

  void setGiro(String giro) => this._giro = giro;
  get giro => this._giro;

  void setQueVende(String queVende) => this._queVende = queVende;
  get queVende => this._queVende;

  void setDomicilio(String domicilio) => this._domicilio = domicilio;
  get domicilio => this._domicilio;

  void setReferencias(String referencias) => this._referencias = referencias;
  get referencias => this._referencias;

  void setEmail(String email) => this._email = email;
  get email => this._email;

  void setRequireFac(bool requireFac) => this._requireFac = requireFac;
  get requireFac => this._requireFac;

  void setWhatsapp(String whatsapp) => this._whatsapp = whatsapp;
  get whatsapp => this._whatsapp;

  void setTelFiijo(String telFijo) => this._telfijo = telFijo;
  get telFijo => this._telfijo;

  get lstLink => this._lstLinks;
  void resetLstLink() =>  this._lstLinks = new List();
  Future<void> setAllLink(List<Map<String, dynamic>> links) async {
    for (var i = 0; i < links.length; i++) {
      addLink(await _minimizarLstLinks(links[i]));
    }
  }
  void addLink(Map<String, dynamic> link) => this._lstLinks.add(link);
  Map<String, dynamic> getLinkBy(String campo) {
    if(this._lstLinks.isNotEmpty) {
      int index = this._lstLinks.indexWhere((element) {
        return (element['value'] == campo);
      });
      if(index > -1) {
      return this._lstLinks[index];
      }
    }
    return new Map();
  }

  get lstFotos => this._lstFotos;
  Future<void> setAllFotos(List<Map<String, dynamic>> fotos) async {
    this._lstFotos = fotos;
  }
  void setDescriptLogo(String descriptLogo) => this._descriptLogo = descriptLogo;
  get descriptLogo => this._descriptLogo;

  void setColorFondo(String colorFondo) => this._colorFondo = colorFondo;
  get colorFondo => this._colorFondo;

  void setColorTexto(String colorTexto) => this._colorTexto = colorTexto;
  get colorTexto => this._colorTexto;

  void setColorIconos(String colorIconos) => this._colorIconos = colorIconos;
  get colorIconos => this._colorIconos;

  void setNotasAdds(String notasAdds) => this._notasAdds = notasAdds;
  get notasAdds => this._notasAdds;

  double get costo => this._costo;
  void setCosto(double costo) => this._costo = costo;

  int get franquicia => this._franq;
  void setFranquicia(int franq) => this._franq = franq;

  int get scat => this._scat;
  void setSubCat(int scat) => this._scat = scat;

  String get div => this._div;
  void setDivision(String div) => this._div = div;

  ///
  Future<Map<String, dynamic>> _minimizarLstLinks(Map<String, dynamic> links) async {
    return {
      'value'     : links['value'],
      'urlCliente': links['urlCliente'],
      'select'    : links['select']
    };
  }

  ///
  List<Map<String, dynamic>> mapDataContac() {
    return [
      {
        'campo' : 'username',
        'subTit': 'Nombre de Usuario'
      },
      {
        'campo' : 'nombreCliente',
        'subTit': 'Nombre del Cliente'
      },      
      {
        'campo' : 'nombreEmpresa',
        'subTit': 'Nombre de la Empresa'
      },
      {
        'campo' : 'giro',
        'subTit': 'Giro de la Empresa'
      },
      {
        'campo' : 'queVende',
        'subTit': 'El negocio vende...'
      },
      {
        'campo' : 'domicilio',
        'subTit': 'Domicilio del Negocio'
      },
      {
        'campo' : 'referencias',
        'subTit': 'Referencias de Ubicación'
      },
      {
        'campo' : 'email',
        'subTit': 'Email del contacto'
      },
      {
        'campo' : 'requireFac',
        'subTit': 'La Empresa requiere factura'
      },
    ];
  }

  ///
  List<Map<String, dynamic>> mapDataLinks() {
    return [
      {
        'campo' : 'whatsapp',
        'subTit': 'Número de Whatsapp'
      },
      {
        'campo' : 'telfijo',
        'subTit': 'Teléfono Fijo'
      },
      {
        'campo' : 'lstLinks',
        'subTit': 'Links de Contacto'
      },
    ];
  }

  ///
  List<Map<String, dynamic>> mapDataDisenio() {
    return [
      {
        'campo' : 'descriptLogo',
        'subTit': 'Descripción para el Logotipo'
      },
      {
        'campo' : 'colorFondo',
        'subTit': 'Color para el Fondo'
      },
      {
        'campo' : 'colorTexto',
        'subTit': 'Color para el Texto'
      },
      {
        'campo' : 'colorIconos',
        'subTit': 'Colores para los Iconos'
      },
      {
        'campo' : 'notasAdds',
        'subTit': 'Notas Adicionales'
      },
    ];
  }

  ///
  List<Map<String, dynamic>> mapDataGenerales() {
    return [
      {
        'campo' : 'costo',
        'subTit': 'Costo de Servicio Final'
      },
      {
        'campo' : 'franq',
        'subTit': 'Negocio perteneciente a.'
      },
      {
        'campo' : 'scat',
        'subTit': 'PRINCIPAL Sub Categoría'
      },
      {
        'campo' : 'div',
        'subTit': 'SECUNDARIA Sub Categoría'
      },
    ];
  }

}