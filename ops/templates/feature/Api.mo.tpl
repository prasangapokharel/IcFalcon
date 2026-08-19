import Types "../../types";
import {{Name}}Service "../../services/{{Name}}Service";
import MiddlewareAuth "../../middleware/Auth";

mixin (
  service : {{Name}}Service.{{Name}}Service,
  mwConfig : MiddlewareAuth.Config,
) {
  public shared ({ caller }) func create{{Name}}(name : Text) : async Types.ApiResult<Types.{{Name}}> {
    await {{Name}}Service.create{{Name}}(
      service,
      MiddlewareAuth.effectiveCaller(mwConfig, caller),
      name,
    );
  };

  public query func get{{Name}}(id : Text) : async ?Types.{{Name}} {
    {{Name}}Service.get{{Name}}(service, id);
  };

  public query func list{{Name}}s(offset : Nat, limit : Nat) : async Types.ApiResult<{ items : [Types.{{Name}}]; total : Nat }> {
    {{Name}}Service.list{{Name}}s(service, offset, limit);
  };
};
