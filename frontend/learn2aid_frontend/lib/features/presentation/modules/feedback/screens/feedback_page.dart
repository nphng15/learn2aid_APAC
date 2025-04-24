import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn2aid/features/presentation/modules/feedback/feedback_controller.dart';

class FeedbackPage extends StatelessWidget {
  final FeedbackController controller = Get.find<FeedbackController>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gửi phản hồi'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chúng tôi rất mong nhận được phản hồi của bạn!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildRatingSelector(),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên của bạn (tùy chọn)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          labelText: 'Nội dung phản hồi',
                          hintText: 'Hãy cho mình biết về cảm nhận của bạn về ứng dụng: độ ổn định, thân thiện, dễ sử dụng,... Ngoài ra nếu có chỗ nào cần cải thiện, hãy góp ý cho chúng mình nhé!',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      if (controller.error.value.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red.shade100,
                          child: Text(
                            controller.error.value,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => _submitFeedback(),
                          child: const Text(
                            'Đánh giá ứng dụng <3',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildRatingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bạn đánh giá ứng dụng của chúng tôi như thế nào?',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  color: controller.rating.value >= index + 1
                      ? Colors.amber
                      : Colors.grey,
                  size: 40,
                ),
                onPressed: () => controller.updateRating(index + 1.0),
              );
            }),
          ),
        ),
        Center(
          child: Obx(
            () => Text(
              controller.rating.value > 0
                  ? '${controller.rating.value.toInt()}/5'
                  : 'Chọn đánh giá',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _submitFeedback() {
    final message = messageController.text.trim();
    final name = nameController.text.trim();

    if (message.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập nội dung phản hồi');
      return;
    }

    if (controller.rating.value == 0) {
      Get.snackbar('Lỗi', 'Vui lòng chọn đánh giá sao');
      return;
    }

    controller.submitFeedback(
      message: message,
      rating: controller.rating.value,
      name: name.isNotEmpty ? name : null,
    );
  }
} 