import "package:flutter/material.dart";
import "package:olympics_preparation_client/admin/edit_user.dart";
import "package:olympics_preparation_client/admin/delete_user.dart";

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
