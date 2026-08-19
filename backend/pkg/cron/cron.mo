import Time "mo:core/Time";

module {
  public type Job = { interval : Int; var lastRun : Int; run : () -> () };
  public func shouldRun(job : Job) : Bool { Time.now() >= job.lastRun + job.interval };
  public func tick(job : Job) : () {
    if (shouldRun(job)) { job.run(); job.lastRun := Time.now() };
  };
};
