import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Kiểm tra kích thước màn hình để điều chỉnh layout
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 900;

    return Scaffold(
      appBar: AppBar(
        // elevation: 2.0,
        title: Text('TaskFlow'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text('Đăng nhập', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: Text('Đăng ký', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: isDesktop ? 80 : 24
              ),
              color: Colors.indigo.shade50,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200),
                  child: isDesktop
                      ? Row(
                    children: [
                      Expanded(child: _buildHeroContent()),
                      Expanded(child: _buildHeroImage()),
                    ],
                  )
                      : Column(
                    children: [
                      _buildHeroContent(),
                      SizedBox(height: 40),
                      _buildHeroImage(),
                    ],
                  ),
                ),
              ),
            ),

            // Features Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200, minHeight: 500),
                  child: Column(
                    children: [
                      Text(
                        'Tính năng nổi bật',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Wrap(
                        spacing: 30,
                        runSpacing: 30,
                        children: [
                          _buildFeatureCard(
                              Icons.task_alt,
                              'Quản lý task hiệu quả',
                              'Tạo, sắp xếp và theo dõi công việc một cách dễ dàng'
                          ),
                          _buildFeatureCard(
                              Icons.notifications_active,
                              'Nhắc nhở thông minh',
                              'Không bao giờ bỏ lỡ deadline với hệ thống nhắc nhở'
                          ),
                          _buildFeatureCard(
                              Icons.bar_chart,
                              'Báo cáo & Thống kê',
                              'Theo dõi hiệu suất với biểu đồ trực quan'
                          ),
                          _buildFeatureCard(
                              Icons.devices,
                              'Đa nền tảng',
                              'Sử dụng trên web, mobile và desktop'
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity, height: 200,
              color: Colors.indigo.shade900,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      Text(
                        '© 2025 TaskFlow. All rights reserved.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TaskFlow',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade800,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Quản lý công việc hiệu quả, nâng cao năng suất',
          style: TextStyle(fontSize: 22, color: Colors.grey[700]),
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Colors.indigo,
          ),
          child: Text('Bắt đầu ngay', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Image.network(
      'https://via.placeholder.com/500x300?text=Task+Management',
      height: 300,
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.indigo),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
