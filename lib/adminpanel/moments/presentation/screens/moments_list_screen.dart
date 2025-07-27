import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_tree/adminpanel/moments/cubit/moments_cubit.dart';
import 'package:family_tree/adminpanel/moments/presentation/widgets/image_dailog.dart';

class MomentsListScreen extends StatefulWidget {
  const MomentsListScreen({super.key});

  @override
  State<MomentsListScreen> createState() => _MomentsListScreenState();
}

class _MomentsListScreenState extends State<MomentsListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MomentsCubit>(context).fetchMoments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.familyMoments),
        centerTitle: true,
        // backgroundColor: Colors.indigo.shade600,
      ),
      backgroundColor: Colors.grey.shade100,
      body: BlocBuilder<MomentsCubit, MomentsState>(
        builder: (context, state) {
          if (state is MomentshLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MomentFetchSucess) {
            final moments = state.moments;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: moments.length,
              itemBuilder: (context, index) {
                final moment = moments[index];
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              moment.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.indigo.shade800,s
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // Horizontal image scroll
                            SizedBox(
                              height: 220,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: moment.imageUrl.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, imgIndex) {
                                  final imageUrl = moment.imageUrl[imgIndex];
                                  return GestureDetector(
                                    onTap: () {
                                      showImageGalleryDialog(
                                        context,
                                        moment.imageUrl,
                                        imgIndex,
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        imageUrl,
                                        width: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey.shade200,
                                                width: 200,
                                                child: const Icon(
                                                  Icons.broken_image,
                                                  size: 60,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Caption
                            Text(
                              moment.caption,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is MomentsErrorState) {
            return Center(child: Text("Error: ${state.errorMessage}"));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
