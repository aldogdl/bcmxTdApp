class FranqCatsSng {

  static FranqCatsSng _franqsCatsSng = FranqCatsSng._();
  FranqCatsSng._();
  factory FranqCatsSng() {
    return _franqsCatsSng;
  }

  int _franqSelect = 0;
  List<Map<String, dynamic>> _franquicias = new List();
  List<Map<String, dynamic>> _categos = new List();
  List<Map<String, dynamic>> _subCategos = new List();

  int get franqSelect => this._franqSelect;
  setFranqSelect(int fs) => this._franqSelect = fs;
  
  List<Map<String, dynamic>> get franquicias => this._franquicias;
  setFranquicias(List<Map<String, dynamic>> franqs) => this._franquicias = franqs;

  List<Map<String, dynamic>> get categos => this._categos;
  setCategos(List<Map<String, dynamic>> categos) => this._categos = categos;

  List<Map<String, dynamic>> get subCategos => this._subCategos;
  setSubCategos(List<Map<String, dynamic>> subCategos) => this._subCategos.addAll(subCategos);

}