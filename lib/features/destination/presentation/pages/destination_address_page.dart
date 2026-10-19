import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/destination_bloc.dart';
import '../bloc/destination_event.dart';
import '../bloc/destination_state.dart';
import '../../../booking/presentation/pages/ride_details_page.dart';

class DestinationAddressPage extends StatefulWidget {
  final String initialPickupAddress;

  const DestinationAddressPage({
    super.key,
    this.initialPickupAddress = 'Manjeera Majestic Commercial, 30',
  });

  @override
  State<DestinationAddressPage> createState() => _DestinationAddressPageState();
}

class _DestinationAddressPageState extends State<DestinationAddressPage> {
  late final TextEditingController _pickupController;
  late final TextEditingController _destinationController;
  final FocusNode _destinationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController(text: widget.initialPickupAddress);
    _destinationController = TextEditingController();

    context.read<DestinationBloc>().add(
          InitDestinationSearchEvent(initialPickup: widget.initialPickupAddress),
        );

    // Auto-focus the destination text field matching screenshot
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _destinationFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  void _navigateToRideDetails(String destination) {
    if (destination.trim().isEmpty) return;

    _destinationFocusNode.unfocus();

    final pickup = _pickupController.text.trim().isNotEmpty
        ? _pickupController.text.trim()
        : widget.initialPickupAddress;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RideDetailsPage(
          pickupAddress: pickup,
          destinationAddress: destination,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<DestinationBloc, DestinationState>(
          listener: (context, state) {
            if (state is DestinationLoaded && state.actionMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionMessage!),
                  duration: const Duration(milliseconds: 1400),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar: Circular Back Button + "Destination address" Title
                _buildTopAppBar(context),

                const SizedBox(height: 12),

                // Main Address Card: Pickup + Connector + Stops + Destination Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildAddressCard(context, state),
                ),

                const SizedBox(height: 14),

                // Action Buttons Row: "Select from Map" & "Add Stop"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildActionButtonsRow(context, state),
                ),

                const SizedBox(height: 14),

                // Quick Saved Places Chips: "(+) Home", "(+) Work", "(+) Others"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildQuickPlacesChips(context),
                ),

                const SizedBox(height: 16),

                // Suggestions / Recent Destinations List
                Expanded(
                  child: _buildSuggestionsList(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Top App Bar matching screenshot: Circular subtle back button + bold title
  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          // Circular Back Button
          Material(
            color: const Color(0xFFF1F3F5),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Center(
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: Color(0xFF0F172A),
                    size: 26,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title: "Destination address"
          const Text(
            'Destination address',
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Main Card matching screenshot: Pickup row with green ring + dotted connector + destination row with red ring
  Widget _buildAddressCard(BuildContext context, DestinationState state) {
    final loadedState = state is DestinationLoaded ? state : null;
    final stops = loadedState?.stops ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          // 1. Pickup Address Row
          Row(
            children: [
              // Concentric Green Pickup Circle Icon
              _buildGreenPickupIcon(),

              const SizedBox(width: 14),

              // Pickup Text / Field
              Expanded(
                child: Text(
                  _pickupController.text.isNotEmpty
                      ? _pickupController.text
                      : 'Enter pickup address',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: _pickupController.text.isNotEmpty
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ),

              // Clear Button (small circular x)
              if (_pickupController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _pickupController.clear();
                    context.read<DestinationBloc>().add(const ClearPickupEvent());
                    setState(() {});
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F3F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
            ],
          ),

          // 2. Connector: 3 vertical dots + subtle divider
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                _buildDottedConnector(),
                const Expanded(
                  child: Divider(
                    color: Color(0xFFF1F5F9),
                    thickness: 1,
                    indent: 20,
                  ),
                ),
              ],
            ),
          ),

          // 3. Dynamic Stops (if any added via "Add Stop")
          ...stops.asMap().entries.map((entry) {
            final index = entry.key;
            final stopText = entry.value;

            return Column(
              children: [
                Row(
                  children: [
                    // Stop Circle Icon (Amber)
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF59E0B),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.location_on, color: Colors.white, size: 10),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        stopText.isNotEmpty ? stopText : 'Stop ${index + 1} address',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: stopText.isNotEmpty
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<DestinationBloc>().add(RemoveStopEvent(index));
                      },
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      _buildDottedConnector(),
                      const Expanded(
                        child: Divider(
                          color: Color(0xFFF1F5F9),
                          thickness: 1,
                          indent: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          // 4. Destination Address Row
          Row(
            children: [
              // Concentric Red Destination Circle Icon
              _buildRedDestinationIcon(),

              const SizedBox(width: 14),

              // Destination Input Field
              Expanded(
                child: TextField(
                  controller: _destinationController,
                  focusNode: _destinationFocusNode,
                  cursorColor: const Color(0xFF4F46E5), // Purple/Indigo cursor like screenshot
                  cursorWidth: 2,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Destination address',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (query) {
                    context.read<DestinationBloc>().add(SearchQueryChangedEvent(query));
                    setState(() {});
                  },
                  onSubmitted: (query) {
                    if (query.trim().isNotEmpty) {
                      _navigateToRideDetails(query.trim());
                    }
                  },
                ),
              ),

              // Clear Destination Button
              if (_destinationController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _destinationController.clear();
                    context.read<DestinationBloc>().add(const ClearDestinationEvent());
                    setState(() {});
                  },
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F3F5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Green Concentric Circle Icon (Matching Google Maps pickup ring in screenshot)
  Widget _buildGreenPickupIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
            ),
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Red Concentric Circle Icon (Matching Destination red circle in screenshot)
  Widget _buildRedDestinationIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
            ),
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDC2626),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 3 Vertical Dotted Connector
  Widget _buildDottedConnector() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          width: 3,
          height: 3,
          margin: const EdgeInsets.symmetric(vertical: 1.5),
          decoration: const BoxDecoration(
            color: Color(0xFFCBD5E1),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  /// Action Buttons: "Select from Map" & "Add Stop" (Rounded pill outlines in screenshot)
  Widget _buildActionButtonsRow(BuildContext context, DestinationState state) {
    return Row(
      children: [
        // "Select from Map" Button
        Expanded(
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () {
                context.read<DestinationBloc>().add(const SelectFromMapEvent());
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      color: Color(0xFF0F172A),
                      size: 19,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Select from Map',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // "Add Stop" Button
        Expanded(
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () {
                context.read<DestinationBloc>().add(const AddStopEvent());
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_location_alt_outlined,
                      color: Color(0xFF0F172A),
                      size: 19,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Stop',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Quick Places Chips matching screenshot: "(+) Home", "(+) Work", "(+) Others"
  Widget _buildQuickPlacesChips(BuildContext context) {
    return Row(
      children: [
        _buildChipItem(
          label: 'Home',
          onTap: () {
            context.read<DestinationBloc>().add(const QuickPlaceTappedEvent('home'));
            _destinationController.text = 'Home';
            setState(() {});
            _navigateToRideDetails('Home');
          },
        ),
        const SizedBox(width: 10),
        _buildChipItem(
          label: 'Work',
          onTap: () {
            context.read<DestinationBloc>().add(const QuickPlaceTappedEvent('work'));
            _destinationController.text = 'Work Office';
            setState(() {});
            _navigateToRideDetails('Work Office');
          },
        ),
        const SizedBox(width: 10),
        _buildChipItem(
          label: 'Others',
          onTap: () {
            context.read<DestinationBloc>().add(const QuickPlaceTappedEvent('others'));
            _destinationController.text = 'Others';
            setState(() {});
            _navigateToRideDetails('Others');
          },
        ),
      ],
    );
  }

  /// Individual chip capsule with plus circle icon
  Widget _buildChipItem({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFFF1F3F5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF94A3B8), width: 1.2),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Suggestions and Recent Destinations List
  Widget _buildSuggestionsList(BuildContext context, DestinationState state) {
    if (state is DestinationLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (state is DestinationLoaded) {
      final results = state.searchResults;

      if (results.isEmpty) {
        return const Center(
          child: Text(
            'No locations found. Try a different search.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13.5),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: results.length,
        separatorBuilder: (context, index) => const Divider(
          color: Color(0xFFF1F5F9),
          height: 1,
          indent: 52,
        ),
        itemBuilder: (context, index) {
          final place = results[index];

          IconData leadingIcon;
          Color leadingColor;
          if (place.tag == 'home') {
            leadingIcon = Icons.home_rounded;
            leadingColor = const Color(0xFF3B82F6);
          } else if (place.tag == 'work') {
            leadingIcon = Icons.work_rounded;
            leadingColor = const Color(0xFFF59E0B);
          } else if (place.tag == 'station') {
            leadingIcon = Icons.train_rounded;
            leadingColor = const Color(0xFF10B981);
          } else if (place.tag == 'mall') {
            leadingIcon = Icons.shopping_bag_rounded;
            leadingColor = const Color(0xFF8B5CF6);
          } else {
            leadingIcon = Icons.location_on_rounded;
            leadingColor = const Color(0xFF64748B);
          }

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: leadingColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(leadingIcon, color: leadingColor, size: 20),
            ),
            title: Text(
              place.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            subtitle: Text(
              place.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
              ),
            ),
            trailing: place.distance.isNotEmpty
                ? Text(
                    place.distance,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  )
                : null,
            onTap: () {
              _destinationController.text = place.title;
              context.read<DestinationBloc>().add(SelectDestinationAddressEvent(place));
              _navigateToRideDetails(place.title);
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
