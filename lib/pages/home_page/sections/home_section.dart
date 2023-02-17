import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:volume_vault/models/book_model.dart';
import 'package:volume_vault/models/enums/visualization_type.dart';
import 'package:volume_vault/shared/fake_models.dart';
import 'package:volume_vault/shared/widgets/book_info_card.dart';
import 'package:volume_vault/shared/widgets/search_text_field.dart';
import 'package:volume_vault/shared/widgets/user_account_button.dart';

class HomeSection extends HookWidget {
  List<BookModel>? books;
  VisualizationType? viewType;

  HomeSection({super.key, this.viewType, this.books});

  Widget showByViewType(VisualizationType viewType) {
    switch (viewType) {
      case VisualizationType.LIST:
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return BookInfoCard(bookModel: fakeBookModel);
          }, childCount: 50),
        );
      case VisualizationType.GRID:
        return SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            return BookInfoCard(bookModel: fakeBookModel);
          }, childCount: 50),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
        );
      default:
        return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final visualizationType =
        useState<VisualizationType>(viewType ?? VisualizationType.LIST);

    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          sliver: SliverAppBar(
            floating: true,
            leading: UserAccountButton(fakeUserModel),
            title: SearchTextField(height: 40),
            actions: [
              IconButton(
                onPressed: () {
                  visualizationType.value =
                      visualizationType.value == VisualizationType.LIST
                          ? VisualizationType.GRID
                          : VisualizationType.LIST;
                },
                icon: Icon(visualizationType.value == VisualizationType.LIST
                    ? Icons.grid_view_rounded
                    : Icons.view_list_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_rounded),
              )
            ],
          ),
        ),
        showByViewType(visualizationType.value)
      ],
    );
  }
}
