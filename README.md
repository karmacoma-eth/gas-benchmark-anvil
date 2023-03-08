# Running Gas Benchmarks with Anvil

Let's say we want to get an accurate estimate of how much it will cost end users to send `Counter.increment()` transactions.

## Solution

```
# in one terminal run:
anvil

# in another, run:
forge script script/Counter.s.sol --rpc-url anvil --broadcast
```

In the output, look for these lines:

```
# this is the deploy transaction
Paid: 0.00034828536331071 ETH (106719 gas * 3.26357409 gwei)

# this is the increment transaction
Paid: 0.000140232322572324 ETH (43404 gas * 3.230861731 gwei)
```

From that output we can see that it would cost an end-user exactly 43404 gas to send an increment transaction. This includes the intrinsic gas cost of sending a transaction, as well as calldata costs.


## Discussion

Tests don't measure this:

```
forge test --gas-report
...
[PASS] testIncrement() (gas: 28334)
...
| Function Name                    | min             | avg   | median | max   | # calls |
| increment                        | 22340           | 22340 | 22340  | 22340 | 1       |
...
```

The 28334 in `testIncrement()` measure how much it costs to run the test, which includes:

- loading the `counter` variable from storage
- invoking the contract
- dispatching to the expected function
- executing the function
- running `assertEq(counter.number(), 1)`, which involves doing the same work for another contract call

So for our purpose, the gas score of of `testIncrement()` includes things we don't want to measure, and does not include the costs associated with an actual transaction (intrinsic cost, calldata cost)

The gas report for `increment` _only_ includes the gas cost of running that function, which is useful to test optimizations but for our purposes it includes *too little*.
