import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../config/theme/app_color.dart';
import '../../profile/screens/profile_screen.dart';
import '../../profile/profile_controller.dart';
import '../../auth/login/login_controller.dart';
import '../controllers/video_controller.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  Widget searchField() {
    final VideoController videoController = Get.find<VideoController>();
    
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2A6F97)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.search, size: 20, color: Color(0xFF2A6F97)),
          ),
          Expanded(
            child: TextField(
              focusNode: videoController.searchFocusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tìm kiếm video...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                isDense: true,
              ),
              onChanged: (value) {
                videoController.searchVideos(value);
              },
              onSubmitted: (value) {
                videoController.searchVideos(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    
    // Đảm bảo ProfileController được khởi tạo
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController());
    }
    
    // Lấy ProfileController
    final ProfileController profileController = Get.find<ProfileController>();
    
    // Lấy tên người dùng từ tài khoản Google
    final String displayName = loginController.googleUserName.value.isNotEmpty
        ? _getFirstName(loginController.googleUserName.value)
        : "Name";
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, size: 24, color: Color(0xFF2A6F97)),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileScreen());
                },
                child: Obx(() => CircleAvatar(
                  radius: 20,
                  backgroundImage: loginController.googleUserPhotoUrl.value.isNotEmpty
                      ? NetworkImage(loginController.googleUserPhotoUrl.value)
                      : null,
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
                  child: loginController.googleUserPhotoUrl.value.isEmpty
                      ? const Icon(Icons.person, color: AppColors.secondary)
                      : null,
                )),
              ),
            ],
          ),
          Text(
            "Hello, $displayName!",
            style: const TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Lexend',
              color: Color(0xFF2A6F97),
            ),
          ),
          Row(
            children: [
              Expanded(child: searchField()),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: const Color(0xff55c595),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    // Xóa focus khỏi thanh tìm kiếm trước khi hiển thị dialog
                    FocusScope.of(context).unfocus();
                    _showFilterDialog(context);
                  },
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Hiển thị hộp thoại xác nhận xóa dữ liệu
  void _showClearDataConfirmation(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa dữ liệu'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả dữ liệu đã lưu cục bộ? '
          'Các tiến trình xem video, danh sách video đã hoàn thành và đang xem sẽ bị xóa. '
          'Hành động này không thể hoàn tác.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              await controller.clearLocalData();
              
              // Reload dashboard
              final VideoController videoController = Get.find<VideoController>();
              videoController.loadVideos();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
  
  // Hàm lấy first name từ full name
  String _getFirstName(String fullName) {
    if (fullName.isEmpty) return "Name";
    final nameParts = fullName.split(' ');
    return nameParts.first;
  }
  
  // Hiển thị dialog cho filter
  void _showFilterDialog(BuildContext context) {
    final VideoController videoController = Get.find<VideoController>();
    
    final categories = [
      {'id': 'all', 'name': 'Tất cả'},
      {'id': 'basic', 'name': 'Cơ bản'},
      {'id': 'cpr', 'name': 'CPR'},
      {'id': 'burns', 'name': 'Bỏng'},
      {'id': 'wounds', 'name': 'Vết thương'},
      {'id': 'fractures', 'name': 'Gãy xương'},
      {'id': 'choking', 'name': 'Nghẹt thở'},
      {'id': 'emergencies', 'name': 'Khẩn cấp'},
    ];
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          // Bảo đảm không focus vào thanh tìm kiếm khi thoát khỏi dialog bằng phím back
          onWillPop: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              'Lọc video',
              style: TextStyle(
                color: Color(0xFF2A6F97),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: categories.map((category) {
                return Column(
                  children: [
                    _buildFilterOption(category['name']!, category['id']!, context, videoController),
                    if (category != categories.last) const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Đảm bảo không focus vào thanh tìm kiếm sau khi đóng dialog
                  Navigator.of(context).pop();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2A6F97),
                ),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Đảm bảo không focus vào thanh tìm kiếm sau khi dialog đóng
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
  
  // Widget tạo option trong filter
  Widget _buildFilterOption(String title, String categoryId, BuildContext context, VideoController controller) {
    return InkWell(
      onTap: () {
        controller.changeCategory(categoryId);
        
        // Đóng dialog
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2A6F97),
          ),
        ),
      ),
    );
  }
}