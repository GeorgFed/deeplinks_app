class NavigationState {
  bool? cart;
  String? selectedItemId;

  bool get isCart => cart == true;

  bool get isDetailsScreen => selectedItemId != null;

  bool get isRoot => !isCart && !isDetailsScreen;

  NavigationState(this.cart, this.selectedItemId);

  NavigationState.root()
      : cart = false,
        selectedItemId = null;

  NavigationState.cart()
      : cart = true,
        selectedItemId = null;

  NavigationState.item(this.selectedItemId) : cart = false;
}
