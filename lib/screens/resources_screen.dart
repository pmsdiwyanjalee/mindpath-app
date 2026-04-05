import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const ResourcesScreen({Key? key}) : super(key: key);

  Widget _buildResourceCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3575),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showArticleDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0C234E),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Close', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051A3F),
        elevation: 0,
        title: const Text('Resources & Guides',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Helpful Resources',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Articles, guides, and tools to support your recovery journey.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Articles Section
              const Text(
                'Articles & Guides',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildResourceCard(
                title: 'Understanding Cravings',
                description:
                    'Learn what triggers cravings and how to manage them effectively.',
                icon: Icons.psychology,
                onTap: () => _showArticleDialog(
                  context,
                  'Understanding Cravings',
                  'Cravings are a normal part of recovery. They typically last 5-15 minutes and can be triggered by stress, people, places, or things associated with substance use.\n\nStrategies to manage cravings:\n\n1. Recognize the craving and accept it\n2. Use distraction techniques\n3. Practice deep breathing\n4. Call a support person\n5. Use positive self-talk\n6. Engage in physical activity\n\nRemember: A craving is not a command. You have the power to choose how to respond.',
                ),
              ),

              _buildResourceCard(
                title: 'Building Healthy Habits',
                description:
                    'Practical tips for creating routines that support long-term recovery.',
                icon: Icons.fitness_center,
                onTap: () => _showArticleDialog(
                  context,
                  'Building Healthy Habits',
                  'Recovery is about more than just stopping substance use—it\'s about building a new, healthier life.\n\nKey areas to focus on:\n\n• Sleep: Aim for 7-9 hours per night\n• Nutrition: Eat balanced meals regularly\n• Exercise: Find activities you enjoy\n• Social connections: Build supportive relationships\n• Purpose: Set meaningful goals\n• Stress management: Learn healthy coping skills\n\nStart small and be patient with yourself. Change takes time.',
                ),
              ),

              _buildResourceCard(
                title: 'Relapse Prevention',
                description:
                    'Identify warning signs and develop strategies to prevent relapse.',
                icon: Icons.shield,
                onTap: () => _showArticleDialog(
                  context,
                  'Relapse Prevention',
                  'Relapse is not failure—it\'s a learning opportunity. Most people in recovery experience setbacks.\n\nWarning signs of potential relapse:\n\n• Skipping meetings or therapy\n• Isolating from support network\n• Not managing stress effectively\n• Romanticizing past substance use\n• Poor self-care\n• Hanging out with old using friends\n\nPrevention strategies:\n\n• Follow your recovery plan\n• Stay connected to your support system\n• Practice self-care\n• Avoid high-risk situations\n• Have an emergency plan\n• Be honest about struggles',
                ),
              ),

              _buildResourceCard(
                title: 'Mindfulness & Meditation',
                description:
                    'Learn techniques to stay present and manage difficult emotions.',
                icon: Icons.self_improvement,
                onTap: () => _showArticleDialog(
                  context,
                  'Mindfulness & Meditation',
                  'Mindfulness helps you stay present and respond to challenges with awareness rather than reacting impulsively.\n\nGetting started:\n\n1. Find a quiet space\n2. Set a timer for 5-10 minutes\n3. Focus on your breath\n4. Notice thoughts without judgment\n5. Gently return focus when mind wanders\n\nBenefits for recovery:\n\n• Reduced cravings\n• Better emotional regulation\n• Improved sleep\n• Increased self-awareness\n• Enhanced coping skills\n\nStart with guided meditations using free apps like Insight Timer or Calm.',
                ),
              ),

              const SizedBox(height: 24),

              // Tools Section
              const Text(
                'Recovery Tools',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildResourceCard(
                title: 'Serenity Prayer',
                description:
                    'A powerful reminder of what we can and cannot control.',
                icon: Icons.self_improvement,
                onTap: () => _showArticleDialog(
                  context,
                  'Serenity Prayer',
                  'God, grant me the serenity to accept the things I cannot change,\n\nThe courage to change the things I can,\n\nAnd the wisdom to know the difference.\n\n- Reinhold Niebuhr\n\nThis prayer reminds us that we are powerless over addiction, but we have the power to change our attitudes, behaviors, and responses to life\'s challenges.',
                ),
              ),

              _buildResourceCard(
                title: 'HALT Check',
                description:
                    'Check yourself before making decisions when feeling vulnerable.',
                icon: Icons.warning_amber,
                onTap: () => _showArticleDialog(
                  context,
                  'HALT Check',
                  'HALT stands for:\n\n• Hungry\n• Angry\n• Lonely\n• Tired\n\nBefore making any important decisions or when experiencing cravings, ask yourself:\n\nAm I Hungry? (Eat something healthy)\nAm I Angry? (Express feelings appropriately)\nAm I Lonely? (Call a support person)\nAm I Tired? (Rest or take a break)\n\nAddressing these basic needs can prevent impulsive decisions and reduce vulnerability to relapse.',
                ),
              ),

              _buildResourceCard(
                title: 'Emergency Action Plan',
                description:
                    'Create a plan for when you need immediate support.',
                icon: Icons.emergency,
                onTap: () => _showArticleDialog(
                  context,
                  'Emergency Action Plan',
                  'Having a plan ready can help you respond effectively during a crisis.\n\nYour Emergency Action Plan should include:\n\n1. Warning signs that you need help\n2. Immediate actions to take\n3. People to contact (sponsor, therapist, etc.)\n4. Places to go (meetings, emergency room)\n5. Coping skills to use\n6. Self-care activities\n\nReview and update your plan regularly. Keep it accessible (phone, wallet, etc.).',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
