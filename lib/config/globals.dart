library bcmxtds.globals;

const String env = 'prod';
const String version = '1.2.0';

const String protocolo         = (env == 'dev') ? 'http://' : 'https://';
const String base              = (env == 'dev') ? '192.168.0.4:8000' : 'dbzm.info';
const String dominio           = '$protocolo$base';
const String uriBaseDb         = '$dominio/';
const String uriBaseTdPdf      = 'https://buscomex.com/tds';