import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/edit_member.dart';
import 'package:family_tree/adminpanel/service/csv_dlowanload_service.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: downloadFamilyDataAsCSV,
                  label: Text('Download CSV'),
                  icon: Icon(Icons.download),
                ),
              ),
            ],
            centerTitle: true,
            elevation: 0,
          ),
          body: groupedData.isEmpty
              ? Center(
                  child: Text(
                    AppLocalizations.of(context)!.noGroupedMemberFound,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: groupedData.entries.map((entry) {
                    final root = entry.key;
                    final children = entry.value;

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                root,
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 4,
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
                                  contentPadding: const EdgeInsets.symmetric(
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
                                                      BorderRadius.circular(12),
                                                ),
                                                child: ConstrainedBox(
                                                  constraints: const BoxConstraints(
                                                    maxWidth: 600,
                                                    maxHeight:
                                                        600, // 👈 Set a height limit so scrolling kicks in
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      // Title Bar
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .orangePrimary,
                                                          borderRadius:
                                                              BorderRadius.only(
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
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(),
                                                                icon: const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      // Scrollable Content
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                16.0,
                                                              ),
                                                          child:
                                                              EditMemberScreen(
                                                                member: member,
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
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.confrimDelete,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Text(
                                                '${AppLocalizations.of(context)!.confirmText}${AppLocalizations.of(context)!.unDone}',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.cancel,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                          'family_members',
                                                        )
                                                        .doc(member.id)
                                                        .delete();

                                                    Navigator.of(context).pop();
                                                    showToast(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!.memberDelete,
                                                    );
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.delete,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
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
        );
      },
    );
  }
}
