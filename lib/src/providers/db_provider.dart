import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  //patron singleton
  /*creamos una instancia única a nivel global dentro de la aplicación*/

  static Database _database;//instancia de la bd
  static final DBProvider db = DBProvider._();

  DBProvider._();//constructor privado

  Future<Database> get database async {

    if (_database != null) return _database;

    //si la bd no esta creada llamamos metodo initDB
    _database = await initDB();

    return _database;
  }

  /*create table y database*/
  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute(
          'CREATE TABLE Scans ( '
          ' id INTEGER PRIMARY KEY, '
          ' tipo TEXT, '
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  //metodos crear registros en bd
  nuevoScanRaw( ScanModel nuevoScan ) async {

    final db = await database;

    //proceso de inserción
    final res = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );

    return res;
  }

  nuevoScan( ScanModel nuevoScan ) async {

    final db = await database;
    final res =  await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT - Obtener Información desde la BD
  Future<ScanModel> getScanId( int id ) async {

    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;

  }

  Future<List<ScanModel>> getTodosScans() async{

    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty 
                           ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                           : [];

    return list;
  }

  Future<List<ScanModel>> getScansPorTipo( String tipo ) async{

    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list = res.isNotEmpty 
                           ? res.map( (c) => ScanModel.fromJson(c) ).toList()
                           : [];

    return list;
  }

  //actualizar registros 
  Future<int> updateScan( ScanModel nuevoScan ) async {
    final db = await database;

    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    
    return res;
  }

  //Borrar registros
  Future<int> deleteScan (int id) async {

    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;

  }

  Future<int> deleteScanAll () async {

    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');

    return res;

  }

}