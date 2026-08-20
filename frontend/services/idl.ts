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
  const WalletDeposit = IDL.Record({
    icrcOwner: IDL.Principal,
    icrcSubaccount: IDL.Opt(IDL.Vec(IDL.Nat8)),
    accountIdHex: IDL.Text,
    qrPayload: IDL.Text,
  })
  const WalletBalance = IDL.Record({
    amount: IDL.Nat,
    symbol: IDL.Text,
    decimals: IDL.Nat8,
  })
  const TxView = IDL.Record({
    id: IDL.Text,
    kind: IDL.Text,
    amount: IDL.Nat,
    fee: IDL.Nat,
    status: IDL.Text,
    blockIndex: IDL.Opt(IDL.Nat),
    createdAt: IDL.Int,
  })
  const TransferPreview = IDL.Record({
    transferId: IDL.Text,
    toPrincipal: IDL.Text,
    amount: IDL.Nat,
    fee: IDL.Nat,
    totalDebit: IDL.Nat,
    balance: IDL.Nat,
  })
  const SendTransferResult = IDL.Record({
    transferId: IDL.Text,
    blockIndex: IDL.Nat,
  })
  const TreasurySummary = IDL.Record({
    registeredWallets: IDL.Nat,
    symbol: IDL.Text,
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
    registerWallet: IDL.Func([], [ApiResult(WalletDeposit)], []),
    depositInfo: IDL.Func([], [ApiResult(WalletDeposit)], ["query"]),
    getBalance: IDL.Func([], [ApiResult(WalletBalance)], []),
    proposeTransfer: IDL.Func(
      [IDL.Text, IDL.Text, IDL.Nat],
      [ApiResult(TransferPreview)],
      [],
    ),
    executeTransfer: IDL.Func(
      [IDL.Text, IDL.Text, IDL.Nat],
      [ApiResult(SendTransferResult)],
      [],
    ),
    sendTransfer: IDL.Func(
      [IDL.Text, IDL.Text, IDL.Nat],
      [ApiResult(SendTransferResult)],
      [],
    ),
    listTransactions: IDL.Func(
      [IDL.Nat, IDL.Nat],
      [ApiResult(IDL.Record({ items: IDL.Vec(TxView), total: IDL.Nat }))],
      ["query"],
    ),
    adminTreasury: IDL.Func([], [ApiResult(TreasurySummary)], ["query"]),
  })
}
