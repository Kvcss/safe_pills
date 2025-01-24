import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safe_pills/repository/entity/pills_entity.dart';
import 'package:safe_pills/repository/pills_repository.dart';


class PillsViewModel {
  final IPillsRepository _pillsRepository;
  final StreamController<List<PillsEntity>> _pillsController = StreamController<List<PillsEntity>>.broadcast();

  PillsViewModel(this._pillsRepository);

  Stream<List<PillsEntity>> get pillsStream => _pillsController.stream;

 
  Future<void> addPill(PillsEntity pill) async {
    try {
      await _pillsRepository.addPill(pill);
      await fetchAllPills(); 
    } catch (e) {
      print('Erro ao adicionar medicamento: $e');
    }
  }


  Future<void> fetchAllPills() async {
    try {
      List<PillsEntity> pills = await _pillsRepository.getAllPills();
      _pillsController.sink.add(pills);
    } catch (e) {
      _pillsController.sink.addError('Erro ao buscar medicamentos: $e');
    }
  }

  
  Future<void> updatePill(String id, PillsEntity pill) async {
    try {
      await _pillsRepository.updatePill(id, pill);
      await fetchAllPills(); 
    } catch (e) {
      print('Erro ao atualizar medicamento: $e');
    }
  }

  
  Future<void> deletePill(String id) async {
    try {
      await _pillsRepository.deletePill(id);
      await fetchAllPills(); 
    } catch (e) {
      print('Erro ao deletar medicamento: $e');
    }
  }

  
  void dispose() {
    _pillsController.close();
  }
}
