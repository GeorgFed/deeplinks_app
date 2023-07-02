class NavigationState {
  final bool? _unknown;
  final bool? _cart;

  String? selectedItemId;

  bool get isCart => _cart == true;

  bool get isDetailsScreen => selectedItemId != null;

  bool get isRoot => !isCart && !isDetailsScreen && !isUnknown;

  bool get isUnknown => _unknown == true;

  NavigationState.root()
      : _cart = false,
        _unknown = false,
        selectedItemId = null;

  NavigationState.cart()
      : _cart = true,
        _unknown = false,
        selectedItemId = null;

  NavigationState.item(this.selectedItemId)
      : _cart = false,
        _unknown = false;

  NavigationState.unknown()
      : _unknown = true,
        _cart = false,
        selectedItemId = null;
}
