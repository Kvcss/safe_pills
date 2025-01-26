import 'package:flutter/material.dart';

import 'package:safe_pills/repository/entity/pills_entity.dart';
import 'package:safe_pills/utils/addPill.dart';
import 'package:safe_pills/screen/homeViewModel.dart';


class HomeView extends StatefulWidget {
  final PillsViewModel viewModel;

  const HomeView({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<List<PillsEntity>>(
                stream: widget.viewModel.pillsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum medicamento cadastrado.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  } else {
                    final pills = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Atrasados:'),
                          ...pills.where((pill) {
                            // Implementar lógica para filtrar atrasados
                            // Exemplo: Se o horário atual passou do horário de tomar o remédio
                            TimeOfDay now = TimeOfDay.now();
                            TimeOfDay pillTime = _parseTime(pill.time);
                            return _isTimePassed(now, pillTime);
                          }).map((pill) => _buildPillCard(pill, Colors.red)),
                          const SizedBox(height: 20),
                          _sectionTitle('Consumidos:'),
                          ...pills.where((pill) {
                            // Implementar lógica para filtrar consumidos
                            // Exemplo: Se o horário atual não passou do horário de tomar o remédio
                            TimeOfDay now = TimeOfDay.now();
                            TimeOfDay pillTime = _parseTime(pill.time);
                            return !_isTimePassed(now, pillTime);
                          }).map((pill) => _buildPillCard(pill, Colors.green)),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  TimeOfDay _parseTime(String time) {
    // Assume que o tempo está no formato 'HH:MM'
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  bool _isTimePassed(TimeOfDay now, TimeOfDay pillTime) {
    if (now.hour > pillTime.hour) return true;
    if (now.hour == pillTime.hour && now.minute > pillTime.minute) return true;
    return false;
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF2B998B),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(43, 153, 139, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/safe_pill_logo2.png',
                      height: 50,
                      width: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Safe Pills',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPillView(viewModel: widget.viewModel),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Atualizar a data dinamicamente
          Text(
            '${_getWeekday(DateTime.now().weekday)}, ${_formatDate(DateTime.now())}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];
    return weekdays[weekday - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2B998B),
        ),
      ),
    );
  }

  Widget _buildPillCard(PillsEntity pill, Color priorityColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: Container(
          width: 12,
          height: 60,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          pill.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosagem: ${pill.dosage}'),
            Text('Descrição: ${pill.description}'),
            Text('Duração: ${pill.duration}'),
            Text('Prioridade: ${pill.priority}'),
          ],
        ),
        trailing: Text(
          pill.time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          // Implementar lógica de detalhes/edição
          _showEditPillDialog(pill);
        },
        onLongPress: () {
          // Implementar lógica para excluir
          _confirmDelete(pill.id!);
        },
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir este medicamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              widget.viewModel.deletePill(id);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditPillDialog(PillsEntity pill) {
    // Implementar a lógica de edição de medicamento
    // Você pode criar uma tela similar à AddPillView ou usar um Dialog
    // Para simplicidade, deixaremos essa implementação para você
    // Exemplo:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPillView(
          viewModel: widget.viewModel,
          existingPill: pill,
        ),
      ),
    );
  }
}
