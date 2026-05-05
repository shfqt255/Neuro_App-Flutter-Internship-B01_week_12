import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Services/review_service.dart';
import '../Models/review_model.dart';

class ReviewScreen extends StatelessWidget {
  final String orderId = "order_001";
  final String productId = "product_001";

  final TextEditingController controller = TextEditingController();

  ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReviewService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Product Reviews"), centerTitle: true),

      body: Column(
        children: [
          /// star selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int star = index + 1;

              return IconButton(
                onPressed: () {
                  provider.setRating(star.toDouble());
                },
                icon: Icon(
                  Icons.star,
                  size: 30,
                  color: provider.selectedRating >= star
                      ? Colors.amber
                      : Colors.grey,
                ),
              );
            }),
          ),

          /// comment
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          /// submit
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty || provider.selectedRating == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add rating & comment")),
                );
                return;
              }

              provider.addReview(
                orderId: orderId,
                productId: productId,
                comment: controller.text,
              );

              controller.clear();
            },
            child: const Text("Submit Review"),
          ),

          /// sort
          DropdownButton(
            value: provider.sortBy,
            items: const [
              DropdownMenuItem(value: 'recent', child: Text("Recent")),
              DropdownMenuItem(value: 'helpful', child: Text("Most Helpful")),
              DropdownMenuItem(value: 'high', child: Text("High Rating")),
              DropdownMenuItem(value: 'low', child: Text("Low Rating")),
            ],
            onChanged: (val) {
              provider.setSort(val!);
            },
          ),

          /// filter (all + 1-5)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                /// all
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text("All"),
                    selected: provider.filterRating == 0,
                    onSelected: (_) {
                      provider.setFilter(0);
                    },
                  ),
                ),

                /// stars
                ...List.generate(5, (index) {
                  int star = index + 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text("$star ⭐"),
                      selected: provider.filterRating == star,
                      onSelected: (_) {
                        provider.setFilter(star);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// reviews
          Expanded(
            child: StreamBuilder<List<ReviewModel>>(
              stream: provider.fetchReviews(
                orderId: orderId,
                productId: productId,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allReviews = snapshot.data!;

                /// avg from all
                double avg = provider.calculateAverage(allReviews);

                /// filtered list
                List<ReviewModel> filteredReviews = allReviews;

                if (provider.filterRating > 0) {
                  filteredReviews = filteredReviews
                      .where(
                        (r) => r.ratings == provider.filterRating.toDouble(),
                      )
                      .toList();
                }

                /// sort
                if (provider.sortBy == 'helpful') {
                  filteredReviews.sort(
                    (a, b) => b.helpfulvotes.compareTo(a.helpfulvotes),
                  );
                } else if (provider.sortBy == 'high') {
                  filteredReviews.sort(
                    (a, b) => b.ratings.compareTo(a.ratings),
                  );
                } else if (provider.sortBy == 'low') {
                  filteredReviews.sort(
                    (a, b) => a.ratings.compareTo(b.ratings),
                  );
                }

                if (filteredReviews.isEmpty) {
                  return const Center(child: Text("No reviews found"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// average
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Average Rating: ${avg.toStringAsFixed(1)} ⭐",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// count
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        "All Reviews (${allReviews.length})",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                    const Divider(),

                    /// list
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredReviews.length,
                        itemBuilder: (context, index) {
                          final r = filteredReviews[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// stars
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 16,
                                        color: i < r.ratings
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  /// comment
                                  Text(r.comment),

                                  const SizedBox(height: 10),

                                  /// helpful button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Helpful: ${r.helpfulvotes}",
                                        style: const TextStyle(fontSize: 12),
                                      ),

                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await provider.markHelpful(
                                            orderId: orderId,
                                            productId: productId,
                                            reviewId: r.id,
                                          );

                                          /// optional feedback
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Marked helpful"),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.thumb_up,
                                          size: 16,
                                        ),
                                        label: const Text("Helpful"),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
