import 'package:flutter/material.dart';

// Care schedule screen - demonstrates calendar/schedule view
class CareScheduleScreen extends StatelessWidget {
  const CareScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Schedule'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today section
          const Text(
            'Today',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ScheduleCard(
            plantName: 'Monstera "Monty"',
            task: 'Water',
            time: '10:00 AM',
            icon: Icons.water_drop,
            color: Colors.blue,
            isCompleted: false,
          ),
          const SizedBox(height: 12),
          _ScheduleCard(
            plantName: 'Peace Lily "Lily"',
            task: 'Check soil',
            time: '2:00 PM',
            icon: Icons.touch_app,
            color: Colors.orange,
            isCompleted: true,
          ),
          const SizedBox(height: 24),

          // Tomorrow section
          const Text(
            'Tomorrow',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ScheduleCard(
            plantName: 'Pothos "Patty"',
            task: 'Water',
            time: '9:00 AM',
            icon: Icons.water_drop,
            color: Colors.blue,
            isCompleted: false,
          ),
          const SizedBox(height: 24),

          // This week section
          const Text(
            'This Week',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _ScheduleCard(
            plantName: 'Aloe Vera "Allie"',
            task: 'Water',
            time: 'Friday',
            icon: Icons.water_drop,
            color: Colors.blue,
            isCompleted: false,
          ),
          const SizedBox(height: 12),
          _ScheduleCard(
            plantName: 'Fiddle Leaf Fig "Figgy"',
            task: 'Fertilize',
            time: 'Saturday',
            icon: Icons.science,
            color: Colors.green,
            isCompleted: false,
          ),
        ],
      ),
    );
  }
}

// Schedule card widget
class _ScheduleCard extends StatefulWidget {
  final String plantName;
  final String task;
  final String time;
  final IconData icon;
  final Color color;
  final bool isCompleted;

  const _ScheduleCard({
    required this.plantName,
    required this.task,
    required this.time,
    required this.icon,
    required this.color,
    required this.isCompleted,
  });

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.color.withOpacity(0.2),
          child: Icon(widget.icon, color: widget.color),
        ),
        title: Text(
          widget.plantName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: _isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${widget.task} • ${widget.time}'),
        trailing: Checkbox(
          value: _isCompleted,
          onChanged: (value) {
            setState(() {
              _isCompleted = value ?? false;
            });
            if (_isCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.task} completed! ✓'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
