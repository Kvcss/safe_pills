import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_pills/repository/entity/pills_entity.dart';
import 'package:safe_pills/screen/homeViewModel.dart';

class AddPillView extends StatefulWidget {
  final PillsViewModel viewModel;
  final PillsEntity? existingPill;

  const AddPillView({Key? key, required this.viewModel, this.existingPill}) : super(key: key);

  @override
  State<AddPillView> createState() => _AddPillViewState();
}

class _AddPillViewState extends State<AddPillView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  String _priority = 'Baixa';
  late TimeOfDay _selectedTime;
  late TextEditingController _descriptionController;
  DateTime? _startDate;
  DateTime? _endDate;

  bool get isEditing => widget.existingPill != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingPill?.name ?? '');
    _dosageController = TextEditingController(text: widget.existingPill?.dosage ?? '');
    _priority = widget.existingPill?.priority ?? 'Baixa';
    _selectedTime = widget.existingPill != null
        ? _parseTime(widget.existingPill!.time)
        : TimeOfDay.now();
    _descriptionController = TextEditingController(text: widget.existingPill?.description ?? '');

    if (isEditing) {
      final duration = widget.existingPill!.duration;
      final dates = duration.split(' - ');
      if (dates.length == 2) {
        _startDate = _parseDate(dates[0]);
        _endDate = _parseDate(dates[1]);
      }
    }
  }

  DateTime _parseDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parse(date);
    } catch (e) {
      return DateTime.now();
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) {
      return TimeOfDay.now();
    }
    return TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Cores principais e de destaque
    final Color primaryColor = const Color(0xFF2A998B);
    final Color secondaryColor = const Color(0xFF4DE1C1);

    return Scaffold(
      // AppBar com gradiente
      appBar: AppBar(
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          isEditing ? 'Editar Medicamento' : 'Adicionar Medicamento',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      // Fundo branco (sem gradiente)
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Nome do Medicamento',
                  icon: Icons.medication_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do medicamento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _dosageController,
                  label: 'Dosagem',
                  icon: Icons.scale,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a dosagem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildDateRangePicker(primaryColor, secondaryColor),
                const SizedBox(height: 20),
                _buildDropdownField(),
                const SizedBox(height: 20),
                _buildTimePicker(primaryColor, secondaryColor),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Descrição',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _buildSaveButton(primaryColor, secondaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF2A998B)),
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _priority,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.priority_high, color: Color(0xFF2A998B)),
          labelText: 'Prioridade',
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
        items: ['Baixa', 'Média', 'Alta'].map((String priority) {
          return DropdownMenuItem<String>(
            value: priority,
            child: Text(priority),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _priority = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, selecione a prioridade';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTimePicker(Color primaryColor, Color secondaryColor) {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.access_time, color: Color(0xFF2A998B)),
            labelText: 'Hora para Tomar',
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedTime.format(context),
                style: const TextStyle(fontSize: 16),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangePicker(Color primaryColor, Color secondaryColor) {
    return GestureDetector(
      onTap: _selectDateRange,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF2A998B)),
            labelText: 'Período de Uso',
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _startDate != null && _endDate != null
                    ? '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}'
                    : 'Selecione o período',
                style: TextStyle(
                  fontSize: 16,
                  color: _startDate != null && _endDate != null
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 365));
    final DateTime lastDate = now.add(const Duration(days: 365 * 5));

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xFF2A998B),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2A998B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2A998B),
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: const Color(0xFF2A998B),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2A998B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildSaveButton(Color primaryColor, Color secondaryColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _savePill,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ).copyWith(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          elevation: MaterialStateProperty.all<double>(4),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(minHeight: 48),
            child: Text(
              isEditing ? 'Atualizar' : 'Salvar',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _savePill() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione o período de uso'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      if (_startDate!.isAfter(_endDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A data de início deve ser antes da data de término'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      String formattedTime =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

      String formattedDuration =
          '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}';

      PillsEntity newPill = PillsEntity(
        id: widget.existingPill?.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        time: formattedTime,
        duration: formattedDuration,
        priority: _priority,
        description: _descriptionController.text,
      );

      if (isEditing) {
        await widget.viewModel.updatePill(newPill.id!, newPill);
      } else {
        await widget.viewModel.addPill(newPill);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Medicamento atualizado com sucesso!'
                : 'Medicamento adicionado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }
}
