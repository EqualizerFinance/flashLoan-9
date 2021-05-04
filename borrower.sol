pragma solidity ^0.7.6;

import 'https://github.com/aave/protocol-v2/blob/master/contracts/protocol/configuration/LendingPoolAddressesProvider.sol'

import 'https://github.com/aave/protocol-v2/blob/master/contracts/interfaces/ILendingPool.sol'

import 'https://github.com/aave/protocol-v2/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol'

contract Borrower is FlashLoanReceiverBase {
    LendingPoolAddressesProvider provider;
    address dai;
    
    constructor(
        address _provider, 
        address _dai) 
        FlashLoanReceiverBase(_provider) public {
        provider = LendingPoolAddressesProvider(_provider);
        dai = _dai;
    }

    function startLoan(uint amount, bytes calldata _params) external {
        LendingPool lendingPool = ILendingPool(provider.getLendingPool());
        lendingPool.flashLoan(address(this), dai, amount, _params);
    }

    function executeOperation(
        address _reserve,
        uint _amount,
        uint _fee,
        bytes memory _params
    ) external {
        //arbitrage, refinance loan, change collateral, etc. 
        transferFundsBackToPoolInternal(_reserve, amount + fee);
    }
}