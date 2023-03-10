part of common;

class AlertMessages {
  static String getMessage(int id) {
    switch (id) {
      //Common Messages
      case 1:
        return 'Please login to pay';
      case 2:
        return 'Not able to download';
      case 3:
        return 'Are you sure ? you want to delete the profile image';
      case 4:
        return 'Some error occurred!!';
      case 5:
        return 'Please enter a valid phone number';
      case 6:
        return 'Please enter the phone number correctly';
      case 7:
        return 'An OTP is sent to this mobile number';
      case 8:
        return 'Otp verified successfully, thank you for logging in.';
      case 9:
        return 'You reached maximum OTP requests, Please try after some time.';
      case 10:
        return 'Profile created successfully!!';
      case 11:
        return 'Profile blocked by admin, Login with another phone number or contact us at contact@healfit.in!';
      case 12:
        return 'Profile updated successfully!!';
      case 13:
        return 'Meeting not started yet!!';
      case 14:
        return 'Payment success!!';
      case 15:
        return 'Payment failed!!';
      case 16:
        return 'Item removed successfully from cart!!';
      case 17:
        return 'Are you sure you want to remove this item from cart!!';
      case 18:
        return 'Are you sure you want to logout from application!!';
      case 19:
        return 'You are successfully logged out!!';
      case 20:
        return 'Successfully added to cart!!';
      case 21:
        return 'Selected combination is not available , Please try a different one!!';
      case 22:
        return 'Already purchased , some sessions left. Please go to my programs page!! or Please try a different one!!';
      case 23:
        return 'Already added to cart , check there';
      case 24:
        return 'Removed successfully!!';
      case 25:
        return 'Are you sure you want to remove this data?';
      case 26:
        return 'Are you sure you want to remove selected food item?';
      case 27:
        return 'Food Calorie added successfully';
      case 28:
        return 'Please enter number of servings';
      case 29:
        return 'Enter all the values first';
      case 30:
        return 'Enjoy seamless experience by updating to our new version!!';
      case 31:
        return 'Workout log added successfully';
      case 32:
        return 'Please write a comment';
      case 33:
        return 'Comment added successfully';
      case 34:
        return 'Product is out of stock';
      case 35:
        return 'Please select a size first';
      case 36:
        return 'Are you sure you want to remove this address!!';
      case 37:
        return 'Address removed successfully!!';
      case 38:
        return 'Are you sure, you want to cancel the order?';
      case 39:
        return 'Order cancelled sucessfully?';
      case 40:
        return 'Please add address';
      case 41:
        return 'Please select a address first';
      case 42:
        return 'Please enter your full name';
      case 43:
        return 'Please enter a 10-digit phone number';
      case 44:
        return 'Please enter a correct pincode';
      case 45:
        return 'Please enter a flat-no';
      case 46:
        return 'Please enter an area';
      case 47:
        return 'Please provide a landmark';
      case 48:
        return 'Please selact a city';
      case 49:
        return 'Please selact a state';
      case 50:
        return 'Address added successfully !!';
      case 51:
        return 'Address edited successfully !!';
      case 52:
        return 'You reached maximum quantity in stock !!';
      case 53:
        return 'Its already at the lowest value!!';
      case 54:
        return 'Quantity updated successfully!!';
      case 55:
        return 'Payment option is not available for your region.';
      case 56:
        return 'Food Calorie edited successfully';

      default:
        return '';
    }
  }
}
