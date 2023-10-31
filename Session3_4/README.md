# Cairo Basecamp 3: Starknet

![Screenshot 2023-10-12 at 14.42.39.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.42.39.png)

There is one class of the contract, however, each class can have various instances.

Instances have the storage

![Screenshot 2023-10-12 at 14.43.36.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.43.36.png)

invoke interacts with the instances of the contract.

![Screenshot 2023-10-12 at 14.44.04.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.44.04.png)

1. declare is uploading contract code to create a **contract class** (code is on starknet), register a new class
2. once its declared we can deploy it as an **contract** **instance**

![Screenshot 2023-10-12 at 14.44.48.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.44.48.png)

1. transactions arrives to the mempool
2. the sequencers (katana, madara) receive transactions and validate them and finally run the code/transaction against the state (get contract class code, create instance + storage)
3. block is produced the prover will generate the proof and it will get settled on ethereum

![Screenshot 2023-10-12 at 14.49.20.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.49.20.png)

a contract is a module, storage has to be declared

if you want data to be persistent they have to be declared within the storage

![Screenshot 2023-10-12 at 14.50.10.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.50.10.png)

when deploying the contract the constructor will initialise values (can only be called once)

![Screenshot 2023-10-12 at 14.53.05.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.53.05.png)

events allow you to output data that we do not want to store in storage (which is costly)

don’t forget derive

![Screenshot 2023-10-12 at 14.55.52.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.55.52.png)

functions to interact with the contract

external macro exposes the contract to interact

@ symbol is a snapshot which is a read-only variable (cannot be modified)

1. self: @ContractState —> snapshot (view)
2. ref self: ConctractState —> external (write)
   1. require a reference

![Screenshot 2023-10-12 at 14.58.41.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_14.58.41.png)

trait is an interface

functions are great, however, interfaces allows us to know what the functions are doing (its like prototypes)

- when cairo sees interfaces they generate structures to interact wiht the contract
- when functions are written will ensure you dont’ forget arguments

interfaces make it easier for others to integrate and interact with your contract

![Screenshot 2023-10-12 at 15.02.20.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_15.02.20.png)

how to implement an interface

wrap function in implement block (includes interface name)

- provides errors with interfaces not implemented correctly

interfaces will be part of standard (use interfaces!!

![Screenshot 2023-10-12 at 15.04.59.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_15.04.59.png)

dispatchers are structures that are automatically generated to more easily call your contract

import datadispatcher, Idatadispatcher

![Screenshot 2023-10-12 at 15.23.14.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_15.23.14.png)

If you would like to store anything, you have to add it to the contract storage.

Before we can use the contractaddress keyword, we have to import it from the starknet module.

![Screenshot 2023-10-12 at 15.29.10.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_15.29.10.png)

the self keyword allows you to write to the storage. in the case above we want to store the ContractAddress (stored in the initial_owner variable) within the storage.

![Screenshot 2023-10-12 at 15.38.14.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_15.38.14.png)

In the interafce we just declared two functions:

1. get_data a snapshot that returns a felt252
2. set_data that refers self, and takes in another argument without returning anything

![Screenshot 2023-10-12 at 16.07.06.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-12_at_16.07.06.png)

the impl keyword simply initialises the implementation of the interface.

1. interface prototypes the function
2. impl implements them
   1. import interface (that is outside the scope using “use super(outside)”
   2. in the implementation we do not need TContractState but use ContractState since we can use the actual data

**Self** keyword in cairo is explicit meaning you always have to pass in the state of the contract to the function.

![Screenshot 2023-10-15 at 12.23.39.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-15_at_12.23.39.png)

- you can use the #[generate_trait] when you want the compiler to automatically create interfaces for your functions. this works fine for private functions as not one else needs to interact with them.
- get_caller_address is a starknet imported function that gives you the account address of your contract wallet.

![Screenshot 2023-10-15 at 12.49.34.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-15_at_12.49.34.png)

structure of events

- first event list
- second event data definition, several data types can be added to the ownership transferred event struct. events are way cheaper than storage
- the following is a enum implementaion in the function to enum the event
  ![Screenshot 2023-10-15 at 12.55.20.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-15_at_12.55.20.png)

### Katana Deployment

**always declare first and then deploy**

1. install dojo, katana and starkli using dojoup
2. run `katana` to start JSON RPC
3. prepare katana account (wallet account) and katana key (private key)
4. source .env

   1. env:

   ```
   export STARKNET_RPC=http://0.0.0.0:5050
   export STARKNET_ACCOUNT=/Users/johnk/demos/StarknetJourney/StarknetJourney/Week3/exercise/demo/katana_account.json
   export STARKNET_KEYSTORE=/Users/johnk/demos/StarknetJourney/StarknetJourney/Week3/exercise/demo/katana_key.json
   ```

5. use scarb build to compile contract code to sierra
6. get class hash

   ```jsx
   starkli class-hash target/dev/demo_ownable.sierra.json
   ```

7. declare contract class (code is alr declared on the blockchain)

```jsx
starkli declare target/dev/demo_ownable.sierra.json
```

1. deploy contract class to create instance

```jsx
starkli deploy <class hash> <constructor parameter values>
```

Call contract functions for **snapshots**

```jsx
starkli call <contract instance adress> <function name> <function parameter values>
```

Call contract functions for **write functions**

```jsx
starkli invoke <contract instance adress> <function name> <function parameter values>
```

**Call other contracts**

- use dispatchers to interact with other contracts
  ![Screenshot 2023-10-15 at 14.42.55.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-15_at_14.42.55.png)
  ![Screenshot 2023-10-15 at 14.43.16.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-15_at_14.43.16.png)
  ![Screenshot 2023-10-15 at 14.42.43.png](Cairo%20Basecamp%203%20Starknet%20f08458c6cee74b2398d1d3f2da7caf3d/Screenshot_2023-10-15_at_14.42.43.png)
- [https://book.cairo-lang.org/ch99-02-02-contract-dispatcher-library-dispatcher-and-system-calls.html](https://book.cairo-lang.org/ch99-02-02-contract-dispatcher-library-dispatcher-and-system-calls.html)

### Deploy on testnet

- process is the same as above, however, make sure you change your account, keystore and rpc node.

|          | local   | testnet |
| -------- | ------- | ------- |
| rpc      | katana  | alchemy |
| account  | starkli | starkli |
| keystore | starkli | starkli |

account: [https://book.starkli.rs/accounts](https://book.starkli.rs/accounts)
keystore: [https://book.starkli.rs/signers](https://book.starkli.rs/signers)

# Cairo Basecamp 4: Testing

Testing matters in web3

![Screenshot 2023-10-18 at 17.02.28.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-18_at_17.02.28.png)

various amount of tests that differ in complexity and time requirements

![Untitled](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Untitled.png)

the difference between unit and integration tests

![Screenshot 2023-10-18 at 17.07.42.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-18_at_17.07.42.png)

structure of local devnets to quickly write and deploy contracts

![Screenshot 2023-10-18 at 17.08.25.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-18_at_17.08.25.png)

different options of local devnets, last session we used katana.

![Screenshot 2023-10-18 at 17.19.34.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-18_at_17.19.34.png)

- starknet foundry is helpful to test!
  - forge - test
  - cast - starknet cli

### How to unit test (old way)?

1. install starknet_foundry: https://github.com/foundry-rs/starknet-foundry
2. within your contract create a `mod tests` taht does the following:

   ![Screenshot 2023-10-19 at 16.39.50.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-19_at_16.39.50.png)

   - `deploy_syscall` ([https://github.com/starkware-libs/cairo/blob/cca08c898f0eb3e58797674f20994df0ba641983/corelib/src/starknet/syscalls.cairo#L10](https://github.com/starkware-libs/cairo/blob/cca08c898f0eb3e58797674f20994df0ba641983/corelib/src/starknet/syscalls.cairo#L10)) to deploy an instance of the contract class to start testing
     - input parameters: `Conracts_Class_Hash`, `contract_address_salt` (think of it like a seed to generate a random contract address), `calldata` (an array of felts that is the constructor data), `boolean` (deploy_from_zero set to false).
     - return parameters: deployed contract instance address, constructor return data (we leave it empty for now)

3. import dispatchers & create contract object by storing the contract instance address.

   1. assert if the `get_owner` function correctly provides the owner of the contract.

   ![Screenshot 2023-10-19 at 19.08.22.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-19_at_19.08.22.png)

### How to unit test (using foundry)?

1. adjust dependencies

   ![Screenshot 2023-10-19 at 19.24.29.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-19_at_19.24.29.png)

2. use foundry functions

   1. `declare`
   2. `deploy` (instead of `deploy_syscall`)

   ![Screenshot 2023-10-19 at 20.00.11.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-19_at_20.00.11.png)

### How to do integration test (using foundry using **cheatcodes**)?

1. create **tests** folder (this is only needed for integration tests as unit tests can be executed inside the contract file).

   1. Integration Test

      ![Screenshot 2023-10-22 at 18.43.22.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_18.43.22.png)

   **FileTrait Cheatcode**

   Integration test reading from txt file

   1. use snforge_std::io::{FileTrait, read_txt}

   ![Screenshot 2023-10-22 at 18.44.04.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_18.44.04.png)

**StartPrank Cheatcode**

1. allow us to change owner
2. cheat code: use snforge_std::{start_prank, stop_prank};

![Screenshot 2023-10-22 at 19.43.20.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_19.43.20.png)

**ShouldPanic Cheatcode**

if we expect test to fail: should_panic

![Screenshot 2023-10-22 at 19.13.42.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_19.13.42.png)

**MockData Cheatcode**

If we would like our contract to return mock data

![Screenshot 2023-10-22 at 19.42.56.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_19.42.56.png)

### Forke Testing

allows testing in a forked environment to perform certain actions on top of it

url: [https://foundry-rs.github.io/starknet-foundry/testing/fork-testing.html](https://foundry-rs.github.io/starknet-foundry/testing/fork-testing.html)

### Fuzz Testing

In many cases, a test needs to verify function behavior for multiple possible values. While it is possible to come up with these cases on your own, it is often impractical, especially when you want to test against a large number of possible arguments.

![Screenshot 2023-10-22 at 20.05.10.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_20.05.10.png)

### Connect Katana to Foundry

1. `sncast` [https://foundry-rs.github.io/starknet-foundry/starknet/account.html](https://foundry-rs.github.io/starknet-foundry/starknet/account.html)

### Helpful Links

1. check out cheatcodes: [https://foundry-rs.github.io/starknet-foundry/appendix/cheatcodes.html](https://foundry-rs.github.io/starknet-foundry/appendix/cheatcodes.html)

(foundry expects you to have an assertion function).

1. Use mod error

   ![Screenshot 2023-10-22 at 18.45.39.png](Cairo%20Basecamp%204%20Testing%2052360d2bcafe432bb342429ec1430463/Screenshot_2023-10-22_at_18.45.39.png)

2. test a specific functions
   1. `snforge <function_name>`
