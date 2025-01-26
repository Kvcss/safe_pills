import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safe_pills/repository/entity/pills_entity.dart';
import 'package:safe_pills/repository/pills_repository.dart';


class PillsViewModel {
  final IPillsRepository _pillsRepository;
  final StreamController<List<PillsEntity>> _pillsController = StreamController<List<PillsEntity>>.broadcast();

  PillsViewModel(this._pillsRepository) {
    _listenToPills();
  }

  Stream<List<PillsEntity>> get pillsStream => _pillsController.stream;

  void _listenToPills() {
    _pillsRepository.getPillsStream().listen((pills) {
      _pillsController.sink.add(pills);
    }, onError: (error) {
      _pillsController.sink.addError(error);
    });
  }

  Future<void> addPill(PillsEntity pill) async {
    try {
      await _pillsRepository.addPill(pill);
    } catch (e) {
      print('Erro ao adicionar medicamento: $e');
      _pillsController.sink.addError('Erro ao adicionar medicamento: $e');
    }
  }

  Future<void> updatePill(String id, PillsEntity pill) async {
    try {
      await _pillsRepository.updatePill(id, pill);
    } catch (e) {
      print('Erro ao atualizar medicamento: $e');
      _pillsController.sink.addError('Erro ao atualizar medicamento: $e');
    }
  }

  Future<void> deletePill(String id) async {
    try {
      await _pillsRepository.deletePill(id);
    } catch (e) {
      print('Erro ao deletar medicamento: $e');
      _pillsController.sink.addError('Erro ao deletar medicamento: $e');
    }
  }

  void dispose() {
    _pillsController.close();
  }
}