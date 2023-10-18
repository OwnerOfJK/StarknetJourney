use starknet::{ContractAddress};

#[starknet::interface]
trait IData<TContractState> {
    fn other_func(self: @TContractState, other_contract: ContractAddress) -> felt252;
    fn get_data(self: @TContractState) -> felt252;
    fn set_data(ref self: TContractState, new_value: felt252);
}

#[starknet::interface]
trait IOwnableTrait<TContractState> {
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
    fn get_owner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod ownable {
    use starknet::{ContractAddress, get_caller_address,};
    use super::{IData, IOwnableTrait, IDataDispatcherTrait, IDataDispatcher};

    #[storage]
    struct Storage {
        owner: ContractAddress,
        data: felt252,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnershipTransferred: OwnershipTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        #[key]
        prev_owner: ContractAddress,
        #[key]
        new_owner: ContractAddress,
    }


    #[constructor]
    fn constructor(
        ref self: ContractState, //always the first argument
         initial_owner: ContractAddress,
    ) {
        self.owner.write(initial_owner); //to write to the storage you always need "self"
    }

    #[external(v0)] //these functions can be called externally
    impl OwnableDataImpl of IData<ContractState> {
        fn other_func(self: @ContractState, other_contract: ContractAddress) -> felt252 {
            let dispatcher = IDataDispatcher { contract_address: other_contract };

            let data = dispatcher.get_data();
            data
        }

        fn get_data(self: @ContractState) -> felt252 {
            self.data.read() //if you add a semicolon it wont return anything
        }

        fn set_data(ref self: ContractState, new_value: felt252) {
            self.owner_only();
            self.data.write(new_value);
        }
    }

    #[external(v0)] //these functions can be called externally
    impl OwnableTraitImpl of IOwnableTrait<ContractState> {
        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            self.owner_only();
            let prev_owner = self.owner.read();
            assert(prev_owner != new_owner, 'Owners are the same');
            self.owner.write(new_owner);

            self
                .emit(
                    OwnershipTransferred {
                        prev_owner: prev_owner,
                        new_owner, //if same name the syntax used in prev_owner is not necessary.
                    }
                );
        }

        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }
    }


    #[generate_trait]
    impl PrivateMethods of PrivateMethodTraits {
        fn owner_only(self: @ContractState) {
            let caller = get_caller_address();
            assert(
                caller == self.owner.read(), 'No you do not'
            ) //this reads the owner address stored in storage
        }
    }
}
