export const idlFactory = ({ IDL }: { IDL: any }) => {
  const ApiError = IDL.Record({ code: IDL.Nat32, message: IDL.Text })
  const ApiResult = (T: any) => IDL.Variant({ ok: T, err: ApiError })
  const UserProfile = IDL.Record({
    principal: IDL.Text,
    username: IDL.Text,
    role: IDL.Text,
    createdAt: IDL.Int,
  })
  const Feature = IDL.Record({
    id: IDL.Text,
    name: IDL.Text,
    owner: IDL.Principal,
    createdAt: IDL.Int,
  })
  const HealthStatus = IDL.Record({
    status: IDL.Text,
    version: IDL.Text,
    featureCount: IDL.Nat,
    userCount: IDL.Nat,
  })

  return IDL.Service({
    ping: IDL.Func([], [IDL.Text], ["query"]),
    status: IDL.Func([], [HealthStatus], ["query"]),
    register: IDL.Func([IDL.Text], [ApiResult(UserProfile)], []),
    me: IDL.Func([], [ApiResult(UserProfile)], ["query"]),
    createFeature: IDL.Func([IDL.Text], [ApiResult(Feature)], []),
    getFeature: IDL.Func([IDL.Text], [IDL.Opt(Feature)], ["query"]),
    listFeatures: IDL.Func(
      [IDL.Nat, IDL.Nat],
      [ApiResult(IDL.Record({ items: IDL.Vec(Feature), total: IDL.Nat }))],
      ["query"],
    ),
  })
}
