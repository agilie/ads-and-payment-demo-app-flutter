class NoItemError extends Error {
  String message = "";

  NoItemError(this.message);

  NoItemError.noId(int id) {
    message = "There is no item with id == $id";
  }

  NoItemError.fromToString(Object obj) {
    message = "There is no item ${obj.toString()} with hash == ${obj.hashCode}";
  }

  @override
  String toString() {
    return message;
  }
}


class NotImplementedException extends Error {
  String message = "";

  NotImplementedException(this.message);

  NotImplementedException.inClass(Object obj) {
    message = "Unimplemented function in == ${obj.runtimeType.toString()}";
  }

  @override
  String toString() {
    return message;
  }


}
