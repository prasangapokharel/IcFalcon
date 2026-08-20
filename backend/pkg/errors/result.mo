module {
  public type ApiError = { code : Nat32; message : Text };

  public type ApiResult<T> = { #ok : T; #err : ApiError };

  public func ok<T>(value : T) : ApiResult<T> {
    #ok(value);
  };

  public func err<T>(code : Nat32, message : Text) : ApiResult<T> {
    #err({ code; message });
  };

  public let unauthorized : Nat32 = 401;
  public let forbidden : Nat32 = 403;
  public let notFound : Nat32 = 404;
  public let badRequest : Nat32 = 400;
  public let conflict : Nat32 = 409;
  public let tooManyRequests : Nat32 = 429;
};
