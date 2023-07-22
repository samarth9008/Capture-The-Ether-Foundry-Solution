# Capture-The-Ether-Foundry-Solution

- **Guess the New Number**
  - `blockhash(block.number - 1), block.timestamp` - Never use this number for
    randomness in blockchain. Can be control by miners.
  - If we were to calculate this off-chain and submit the answer we would need
    our transaction to be mined immediately within the next block. As we don't
    have much control over when our transaction is mined and included in a
    block, doing the computation in a proxy smart contract is the better idea.
- **GuessRandomNumber**
  - Can be solved with previous method.
  - The answer is stored in the blockchain state (storage). Even though the
    storage variable is private, all data on the blockchain is public and can
    still be retrieved.
  - Another way to solve if the `answer` variable was public using foundry is
    provided here without using the exploit contract.
- **Guess the secret number**
  - Run the loop to find `i` which will match the given `answerHash` .
- **Predict the block hash**
  - The `blockhash` function only returns the actual block hash for the last 256
    blocks due to performance reasons. After 256 blocks, `blockhash` returns 32
    zeroes.
  - To solve this challenge, lock in
    `0x0000000000000000000000000000000000000000000000000000000000000000` and
    wait 257 blocks to call the `settle` action
- **Predict the future**
  - The answer will always be in the range of 0-9 because of `% 10`.
  - Submit the answer with a guess, keep increasing the block numbers with
    `vm.roll` until we get a block which matches our guess.
- **Retirement Fund**
  - Overflow will occur if the `startBalance` is less than the `currentBalance`
  - We can send ethers to the contract with `selfDestruct`.
  - Once the `collectPenalty` will be called, it will satisfy the `require`
    condition because of the overflow and transfer all the balance to our
    address
- **Token Sale**
  - We want to overflow `numTokens*PRICE_PER_TOKEN` in such a way that total
    equals to 0
  - If `total=0` we can buy tokens of `0 wei`.
  - In EVM whenever overflow occurs in multiplication, the last 256 bits are
    taken into account as a product
  - We want to find `numTokens*PRICE_PER_TOKEN` such that its product has a last
    256 bits equal to 0
  - `1 ether=1e18`. We already have 18 trailing zero because of it. We want to
    find a number such that the product has last 256 bits equal to zero. So
    `numTokens` can be, `256-18=238`, `2**238`
  - In this way we can buy `2**238` tokens with `0 wei` and sell it to capture
    our ether.
  - Better explanations at -
    [https://ethereum.stackexchange.com/questions/131516/integer-overflow-not-ocurring-as-expected-in-capture-the-ether-token-sale-challe/131705#131705](https://ethereum.stackexchange.com/questions/131516/integer-overflow-not-ocurring-as-expected-in-capture-the-ether-token-sale-challe/131705#131705)
- **Token Bank**
  - `withdraw` function has a reentrancy vulnerability, where it updates the
    balance after calling the `transfer` function
  - The `transfer` function calls the `tokenFallback` if its a contract to
    notify the recipient for the tokens recieved as this is the implementation
    of `ERC223 token standard`
  - We can create an exploit contract, increase its balance of token by calling
    `addContract` function
  - `withdraw` those tokens by calling the function. The `withdraw` function
    will call the `tokenFallback` function which we will implement on our attack
    contract.
  - The new `tokenFallback` function will again call a `withdraw` function to
    drain its balance
- **Token Whale**
  - The `transferFrom` is calling the `transfer` method.
  - The `transfer` method only checks the balance of `msg.sender` which is
    incorrect.
  - We approve an `address(Bob)` with 0 token balance to send tokens.
  - As the `transferFrom` function will call `transfer`, it will underflow the
    the Bob's balance to max
  - After that we can `transfer` as many tokens we want from `Bob` to the
    `player's` address
