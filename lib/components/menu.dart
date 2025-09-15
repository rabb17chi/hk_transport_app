import 'package:flutter/material.dart';
import '../scripts/kmb_cache_service.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isRefreshing = false;
  Map<String, dynamic> _cacheInfo = {};

  @override
  void initState() {
    super.initState();
    _loadCacheInfo();
  }

  Future<void> _loadCacheInfo() async {
    final info = await KMBCacheService.getCacheInfo();
    setState(() {
      _cacheInfo = info;
    });
  }

  Future<void> _refreshCache() async {
    setState(() {
      _isRefreshing = true;
    });
    await KMBCacheService.clearCache();
    await _loadCacheInfo();
    setState(() {
      _isRefreshing = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'KMB cache cleared. Fresh data will be fetched automatically.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('菜單'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Theme'),
            subtitle: Text('Light / Dark (coming soon)'),
            leading: Icon(Icons.color_lens),
          ),
          const Divider(),
          const ListTile(
            title: Text('Style'),
            subtitle: Text('Fonts, colors, sizes (coming soon)'),
            leading: Icon(Icons.format_paint),
          ),
          const Divider(),
          ListTile(
            title: const Text('Update KMB Data Manually'),
            leading: const Icon(Icons.sync),
            trailing: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton(
                    onPressed: _refreshCache,
                    child: const Text('Refresh'),
                  ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Terms of Service'),
            subtitle: Text('View terms and privacy policy (coming soon)'),
            leading: Icon(Icons.description),
          ),
          const Divider(),
          const ListTile(
            title: Text('Developer Links'),
            subtitle: Text('GitHub, Website, Contact (coming soon)'),
            leading: Icon(Icons.link),
          ),
        ],
      ),
    );
  }
}
