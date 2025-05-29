import 'package:flutter/material.dart';

// Color scheme constants for theming
const Color kPrimaryColor = Color(0xFFFF7043);
const Color kSecondaryColor = Color(0xFFFFF3E0);
const Color kAccentColor = Color(0xFF388E3C);

// Categories for sample display
final List<Map<String, String>> kRecipeCategories = [
  {'name': 'Breakfast', 'icon': '🍳'},
  {'name': 'Lunch', 'icon': '🥪'},
  {'name': 'Dinner', 'icon': '🍝'},
  {'name': 'Desserts', 'icon': '🍰'},
  {'name': 'Snacks', 'icon': '🍿'},
  {'name': 'Drinks', 'icon': '🥤'},
];

// Dummy recipes for feed display
final List<Map<String, String>> kSampleRecipes = [
  {
    'title': 'Avocado Toast',
    'category': 'Breakfast',
    'image': 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=400&q=80',
    'subtitle': 'Healthy & Quick',
  },
  {
    'title': 'Chicken Caesar Salad',
    'category': 'Lunch',
    'image': 'https://images.unsplash.com/photo-1514512364185-4c2b6785d927?auto=format&fit=crop&w=400&q=80',
    'subtitle': 'Crispy & Fresh',
  },
  {
    'title': 'Spaghetti Bolognese',
    'category': 'Dinner',
    'image': 'https://images.unsplash.com/photo-1523983303491-80022131f5a1?auto=format&fit=crop&w=400&q=80',
    'subtitle': 'Classic Italian',
  },
  {
    'title': 'Strawberry Cheesecake',
    'category': 'Desserts',
    'image': 'https://images.unsplash.com/photo-1505250469679-203ad9ced0cb?auto=format&fit=crop&w=400&q=80',
    'subtitle': 'Sweet & Creamy',
  },
];

void main() {
  runApp(const RecipeHubApp());
}

/// PUBLIC_INTERFACE
class RecipeHubApp extends StatelessWidget {
  /// Top-level app widget with custom light theme
  const RecipeHubApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RecipeHub",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: kSecondaryColor,
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: kPrimaryColor,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAccentColor,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kSecondaryColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
          ),
        ),
      ),
      home: const MainContainer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// PUBLIC_INTERFACE
class MainContainer extends StatefulWidget {
  /// The main navigation container for RecipeHub.
  const MainContainer({super.key});
  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  /// The main pages corresponding to bottom navigation
  final _pages = <Widget>[
    const HomePage(),
    const FavoritesPage(),
    const AddRecipePage(),
    const ProfilePage(),
  ];

  // PUBLIC_INTERFACE
  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

/// PUBLIC_INTERFACE
class HomePage extends StatefulWidget {
  /// Home page: contains search, categories, and recipe feed
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String? _selectedCategory;

  // PUBLIC_INTERFACE
  void _openRecipeDetail(Map<String, String> recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
    );
  }

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    // Filter recipes by search and/or category
    final filteredRecipes = kSampleRecipes.where((recipe) {
      final matchesCategory = _selectedCategory == null ||
          recipe['category'] == _selectedCategory;
      final matchesSearch = recipe['title']!
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Search bar ---
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search recipes, ingredients...",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: kPrimaryColor),
                    onPressed: () {}, // placeholder for future filter action
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // --- Categories ---
              Text(
                "Categories",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kRecipeCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final category = kRecipeCategories[index];
                    final selected = category['name'] == _selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_selectedCategory == category['name']) {
                            _selectedCategory = null; // Toggle off
                          } else {
                            _selectedCategory = category['name'];
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? kPrimaryColor : kPrimaryColor.withOpacity(0.25),
                            width: 1,
                          ),
                          boxShadow: [
                            if (selected)
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.17),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(category['icon']!, style: const TextStyle(fontSize: 19)),
                            const SizedBox(width: 7),
                            Text(
                              category['name']!,
                              style: TextStyle(
                                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                                color: selected ? Colors.white : kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              // --- Recipe Feed ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Recipes",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: kAccentColor,
                    ),
                    onPressed: () {}, // placeholder for 'See All'
                    child: const Text("See All"),
                  )
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return GestureDetector(
                    onTap: () => _openRecipeDetail(recipe),
                    child: RecipeCard(recipe: recipe),
                  );
                },
              ),
              if (filteredRecipes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      "No recipes found.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 17),
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

// PUBLIC_INTERFACE
class RecipeCard extends StatelessWidget {
  final Map<String, String> recipe;
  const RecipeCard({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2.7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
            child: Image.network(
              recipe['image']!,
              height: 94, width: 110, fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                height: 94, width: 110, color: kSecondaryColor,
                child: const Icon(Icons.image, size: 34, color: kPrimaryColor),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe['subtitle'] ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: kAccentColor, size: 19),
                      const SizedBox(width: 3),
                      // Dummy rating:
                      const Text('4.5', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 15),
                      Icon(Icons.category, color: kPrimaryColor.withOpacity(0.76), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        recipe['category'] ?? '',
                        style: TextStyle(color: kPrimaryColor.withOpacity(0.76)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PUBLIC_INTERFACE
class RecipeDetailPage extends StatelessWidget {
  /// Placeholder for recipe detailed view
  final Map<String, String> recipe;
  const RecipeDetailPage({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Recipe'),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 2.2,
            child: Image.network(
              recipe['image']!,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: kSecondaryColor,
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 48, color: kPrimaryColor),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['title'] ?? '',
                  style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.category, size: 19, color: kPrimaryColor.withOpacity(0.7)),
                    const SizedBox(width: 5),
                    Text(
                      recipe['category'] ?? '',
                      style: TextStyle(color: kPrimaryColor.withOpacity(0.7)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Placeholder instructions
                Text(
                  "Ingredients:
• ...
• ...

Steps:
1. ...
2. ...",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 26),
                // User Ratings & Comments Placeholder
                Text(
                  "User Ratings & Comments",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kAccentColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      "(User comments and ratings coming soon!)",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Recipe sharing placeholder
                Center(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share, color: kAccentColor),
                    label: const Text("Share Recipe"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kAccentColor,
                      side: const BorderSide(color: kAccentColor),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PUBLIC_INTERFACE
class FavoritesPage extends StatelessWidget {
  /// Placeholder page for Favorites / Collections
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites & Collections")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.favorite_border, size: 50, color: kPrimaryColor),
            SizedBox(height: 18),
            Text(
              "Your favorite recipes & collections
will appear here.",
              style: TextStyle(fontSize: 17, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// PUBLIC_INTERFACE
class AddRecipePage extends StatelessWidget {
  /// Placeholder page for Add Recipe
  const AddRecipePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Recipe")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_circle_outline, size: 50, color: kAccentColor),
            SizedBox(height: 18),
            Text(
              "Feature coming soon:
Add your own recipes!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// PUBLIC_INTERFACE
class ProfilePage extends StatelessWidget {
  /// Placeholder page for Profile
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_outline, size: 50, color: kPrimaryColor),
            SizedBox(height: 18),
            Text(
              "Your profile and settings
will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
