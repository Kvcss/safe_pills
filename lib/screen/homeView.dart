import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:safe_pills/repository/entity/pills_entity.dart';
import 'package:safe_pills/screen/homeViewModel.dart';


class HomeView extends StatefulWidget {
  final PillsViewModel viewModel;

  const HomeView({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchAllPills(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Fundo claro
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
                            // Filtrar atrasados (implemente sua lógica)
                            return true;
                          }).map((pill) => _buildPillCard(pill, Colors.red)),
                          const SizedBox(height: 20),
                          _sectionTitle('Consumidos:'),
                          ...pills.where((pill) {
                            // Filtrar consumidos (implemente sua lógica)
                            return false;
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

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 24), // Mais espaçamento no topo
      decoration: const BoxDecoration(
        color: Color(0xFF2B998B), // Cor principal do app
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/safe_pill_logo.png',
                      height: 50,
                      width: 50,
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
                  // Implementar lógica para adicionar medicamento
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Segunda-feira, 27/01/2024',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
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
        subtitle: Text(
          'Prioridade: ${pill.priority}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Text(
          pill.time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: () {
          // Implementar lógica de detalhes/edição
        },
        onLongPress: () {
          // Implementar lógica para excluir
          widget.viewModel.deletePill(pill.id!);
        },
      ),
    );
  }
}
