import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import Principal "mo:base/Principal";
// import Time "mo:base/Time";

// import CertifiedData "mo:base/CertifiedData";
import CertTree "mo:cert/CertTree";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "mo:icrc2-mo/ICRC2";
import ICRC3 "mo:icrc3-mo/";
import ICRC4 "mo:icrc4-mo/ICRC4";

shared ({ caller = _owner }) actor class Token  (args: ?{
    icrc1 : ?ICRC1.InitArgs;
    icrc2 : ?ICRC2.InitArgs;
    icrc3 : ICRC3.InitArgs; //already typed nullable
    icrc4 : ?ICRC4.InitArgs;
  }
) = this{

    let default_icrc1_args : ICRC1.InitArgs = {
      name = ?"Waste2Earn";
      symbol = ?"Waste";
      logo = ?"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAEbGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczpBdHRyaWI9J2h0dHA6Ly9ucy5hdHRyaWJ1dGlvbi5jb20vYWRzLzEuMC8nPgogIDxBdHRyaWI6QWRzPgogICA8cmRmOlNlcT4KICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPgogICAgIDxBdHRyaWI6Q3JlYXRlZD4yMDI0LTExLTE5PC9BdHRyaWI6Q3JlYXRlZD4KICAgICA8QXR0cmliOkV4dElkPjE8L0F0dHJpYjpFeHRJZD4KICAgICA8QXR0cmliOkZiSWQ+NTI1MjY1OTE0MTc5NTgwPC9BdHRyaWI6RmJJZD4KICAgICA8QXR0cmliOlRvdWNoVHlwZT4yPC9BdHRyaWI6VG91Y2hUeXBlPgogICAgPC9yZGY6bGk+CiAgIDwvcmRmOlNlcT4KICA8L0F0dHJpYjpBZHM+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJwogIHhtbG5zOmRjPSdodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyc+CiAgPGRjOnRpdGxlPgogICA8cmRmOkFsdD4KICAgIDxyZGY6bGkgeG1sOmxhbmc9J3gtZGVmYXVsdCc+VzJFTiAtIDE8L3JkZjpsaT4KICAgPC9yZGY6QWx0PgogIDwvZGM6dGl0bGU+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJwogIHhtbG5zOnBkZj0naHR0cDovL25zLmFkb2JlLmNv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";
      decimals = 8;
      fee = ?#Fixed(10000);
      minting_account = ?{
        owner = _owner;
        subaccount = null;
      };
      max_supply = null;
      min_burn_amount = ?10000;
      max_memo = ?64;
      advanced_settings = null;
      metadata = null;
      fee_collector = null;
      transaction_window = null;
      permitted_drift = null;
      max_accounts = ?1000000000;
      settle_to_accounts = ?99999000;
    };

    let default_icrc2_args : ICRC2.InitArgs = {
      max_approvals_per_account = ?10000;
      max_allowance = ?#TotalSupply;
      fee = ?#ICRC1;
      advanced_settings = null;
      max_approvals = ?10000000;
      settle_to_approvals = ?9990000;
    };

    let default_icrc3_args : ICRC3.InitArgs = ?{
      maxActiveRecords = 3000;
      settleToRecords = 2000;
      maxRecordsInArchiveInstance = 100000000;
      maxArchivePages = 62500;
      archiveIndexType = #Stable;
      maxRecordsToArchive = 8000;
      archiveCycles = 6_000_000_000_000;
      archiveControllers = null;//??[put cycle ops prinicpal here];
      supportedBlocks = [
        {
          block_type = "1xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2approve"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1mint"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1burn"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        }
      ];
    };

    let default_icrc4_args : ICRC4.InitArgs = {
      max_balances = ?200;
      max_transfers = ?200;
      fee = ?#ICRC1;
    };

    let icrc1_args : ICRC1.InitArgs = switch(args){
      case(null) default_icrc1_args;
      case(?args){
        switch(args.icrc1){
          case(null) default_icrc1_args;
          case(?val){
            {
              val with minting_account = switch(
                val.minting_account){
                  case(?val) ?val;
                  case(null) {?{
                    owner = _owner;
                    subaccount = null;
                  }};
                };
            };
          };
        };
      };
    };

    let icrc2_args : ICRC2.InitArgs = switch(args){
      case(null) default_icrc2_args;
      case(?args){
        switch(args.icrc2){
          case(null) default_icrc2_args;
          case(?val) val;
        };
      };
    };


    let icrc3_args : ICRC3.InitArgs = switch(args){
      case(null) default_icrc3_args;
      case(?args){
        switch(args.icrc3){
          case(null) default_icrc3_args;
          case(?val) ?val;
        };
      };
    };

    let icrc4_args : ICRC4.InitArgs = switch(args){
      case(null) default_icrc4_args;
      case(?args){
        switch(args.icrc4){
          case(null) default_icrc4_args;
          case(?val) val;
        };
      };
    };

    stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id),?icrc1_args, _owner);
    stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id),?icrc2_args, _owner);
    stable let icrc4_migration_state = ICRC4.init(ICRC4.initialState(), #v0_1_0(#id),?icrc4_args, _owner);
    stable let icrc3_migration_state = ICRC3.init(ICRC3.initialState(), #v0_1_0(#id), icrc3_args, _owner);
    stable let cert_store : CertTree.Store = CertTree.newStore();
    let ct = CertTree.Ops(cert_store);


    stable var owner = _owner;

    let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;

    private var _icrc1 : ?ICRC1.ICRC1 = null;

    private func get_icrc1_state() : ICRC1.CurrentState {
      return icrc1_state_current;
    };

    private func get_icrc1_environment() : ICRC1.Environment {
    {
      get_time = null;
      get_fee = null;
      add_ledger_transaction = ?icrc3().add_record;
      can_transfer = null; //set to a function to intercept and add validation logic for transfers
    };
  };

    func icrc1() : ICRC1.ICRC1 {
    switch(_icrc1){
      case(null){
        let initclass : ICRC1.ICRC1 = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        ignore initclass.register_supported_standards({
          name = "ICRC-3";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-3/"
        });
        ignore initclass.register_supported_standards({
          name = "ICRC-10";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-10/"
        });
        _icrc1 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_state() : ICRC2.CurrentState {
    return icrc2_state_current;
  };

  private func get_icrc2_environment() : ICRC2.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc2() : ICRC2.ICRC2 {
    switch(_icrc2){
      case(null){
        let initclass : ICRC2.ICRC2 = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc4_state_current)) = icrc4_migration_state;

  private var _icrc4 : ?ICRC4.ICRC4 = null;

  private func get_icrc4_state() : ICRC4.CurrentState {
    return icrc4_state_current;
  };

  private func get_icrc4_environment() : ICRC4.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc4() : ICRC4.ICRC4 {
    switch(_icrc4){
      case(null){
        let initclass : ICRC4.ICRC4 = ICRC4.ICRC4(?icrc4_migration_state, Principal.fromActor(this), get_icrc4_environment());
        _icrc4 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc3_state_current)) = icrc3_migration_state;

  private var _icrc3 : ?ICRC3.ICRC3 = null;

  private func get_icrc3_state() : ICRC3.CurrentState {
    return icrc3_state_current;
  };

  func get_state() : ICRC3.CurrentState{
    return icrc3_state_current;
  };

  private func get_icrc3_environment() : ICRC3.Environment {
    ?{
      updated_certification = ?updated_certification;
      get_certificate_store = ?get_certificate_store;
    };
  };

  func ensure_block_types(icrc3Class: ICRC3.ICRC3) : () {
    let supportedBlocks = Buffer.fromIter<ICRC3.BlockType>(icrc3Class.supported_block_types().vals());

    let blockequal = func(a : {block_type: Text}, b : {block_type: Text}) : Bool {
      a.block_type == b.block_type;
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2approve";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2approve"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1mint";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1mint"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1burn";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1burn"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    icrc3Class.update_supported_blocks(Buffer.toArray(supportedBlocks));
  };

  func icrc3() : ICRC3.ICRC3 {
    switch(_icrc3){
      case(null){
        let initclass : ICRC3.ICRC3 = ICRC3.ICRC3(?icrc3_migration_state, Principal.fromActor(this), get_icrc3_environment());
        _icrc3 := ?initclass;
        ensure_block_types(initclass);

        initclass;
      };
      case(?val) val;
    };
  };

  private func updated_certification(cert: Blob, lastIndex: Nat) : Bool{

    // D.print("updating the certification " # debug_show(CertifiedData.getCertificate(), ct.treeHash()));
    ct.setCertifiedData();
    // D.print("did the certification " # debug_show(CertifiedData.getCertificate()));
    return true;
  };

  private func get_certificate_store() : CertTree.Store {
    // D.print("returning cert store " # debug_show(cert_store));
    return cert_store;
  };

  /// Functions for the ICRC1 token standard
  public shared query func icrc1_name() : async Text {
      icrc1().name();
  };

  public shared query func icrc1_symbol() : async Text {
      icrc1().symbol();
  };

  public shared query func icrc1_decimals() : async Nat8 {
      icrc1().decimals();
  };

  public shared query func icrc1_fee() : async ICRC1.Balance {
      icrc1().fee();
  };

  public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
      icrc1().metadata()
  };

  public shared query func icrc1_total_supply() : async ICRC1.Balance {
      icrc1().total_supply();
  };

  public shared query func icrc1_minting_account() : async ?ICRC1.Account {
      ?icrc1().minting_account();
  };

  public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
      icrc1().balance_of(args);
  };

  public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared query func icrc10_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
      switch(await* icrc1().transfer_tokens(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
      if(caller != owner){ D.trap("Unauthorized")};

      switch( await* icrc1().mint_tokens(caller, args)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
      switch( await*  icrc1().burn_tokens(caller, args, false)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

   public query ({ caller }) func icrc2_allowance(args: ICRC2.AllowanceArgs) : async ICRC2.Allowance {
      return icrc2().allowance(args.spender, args.account, false);
    };

  public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
      switch(await*  icrc2().approve_transfers(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
      switch(await* icrc2().transfer_tokens_from(caller, args, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public query func icrc3_get_blocks(args: ICRC3.GetBlocksArgs) : async ICRC3.GetBlocksResult{
    return icrc3().get_blocks(args);
  };

  public query func icrc3_get_archives(args: ICRC3.GetArchivesArgs) : async ICRC3.GetArchivesResult{
    return icrc3().get_archives(args);
  };

  public query func icrc3_get_tip_certificate() : async ?ICRC3.DataCertificate {
    return icrc3().get_tip_certificate();
  };

  public query func icrc3_supported_block_types() : async [ICRC3.BlockType] {
    return icrc3().supported_block_types();
  };

  public query func get_tip() : async ICRC3.Tip {
    return icrc3().get_tip();
  };

  public shared ({ caller }) func icrc4_transfer_batch(args: ICRC4.TransferBatchArgs) : async ICRC4.TransferBatchResults {
      switch(await* icrc4().transfer_batch_tokens(caller, args, null, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) err;
        case(#err(#awaited(err))) err;
      };
  };

  public shared query func icrc4_balance_of_batch(request : ICRC4.BalanceQueryArgs) : async ICRC4.BalanceQueryResult {
      icrc4().balance_of_batch(request);
  };

  public shared query func icrc4_maximum_update_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_transfers;
  };

  public shared query func icrc4_maximum_query_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_balances;
  };

  public shared ({ caller }) func admin_update_owner(new_owner : Principal) : async Bool {
    if(caller != owner){ D.trap("Unauthorized")};
    owner := new_owner;
    return true;
  };

  public shared ({ caller }) func admin_update_icrc1(requests : [ICRC1.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc1().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc2(requests : [ICRC2.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc2().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc4(requests : [ICRC4.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc4().update_ledger_info(requests);
  };

  /* /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_listener(trx: ICRC1.Transaction, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func approval_listener(trx: ICRC2.TokenApprovalNotification, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_from_listener(trx: ICRC2.TransferFromNotification, trxid: Nat) : () {

  }; */

  private stable var _init = false;
  public shared(msg) func admin_init() : async () {
    //can only be called once


    if(_init == false){
      //ensure metadata has been registered
      let test1 = icrc1().metadata();
      let test2 = icrc2().metadata();
      let test4 = icrc4().metadata();
      let test3 = icrc3().stats();

      //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener<system>("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener<system>("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener<system>("my_namespace", transfer_from_listener);
    };
    _init := true;
  };


  // Deposit cycles into this canister.
  public shared func deposit_cycles() : async () {
      let amount = ExperimentalCycles.available();
      let accepted = ExperimentalCycles.accept<system>(amount);
      assert (accepted == amount);
  };

  system func postupgrade() {
    //re wire up the listener after upgrade
    //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener("my_namespace", transfer_from_listener);
  };

};
