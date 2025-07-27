// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:family_tree/adminpanel/viewlogs/cubit/viewlogs_cubit.dart';

// class ViewLogScreen extends StatefulWidget {
//   const ViewLogScreen({super.key});

//   @override
//   State<ViewLogScreen> createState() => _ViewLogScreenState();
// }

// class _ViewLogScreenState extends State<ViewLogScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ViewlogsCubit>().viewUserLogs();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('User Logs')),
//       body: BlocConsumer<ViewlogsCubit, ViewlogsState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           if (state is ViewlogsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is ViewlogsErrorState) {
//             return Center(child: Text(state.errorMessage));
//           } else if (state is ViewlogsSuccess) {
//             final viewLogs = state.viewLogs;
//             if (viewLogs.isEmpty) {
//               return const Center(child: Text('No users found.'));
//             }

//             return ListView.builder(
//               itemCount: viewLogs.length,
//               itemBuilder: (context, index) {
//                 final user = viewLogs[index];

//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: SwitchListTile(
//                     title: Text(user.email),
//                     value: user.isActive ?? true,
//                     onChanged: (bool newValue) {
//                       context
//                           .read<ViewlogsCubit>()
//                           .toggleUserActiveStatusByEmail(
//                             email: user.email,
//                             isActive: newValue,
//                           );
//                     },
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const SizedBox.shrink();
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/adminpanel/viewlogs/cubit/viewlogs_cubit.dart';

class ViewLogScreen extends StatefulWidget {
  const ViewLogScreen({super.key});

  @override
  State<ViewLogScreen> createState() => _ViewLogScreenState();
}

class _ViewLogScreenState extends State<ViewLogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ViewlogsCubit>().viewUserLogs();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.userLogs,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ViewlogsCubit, ViewlogsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ViewlogsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ViewlogsErrorState) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is ViewlogsSuccess) {
              final viewLogs = state.viewLogs;

              if (viewLogs.isEmpty) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noUserFound,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                itemCount: viewLogs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = viewLogs[index];

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: isWide ? 4 : 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.isActive == true
                                      ? AppLocalizations.of(
                                          context,
                                        )!.statusActive
                                      : AppLocalizations.of(
                                          context,
                                        )!.statusInActive,
                                  style: TextStyle(
                                    color: user.isActive == true
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Switch.adaptive(
                            value: user.isActive ?? true,
                            onChanged: (bool newValue) {
                              context
                                  .read<ViewlogsCubit>()
                                  .toggleUserActiveStatusByEmail(
                                    email: user.email,
                                    isActive: newValue,
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
