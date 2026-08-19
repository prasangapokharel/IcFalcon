import Principal "mo:core/Principal";

module {
  public type Config = {
    devMode : Bool;
    devCaller : ?Principal;
  };

  public func prodConfig() : Config {
    { devMode = false; devCaller = null };
  };

  public func devConfig(caller : Principal) : Config {
    { devMode = true; devCaller = ?caller };
  };

  public func effectiveCaller(config : Config, caller : Principal) : Principal {
    if (config.devMode) {
      switch (config.devCaller) {
        case (?principal) { principal };
        case (null) { caller };
      };
    } else {
      caller;
    };
  };
};
