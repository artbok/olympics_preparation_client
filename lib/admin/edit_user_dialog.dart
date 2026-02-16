import "package:flutter/material.dart";
import "package:olympics_preparation_client/requests/edit_user.dart";
import "package:olympics_preparation_client/requests/delete_user.dart";

void changedUserDialog(
  BuildContext contex,
  String editUserName,
  VoidCallback refreshPage,
) {
  editUser(editUserName);
  refreshPage();
}

void deleteUserDialog(
  BuildContext contex,
  String deleteUserName,
  VoidCallback refreshPage,
) {
  deleteUser(deleteUserName);
  refreshPage();
}
