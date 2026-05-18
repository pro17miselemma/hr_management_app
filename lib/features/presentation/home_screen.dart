import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/employee_card.dart';
import '../../core/providers/employee_provider.dart';
import '../../core/models/employee_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text(
          'Team Members',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<EmployeeProvider>().fetchEmployees(),
          ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.employees.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (provider.error != null && provider.employees.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => provider.fetchEmployees(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.employees.isEmpty) {
            return const Center(child: Text('No employees found'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchEmployees(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: provider.employees.length,
              itemBuilder: (context, index) {
                final employee = provider.employees[index];
                return Dismissible(
                  key: Key(employee.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent.shade100,
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    provider.deleteEmployee(employee.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${employee.firstName} deleted')),
                    );
                  },
                  child: EmployeeCard(
                    employee: employee,
                    onPressed: () {
                      context.push('/employee/${employee.id}', extra: employee);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEmployeeDialog(context),
        label: const Text('Add Member'),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Team Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (firstNameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                final success = await context.read<EmployeeProvider>().addEmployee(
                  firstNameController.text,
                  lastNameController.text,
                  emailController.text,
                );
                if (success) {
                  if (mounted) Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}