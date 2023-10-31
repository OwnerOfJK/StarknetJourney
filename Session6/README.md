# Cairo Basecamp 6: Architecture

### Madara

![Screenshot 2023-10-31 at 12.32.15.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_12.32.15.png)

## Kakarot

![Screenshot 2023-10-31 at 12.32.43.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_12.32.43.png)

### L3

An L3 is generally used to run an L2 and proving that you are running it correctly.

### Architecture Overview

![Screenshot 2023-10-31 at 12.36.08.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_12.36.08.png)

## Transaction Types

![Screenshot 2023-10-31 at 12.38.34.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_12.38.34.png)

- **declare**: used to declare new contract classes on starknet
  - send sierra code to the network
    - cairo 0 prev compiled to cairo assembly
    - cairo 1 compiles to sierra which compiles to cairo assembly
      - executions in sierra **never fail and are always provable**.
  - cairo 1 transaction class hash always matches the sierra code that is being sent and includes the hash of the assembly code.
- **invoke**: used to trigger a declared smart contract function **AND** to deploy smart contracts.
  - **here starknet differs to ethereum.**
    - You can either deploy a new contract by sending a transaction or you call a function in a factory contract.
    - On Starknet only the second option exists because you declare a contract which is then used as a factory contract to deploy contract instances (using syscall) of it.
  - flow of invoke: for transactions a recipient has to be defined which is the account and then its being first validated then executed.
- **deploy_account**: chicken and egg problem, how to declare and invoke the smart contract wallet without an account.
  - different transaction flow to allow for the execution of code before charging fees.

## Transaction Lifecycle

![Screenshot 2023-10-31 at 12.59.37.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_12.59.37.png)

- currently sequencer is centralised (decentralisation in process)

**Sequencers (L2)**

- Received & Queued
  - when the sequencer receives the signed transaction it takes some time for it to be processed to impact the starknet state.
    - until its processed querying the transaction nonce will fail
  - while waiting to be processed its in a similar stasis like an Ethereum mempool:
    - difference is that the ethereum mempool can change until they entered a block (resultng in MEV etc.)
    - on starknet transactions are processed sequentially (first come first serve), higher fees do not impact speed.
- Accepted & Executed
  - Part 1
    - the sequencer sequentially executes all queued transactions
    - starknet state is changed
    - the transation has a status, events but doesnt have a block number
  - Part 2
    - Add executed transaction to a block, block number and timestamp added
    - no proof generated yet, but secured by an L2 consensus

**Provers (L2 → L1)**

- Prover picks up a bunch of sequenced blocks and generates a proof of validity
- sends proof to an ethereum smart contract (i.e. verifier contract) and gets validated
- all blocks are ow secured by ethereum consensus
  - L1 does not secure each individual transactions, but validates something that attests to the validility of the transaction.

### Rejected & Reverted Transactions

Rejected

![Screenshot 2023-10-31 at 13.21.30.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_13.21.30.png)

Reverted

- (passed the validate step but not the execute step)
- at this point, once the execute step fails the sequencer does not have to proof the failure and can therefore take the highest fee possible.
  - resulting issue: no way to distinguish between transactions that actually failed and those that the sequencer intentionally let fail
  - solution (on the roadmap): make everything provable (even failures).

![Screenshot 2023-10-31 at 13.22.24.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_13.22.24.png)

### Summary

![Screenshot 2023-10-31 at 13.28.51.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_13.28.51.png)

## Proving

- cairo devs need not to worry about proofs
- Cairo (=CPU Air) is a proofable circuit, of which the verifier is deployed and audited on ethereum.
- the cairo language compiles to be executable by the aforementioned CPU

Starknet

- Starknet OS is a Cairo Program
  - Sharp (proving back-end) → starknet → smart contract

SHARP (Shared Prover)

- its job is to aggregate cairo jobs and bundle them into a single proof (i.e. a starknet block is one job). this is happening off chain.
- **How does it do it?**
  - Creates a proof for each transaction tuple. Tuple format:
    - Input: State of previous block
    - Output: State after aggregating the block
    - Cairo Program Hash: Starknet OS

Stone Prover

- open source prover that allows to prove Cairo 0 programs (to verify that this program ran correctly)
- compatible with ethereum L1 verifier to proof transactions and allow others to verify

Ethereum Verifier

- receives a proof and the associated tuple
- if the proofs are valid the tuples are saved in a fact registry.

Fact Registry

- once saved in a fact registry, ethereum knows something happened.
- the fact registry can show what program had what input and created what output

Starknet OS

- starknet core contract queries the fact registry on ethereum and verifys that the proof was validated.
  - checks the state diff and make sure that they were published
  - then updates the starknet state

Summary

![Screenshot 2023-10-31 at 21.25.20.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_21.25.20.png)

## Data Availibilty

Problem

![Screenshot 2023-10-31 at 21.26.53.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_21.26.53.png)

- if we only store the hash, what happens if n+1 hash is lost?
  - starknet state is lost, n+2 cannot be processesed

solution 1: validity rollups (state publication verified on chain)

- in order to make sure that we always have access to the state we publish the state on ethereum as events.
- only publish the state diff each time (otherwise super costly)
- Starknet core contract verifies the state diff were published before moving on from n to n+1.
  - cheapest way, but still 98% of starknet transaction cost.

solution 2: validiums (state publication not verified on chain)

- why not publish state roots everywhere so its always available (i.e. celestia. its not about storage and who owns it. Its all about publication and proofing that it was available for anyone to download).

Solution 3: volition (in process)

- best of both worlds?
- publish two state roots
  - one verified on chain
  - one verified off chain
- devs can decide which state they store each variable in (i.e. wallet balance shoudl be onchain, unimportant mechanics off chain)

EIP 4844 (= Dank Sharding)

- the problem above is not unique to starknet
- EIP 4844: anyone can publish data on ethereym that is provably kept by nodes and accessible by anyone for a week, and then not mandatory to keep.
  - goal is publication not storage.
- another solution for starknet to potentially reduce its cost

Summary

![Screenshot 2023-10-31 at 21.41.14.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_21.41.14.png)

## L1 - L2 Messaging

bridging

- asset bridging
  - nfts, tokens
- data bridging

**Starknet → ETH**

1. syscall in your starknet contract `send_message_to_l1_syscall`

   ![Screenshot 2023-10-31 at 21.58.03.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_21.58.03.png)

2. waiting for the next proof to be registered in ethereum

   ![Screenshot 2023-10-31 at 21.59.28.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_21.59.28.png)

3. once a proof is generated, state diff with message is published, which triggers an event on starknet core contract

   ![Screenshot 2023-10-31 at 22.00.56.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_22.00.56.png)

4. message is stored and identified by its hash + associated counter (the message itself is not stored)

- in order to receive/consume message a contract function has to be triggered on L1
  ![Screenshot 2023-10-31 at 22.03.55.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_22.03.55.png)
- There are delays due to proof verification frequency (around 2h on testnet)
- keepers allow to automatically consume message

**ETH → Starknet**

1. ethereum contract function call to send message to L2

   1. function selector: when you send a message you need to specify exactly what function is supposed to receive a message to perform a certain action

   ![Screenshot 2023-10-31 at 22.06.58.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_22.06.58.png)

2. l1 handler on starknet to call the function

   ![Screenshot 2023-10-31 at 22.09.05.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_22.09.05.png)

3. message sent to recipient

   - Difference:
     - Starknet → ETH: need to wait for proof to pass to actually consume message
     - ETH → Starknet: only wait for transaction that sends the message to be finalised (wait for 10 block confirmation)
       - directly picked up by sequencer and optimistically executed
       - during execution a flag is activated that is verified once the next proof is sent back to L1

   ![Screenshot 2023-10-31 at 22.11.31.png](Cairo%20Basecamp%206%20Architecture%203f47657b914a46c4af3a222ea68f0c94/Screenshot_2023-10-31_at_22.11.31.png)
