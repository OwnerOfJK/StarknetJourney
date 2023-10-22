use starknet::{ContractAddress, TryInto, Into, OptionTrait};
use array::{ArrayTrait, SpanTrait};
use result::ResultTrait;

use snforge_std::{declare, ContractClassTrait};
use snforge_std::io::{FileTrait, read_txt};

use demo::{IOwnableTraitDispatcher, IOwnableTraitDispatcherTrait};
use demo::{IDataDispatcher, IDataDispatcherTrait};

mod Errors {
    const INVALID_OWNER: felt252 = 'Caller is not the owner';
    const INVALID_DATA: felt252 = 'Invalid data';
}

mod Accounts {
    use traits::TryInto;
    use starknet::{ContractAddress};

    fn admin() -> ContractAddress {
        'admin'.try_into().unwrap()
    }

    fn user() -> ContractAddress {
        'user'.try_into().unwrap()
    }

    fn bad_guy() -> ContractAddress {
        'bad_guy'.try_into().unwrap()
    }
}

// //Option 1: standard practice
// fn deploy_contract(name: felt252) -> ContractAddress {

//     let account: ContractAddress = Accounts::admin();

//     let contract = declare(name);

//     //calldata
//     let mut calldata = array![account.into()];

//     //deploy contract
//     contract.deploy(@calldata).unwrap()
// }

// #[test]
// fn test_construct_with_admin() {
//     let contract_address = deploy_contract('ownable');

//     assert(1 == 1, 'error');
// }

//Option 2: if we work with a txt calldata (see data folder)
fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);

    //calldata to access txt file
    let file = FileTrait::new('data/calldata.txt');
    let calldata = read_txt(@file);

    //deploy contract
    contract.deploy(@calldata).unwrap()
}

#[test]
fn test_construct_with_admin() {
    let contract_address = deploy_contract('ownable');

    let dispatcher = IOwnableTraitDispatcher { contract_address };

    let owner = dispatcher.get_owner();

    assert(Accounts::admin() == owner, Errors::INVALID_OWNER);
}

use snforge_std::{start_prank, stop_prank};
#[test]
fn test_transfer_ownership() {
    let contract_address = deploy_contract('ownable');

    let dispatcher = IOwnableTraitDispatcher { contract_address };

    start_prank(contract_address, Accounts::admin());

    dispatcher.transfer_ownership(Accounts::user());

    let owner = dispatcher.get_owner();

    assert(Accounts::user() == owner, Errors::INVALID_OWNER);

    stop_prank(contract_address);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('Caller is not the owner',))]
fn test_transfer_ownership_to_bad_guy() {
    let contract_address = deploy_contract('ownable');

    let dispatcher = IOwnableTraitDispatcher { contract_address };

    start_prank(contract_address, Accounts::bad_guy());

    dispatcher.transfer_ownership(Accounts::bad_guy());

    let owner = dispatcher.get_owner();

    assert(Accounts::bad_guy() == owner, Errors::INVALID_OWNER);

    stop_prank(contract_address);
}

use snforge_std::{start_mock_call, stop_mock_call};

#[test]
fn test_data_with_start_mock_call_get_data() {
    let contract_address = deploy_contract('ownable');

    let dispatcher = IDataDispatcher { contract_address };

    let mock_return_data = 100;

    start_mock_call(contract_address, 'get_data', mock_return_data);

    start_prank(contract_address, Accounts::admin());

    dispatcher.set_data(20);

    let data = dispatcher.get_data();

    assert(data == mock_return_data, Errors::INVALID_DATA);

    stop_mock_call(contract_address, 'get_data');
    stop_prank(contract_address);
}
