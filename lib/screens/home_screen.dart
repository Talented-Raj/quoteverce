import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote_model.dart';
import '../providers/quote_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/action_button.dart';
import '../widgets/error_view.dart';
import '../widgets/glass_container.dart';
import '../widgets/quote_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFavoritesOnly = false;

  void _copyToClipboard(BuildContext context, QuoteModel quote) {
    final text = '"${quote.quote}"\n- ${quote.author} ${quote.year != "Unknown" ? "(${quote.year})" : ""}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_outline_rounded, color: Colors.white),
            SizedBox(width: 12),
            Text('Quote copied to clipboard!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareQuote(QuoteModel quote) {
    final text = '"${quote.quote}"\n- ${quote.author} ${quote.year != "Unknown" ? "(${quote.year})" : ""}';
    Share.share(text, subject: 'Quote from Quote Duniya');
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = themeProvider.isDarkMode;

    // Dynamic premium backgrounds
    final backgroundGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF1E1B4B), // Indigo 950
              Color(0xFF1A103C), // Deep Violet
            ],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEEF2F6), // Light Slate
              Color(0xFFE0E7FF), // Soft Indigo
              Color(0xFFF5F3FF), // Soft Purple
            ],
          );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        title: Text(
          'Quote Duniya',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: isDark
                    ? [const Color(0xFFC7D2FE), const Color(0xFFF472B6)]
                    : [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
        actions: [
          // Theme toggler
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey<bool>(isDark),
                color: theme.colorScheme.primary,
              ),
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          // Favorites toggler
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.explore_rounded : Icons.favorite_rounded,
              color: _showFavoritesOnly ? theme.colorScheme.primary : Colors.redAccent,
            ),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: backgroundGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: RefreshIndicator(
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surface,
                onRefresh: () async {
                  await quoteProvider.loadRandomQuote();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        child: _showFavoritesOnly
                            ? _buildFavoritesSection(context, quoteProvider)
                            : _buildMainGeneratorSection(context, quoteProvider),
                      ),
                      _buildCreatorBadge(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainGeneratorSection(BuildContext context, QuoteProvider provider) {
    final theme = Theme.of(context);
    final quote = provider.currentQuote;
    final hasCache = quote != null;

    return Column(
      children: [
        const SizedBox(height: 10),
        
        // Quote Card containing AnimatedSwitcher for smooth transition
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.08),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: provider.isLoading && !hasCache
              ? _buildPulsingLoadingSkeleton()
              : provider.errorMessage != null && !hasCache
                  ? ErrorView(
                      message: provider.errorMessage!,
                      onRetry: () => provider.loadRandomQuote(),
                    )
                  : quote != null
                      ? QuoteCard(key: ValueKey<String>(quote.id), quote: quote)
                      : const SizedBox(height: 200),
        ),
        
        if (quote != null) ...[
          const SizedBox(height: 24),
          // Tool Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Copy Button
              ActionButton(
                icon: Icons.copy_rounded,
                label: 'Copy',
                onTap: () => _copyToClipboard(context, quote),
              ),
              // Favorite Toggle Button
              ActionButton(
                icon: provider.isFavorite(quote)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: provider.isFavorite(quote) ? 'Liked' : 'Like',
                color: provider.isFavorite(quote) ? Colors.redAccent.withOpacity(0.12) : null,
                onTap: () => provider.toggleFavorite(quote),
              ),
              // Share Button
              ActionButton(
                icon: Icons.ios_share_rounded,
                label: 'Share',
                onTap: () => _shareQuote(quote),
              ),
            ],
          ),
        ],
        
        const SizedBox(height: 40),

        // Generate Button
        GestureDetector(
          onTap: provider.isLoading ? null : () => provider.loadRandomQuote(),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: provider.isLoading
                    ? [Colors.grey[400]!, Colors.grey[500]!]
                    : [theme.colorScheme.primary, theme.colorScheme.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: (provider.isLoading ? Colors.grey : theme.colorScheme.primary).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: provider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.refresh_rounded, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Inspire Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesSection(BuildContext context, QuoteProvider provider) {
    final theme = Theme.of(context);
    final favList = provider.favorites;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Favorites',
              style: theme.textTheme.displayLarge?.copyWith(fontSize: 22),
            ),
            Text(
              '${favList.length} quotes Saved',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        if (favList.isEmpty)
          GlassContainer(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 60,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Favorites Yet',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quotes you like will appear here.\nExplore quotes and tap the heart icon to save!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final quote = favList[index];
              return Dismissible(
                key: Key('fav_${quote.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 28),
                ),
                onDismissed: (_) {
                  provider.toggleFavorite(quote);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Quote removed from favorites'),
                      action: SnackBarAction(
                        label: 'Undo',
                        textColor: Colors.white,
                        onPressed: () => provider.toggleFavorite(quote),
                      ),
                    ),
                  );
                },
                child: GlassContainer(
                  padding: const EdgeInsets.all(18),
                  borderRadius: 20,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '"${quote.quote}"',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '- ${quote.author}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 20),
                          onPressed: () => _copyToClipboard(context, quote),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          onPressed: () => provider.toggleFavorite(quote),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPulsingLoadingSkeleton() {
    return const GlassContainer(
      child: SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildCreatorBadge(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.indigo.withOpacity(0.04),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : Colors.indigo.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Crafted with ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.favorite_rounded,
                size: 14,
                color: Colors.redAccent,
              ),
              Text(
                ' by ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [const Color(0xFFC7D2FE), const Color(0xFFF472B6)]
                      : [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
                ).createShader(bounds),
                child: const Text(
                  'RAJ BAMNE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
