import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/edit_member.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/field_selection_dialog.dart';
import 'package:family_tree/adminpanel/member/presentation/widgets/generate_pdf.dart';
import 'package:family_tree/adminpanel/service/csv_dlowanload_service.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Timer? _debounce;
  String searchQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemberCubit, MemberState>(
      listener: (context, state) {},
      builder: (context, state) {
        final groupedData = context.read<MemberCubit>().getGroupedMembers();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.familyMembers,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.download),
                onSelected: (value) {
                  if (value == 'csv') {
                    downloadFamilyDataAsCSV(); // your CSV logic
                  } else if (value == 'pdf') {
                    showDialog(
                      context: context,
                      builder: (context) => FieldSelectionDialog(
                        onCreatePdf: (selectedFields) async {
                          // Example Firestore data (replace with your query)
                          final familyData = await fetchAllMembers();

                          await generateFamilyPdf(selectedFields, familyData);
                        },
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'csv',
                    child: Text('Download CSV'),
                  ),
                  const PopupMenuItem(
                    value: 'pdf',
                    child: Text('Download PDF'),
                  ),
                ],
              ),
            ],
            centerTitle: false,
            elevation: 0,
          ),
          body: groupedData.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/no_data.png',
                        width: 300,
                        height: 300,
                      ),
                      Text(
                        AppLocalizations.of(context)!.noGroupedMemberFound,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // SizedBox(height: 12),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: TextField(
                    //     onChanged: (value) {
                    //       if (_debounce?.isActive ?? false) _debounce!.cancel();

                    //       _debounce = Timer(
                    //         const Duration(milliseconds: 300),
                    //         () {
                    //           setState(() {
                    //             searchQuery = value;
                    //           });
                    //         },
                    //       );
                    //     },
                    //     decoration: InputDecoration(
                    //       prefixIcon: Icon(Icons.search),
                    //       hintText: 'Search by Name',
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: groupedData.entries.map((entry) {
                          final children = entry.value;

                          // Find the internal root member from the children list
                          final internalRoot = children.firstWhere(
                            (member) =>
                                member.parentId == null ||
                                member.parentId!.isEmpty,
                            orElse: () => children.first,
                          );

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            child: Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                childrenPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                leading: const Icon(Icons.account_tree_rounded),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${internalRoot.name}", // Show internal root name here
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.indigo,
                                      child: Text(
                                        children.length.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: children.map((member) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24.0,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                        leading: const Icon(
                                          Icons.person_outline,
                                          color: Colors.indigo,
                                        ),
                                        title: Text(
                                          member.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Edit button
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blueAccent,
                                              ),
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return Dialog(
                                                      insetPadding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 40,
                                                            vertical: 24,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                              maxWidth: 600,
                                                              maxHeight: 600,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .orangePrimary,
                                                                borderRadius:
                                                                    const BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                      topRight:
                                                                          Radius.circular(
                                                                            10,
                                                                          ),
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.fromLTRB(
                                                                      16,
                                                                      16,
                                                                      8,
                                                                      0,
                                                                    ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      AppLocalizations.of(
                                                                        context,
                                                                      )!.editMember,
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                      onPressed: () =>
                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop(),
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                padding:
                                                                    const EdgeInsets.all(
                                                                      16.0,
                                                                    ),
                                                                child:
                                                                    EditMemberScreen(
                                                                      member:
                                                                          member,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            // Delete button
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () async {
                                                final memberRef =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                          'family_members',
                                                        )
                                                        .doc(member.id);

                                                final memberSnapshot =
                                                    await memberRef.get();
                                                final memberData =
                                                    memberSnapshot.data();

                                                if (memberData == null) return;

                                                bool isRoot =
                                                    memberData['isRoot'] ??
                                                    false;
                                                print("IS INTERNAL ${isRoot}");
                                                // Step 1: Show different dialog message
                                                String message = isRoot
                                                    ? "You are about to delete the root member of your family. After deleting, it will affect your family organisation tree."
                                                    : "Are you sure you want to delete this member?";

                                                final confirm = await showDialog<bool>(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text(
                                                      "Confirm Delete",
                                                    ),
                                                    content: Text(message),
                                                    actions: [
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          shape: WidgetStatePropertyAll(
                                                            ContinuousRectangleBorder(
                                                              side: BorderSide(
                                                                color: AppColors
                                                                    .orangePrimary,
                                                              ),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                AppColors
                                                                    .orangePrimary,
                                                              ),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                              ctx,
                                                            ).pop(false),
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                AppColors
                                                                    .redPrimary,
                                                              ),
                                                          shape: WidgetStatePropertyAll(
                                                            ContinuousRectangleBorder(
                                                              side: BorderSide(
                                                                color: AppColors
                                                                    .redPrimary,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.of(
                                                              ctx,
                                                            ).pop(true),
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirm != true) return;

                                                // Step 2: If root, promote children as new roots
                                                // if (isRoot) {
                                                //   final childrenSnapshot =
                                                //       await FirebaseFirestore.instance
                                                //           .collection(
                                                //             'family_members',
                                                //           )
                                                //           .where(
                                                //             'parentId',
                                                //             isEqualTo: member.id,
                                                //           )
                                                //           .get();

                                                //   for (var childDoc
                                                //       in childrenSnapshot.docs) {
                                                //     await childDoc.reference.update({
                                                //       'isRoot': true,
                                                //       'mainRoot':
                                                //           null, // child becomes a new root of separate family
                                                //     });
                                                //   }
                                                // }
                                                // Step 2: If root, promote children as new independent roots
                                                if (isRoot) {
                                                  final childrenSnapshot =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                            'family_members',
                                                          )
                                                          .where(
                                                            'parentId',
                                                            isEqualTo:
                                                                member.id,
                                                          )
                                                          .get();

                                                  for (var childDoc
                                                      in childrenSnapshot
                                                          .docs) {
                                                    await childDoc.reference.update({
                                                      'isRoot':
                                                          true, // mark child as a new root
                                                      'parentId':
                                                          null, // remove parent link
                                                      'mainRoot':
                                                          null, // detach from old root group
                                                    });
                                                  }
                                                }

                                                // Step 3: Delete the member
                                                await memberRef.delete();

                                                Navigator.of(context).pop();
                                                showToast(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.memberDelete,
                                                );
                                              },
                                              // onPressed: () {

                                              //   showDialog(
                                              //     context: context,
                                              //     builder: (context) => AlertDialog(
                                              //       title: Row(
                                              //         mainAxisAlignment:
                                              //             MainAxisAlignment
                                              //                 .spaceBetween,
                                              //         children: [
                                              //           Text(
                                              //             AppLocalizations.of(
                                              //               context,
                                              //             )!.confrimDelete,
                                              //             style: const TextStyle(
                                              //               fontWeight:
                                              //                   FontWeight.bold,
                                              //             ),
                                              //           ),
                                              //           IconButton(
                                              //             onPressed: () {
                                              //               Navigator.of(
                                              //                 context,
                                              //               ).pop();
                                              //             },
                                              //             icon: const Icon(
                                              //               Icons.close,
                                              //               color: Colors.grey,
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //       content: Text(
                                              //         '${AppLocalizations.of(context)!.confirmText}${AppLocalizations.of(context)!.unDone}',
                                              //       ),
                                              //       actions: [
                                              //         TextButton(
                                              //           onPressed: () => Navigator.of(
                                              //             context,
                                              //           ).pop(),
                                              //           child: Text(
                                              //             AppLocalizations.of(
                                              //               context,
                                              //             )!.cancel,
                                              //           ),
                                              //         ),
                                              //         TextButton(
                                              //           // onPressed: () async {
                                              //           //   print(
                                              //           //     "Selected id ${member.id}",
                                              //           //   );
                                              //           //   // await FirebaseFirestore
                                              //           //   //     .instance
                                              //           //   //     .collection(
                                              //           //   //       'family_members',
                                              //           //   //     )
                                              //           //   //     .doc(member.id)
                                              //           //   //     .delete();

                                              //           //   Navigator.of(context).pop();
                                              //           //   showToast(
                                              //           //     AppLocalizations.of(
                                              //           //       context,
                                              //           //     )!.memberDelete,
                                              //           //   );
                                              //           // },
                                              //           onPressed: () async {
                                              //             final memberRef =
                                              //                 FirebaseFirestore
                                              //                     .instance
                                              //                     .collection(
                                              //                       'family_members',
                                              //                     )
                                              //                     .doc(member.id);

                                              //             final memberSnapshot =
                                              //                 await memberRef.get();
                                              //             final memberData =
                                              //                 memberSnapshot.data();

                                              //             if (memberData == null)
                                              //               return;

                                              //             bool isRoot =
                                              //                 memberData['isRoot'] ??
                                              //                 false;
                                              //             print(
                                              //               "IS INTERNAL ${isRoot}",
                                              //             );
                                              //             // Step 1: Show different dialog message
                                              //             String message = isRoot
                                              //                 ? "You are about to delete the root member of your family. After deleting, it will affect your family organisation tree."
                                              //                 : "Are you sure you want to delete this member?";

                                              //             final confirm =
                                              //                 await showDialog<bool>(
                                              //                   context: context,
                                              //                   builder: (ctx) => AlertDialog(
                                              //                     title: Text(
                                              //                       "Confirm Delete",
                                              //                     ),
                                              //                     content: Text(
                                              //                       message,
                                              //                     ),
                                              //                     actions: [
                                              //                       TextButton(
                                              //                         onPressed: () =>
                                              //                             Navigator.of(
                                              //                               ctx,
                                              //                             ).pop(
                                              //                               false,
                                              //                             ),
                                              //                         child:
                                              //                             const Text(
                                              //                               "Cancel",
                                              //                             ),
                                              //                       ),
                                              //                       TextButton(
                                              //                         onPressed: () =>
                                              //                             Navigator.of(
                                              //                               ctx,
                                              //                             ).pop(true),
                                              //                         child:
                                              //                             const Text(
                                              //                               "Delete",
                                              //                             ),
                                              //                       ),
                                              //                     ],
                                              //                   ),
                                              //                 );

                                              //             if (confirm != true) return;

                                              //             // Step 2: If root, promote children as new roots
                                              //             if (isRoot) {
                                              //               final childrenSnapshot =
                                              //                   await FirebaseFirestore
                                              //                       .instance
                                              //                       .collection(
                                              //                         'family_members',
                                              //                       )
                                              //                       .where(
                                              //                         'parentId',
                                              //                         isEqualTo:
                                              //                             member.id,
                                              //                       )
                                              //                       .get();

                                              //               for (var childDoc
                                              //                   in childrenSnapshot
                                              //                       .docs) {
                                              //                 await childDoc.reference
                                              //                     .update({
                                              //                       'isRoot': true,
                                              //                       'mainRoot':
                                              //                           null, // child becomes a new root of separate family
                                              //                     });
                                              //               }
                                              //             }

                                              //             // Step 3: Delete the member
                                              //             await memberRef.delete();

                                              //             Navigator.of(context).pop();
                                              //             showToast(
                                              //               AppLocalizations.of(
                                              //                 context,
                                              //               )!.memberDelete,
                                              //             );
                                              //           },
                                              //           child: Text(
                                              //             AppLocalizations.of(
                                              //               context,
                                              //             )!.delete,
                                              //             style: const TextStyle(
                                              //               color: Colors.red,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   );
                                              // },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchAllMembers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('family_members')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      print("ALL DATAS ${data}");
      return {
        'id': doc.id,
        ...data, // spreads all fields (name, dob, gender, etc.)
      };
    }).toList();
  }
}
