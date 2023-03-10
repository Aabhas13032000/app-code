part of provider;

class MainContainerProvider extends ChangeNotifier {
  int _index = 0;
  ListQueue<int> _navigationQueue = ListQueue();
  List<CurectCategories> _clothCategories = [];
  List<CurectCategories> _productCategories = [];
  Address? _userDefaultAddress;
  bool _isRefreshed = false;
  bool _isAddressRefreshed = false;
  List<Food> _searchedFood = [];
  List<Exercise> _searchedExercise = [];
  List<Comment> _comments = [];
  Users? _user;
  double _priceToPay = 0;
  String _address = '';
  bool _present = false;
  String _stateDropdownValue = '';
  String _cityDropdownValue = '';
  List<StateCity> _states = [];
  List<StateCity> _cities = [];
  List<String> _slider = [];

  int get currentIndex => _index;
  ListQueue<int> get navigationQueue => _navigationQueue;
  bool get isRefreshed => _isRefreshed;
  bool get isAddressRefreshed => _isAddressRefreshed;
  List<Food> get searchedFood => _searchedFood;
  List<Exercise> get searchedExercise => _searchedExercise;
  List<Comment> get comments => _comments;
  List<CurectCategories> get clothCategories => _clothCategories;
  List<CurectCategories> get productCategories => _productCategories;
  Users? get user => _user;
  Address? get userDefaultAddress => _userDefaultAddress;
  double get priceToPay => _priceToPay;
  String get address => _address;
  String get stateDropdownValue => _stateDropdownValue;
  String get cityDropdownValue => _cityDropdownValue;
  bool get present => _present;
  List<StateCity> get states => _states;
  List<StateCity> get cities => _cities;
  List<String> get slider => _slider;

  void setIndex(value) {
    _index = value;
    notifyListeners();
  }

  void setSlider(value) {
    _slider = value;
    notifyListeners();
  }

  void setRefreshValue(value) {
    _isRefreshed = value;
    notifyListeners();
  }

  void setStateValue(value) {
    _stateDropdownValue = value;
    notifyListeners();
  }

  void setCityValue(value) {
    _cityDropdownValue = value;
    notifyListeners();
  }

  void setStates(value) {
    _states = value;
    notifyListeners();
  }

  void setCities(value) {
    _cities = value;
    notifyListeners();
  }

  void setUserDefaultAddress(value) {
    _userDefaultAddress = value;
    notifyListeners();
  }

  void setAddressRefreshValue(value) {
    _isAddressRefreshed = value;
    notifyListeners();
  }

  void setSearchedFood(value) {
    _searchedFood = value;
    notifyListeners();
  }

  void setSearchedExercise(value) {
    _searchedExercise = value;
    notifyListeners();
  }

  void setComment(value) {
    _comments = value;
    notifyListeners();
  }

  void setUserData(value) {
    _user = value;
    notifyListeners();
  }

  void setClothCategory(value) {
    _clothCategories = value;
    notifyListeners();
  }

  void setProductCategory(value) {
    _productCategories = value;
    notifyListeners();
  }

  void setProgramData(price, address, presentValue) {
    _address = address;
    _priceToPay = price;
    _present = presentValue;
    notifyListeners();
  }
}
