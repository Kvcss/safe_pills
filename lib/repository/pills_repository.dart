import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_pills/repository/entity/pills_entity.dart';


abstract class IPillsRepository {
  Future<void> addPill(PillsEntity pill);
  Future<List<PillsEntity>> getAllPills();
  Future<void> updatePill(String id, PillsEntity pill);
  Future<void> deletePill(String id);
}


// Implementação do repositório
class PillsRepository implements IPillsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> addPill(PillsEntity pill) async {
    try {
      await _db.collection('pills').add(pill.toMap());
      print('Medicamento adicionado com sucesso!');
    } catch (e) {
      throw Exception('Erro ao adicionar medicamento: $e');
    }
  }

  @override
  Future<List<PillsEntity>> getAllPills() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('pills').get();
      return querySnapshot.docs
          .map((doc) => PillsEntity.fromMap(doc.data() as Map<String, dynamic>)
            ..id = doc.id) // Inclui o ID do documento no objeto
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar medicamentos: $e');
    }
  }

  @override
  Future<void> updatePill(String id, PillsEntity pill) async {
    try {
      await _db.collection('pills').doc(id).update(pill.toMap());
      print('Medicamento atualizado com sucesso!');
    } catch (e) {
      throw Exception('Erro ao atualizar medicamento: $e');
    }
  }

  @override
  Future<void> deletePill(String id) async {
    try {
      await _db.collection('pills').doc(id).delete();
      print('Medicamento deletado com sucesso!');
    } catch (e) {
      throw Exception('Erro ao deletar medicamento: $e');
    }
  }
}