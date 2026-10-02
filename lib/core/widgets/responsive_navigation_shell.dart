import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_layout.dart';

class ResponsiveNavigationShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const ResponsiveNavigationShell({
    super.key,
    required this.child,
    required this.state,
  });

  int _getSelectedIndex(String location) {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/jobs')) return 1;
    if (location.startsWith('/applications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/jobs');
        break;
      case 2:
        context.go('/applications');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = state.uri.path;
    final selectedIndex = _getSelectedIndex(location);

    // Sidebar items configuration for desktop
    final menuItems = [
      _NavigationItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
      _NavigationItem(icon: Icons.work_outline, activeIcon: Icons.work, label: 'Jobs'),
      _NavigationItem(icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: 'Applications'),
      _NavigationItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
    ];

    return Scaffold(
      body: ResponsiveBuilder(
        mobile: (context) => _buildMobileLayout(context, selectedIndex),
        desktop: (context) => _buildDesktopLayout(context, selectedIndex, menuItems),
      ),
    );
  }

  // Mobile/Tablet Layout (Bottom Nav Bar)
  Widget _buildMobileLayout(BuildContext context, int selectedIndex) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(selectedIndex),
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Applications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Desktop Layout (Sidebar + Content Area)
  Widget _buildDesktopLayout(BuildContext context, int selectedIndex, List<_NavigationItem> menuItems) {
    return Row(
      children: [
        // Sidebar Navigation
        Container(
          width: 260,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              right: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Column(
            children: [
              // Sidebar Header / Logo
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'PlacementOS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 24),
              // Menu Items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    itemCount: menuItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      final isSelected = index == selectedIndex;
                      return _buildSidebarTile(
                        context,
                        item: item,
                        isSelected: isSelected,
                        onTap: () => _onItemTapped(index, context),
                      );
                    },
                  ),
                ),
              ),
              // Sidebar Footer / User Profile Summary
              const Divider(color: AppColors.border, height: 1),
              _buildSidebarFooter(context),
            ],
          ),
        ),
        // Main Content Area
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.background,
              title: Text(
                _getAppBarTitle(selectedIndex),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              actions: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text('Upload Resume'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                const SizedBox(width: 24),
              ],
            ),
            body: child,
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarTile(
    BuildContext context, {
    required _NavigationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            foregroundColor: AppColors.primary,
            radius: 20,
            child: const Text('JD', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'john.doe@univ.edu',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 18, color: AppColors.textMuted),
            onPressed: () {
              // Sign out flow
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Placement Dashboard';
      case 1:
        return 'Job Postings';
      case 2:
        return 'My Applications';
      case 3:
        return 'Student Profile';
      default:
        return 'PlacementOS';
    }
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
