#!/usr/bin/python3

import pytest

from testspolygon.conftest import initBalance, requireFork

testdata = [
    ('MATIC', 'iMATIC', 2)
]

INITIAL_LP_TOKEN_ACCOUNT_AMOUNT = 0.001 * 10 ** 18;
@pytest.mark.parametrize("tokenName, lpTokenName, pid", testdata)
def testFarming_deposit(requireFork, tokens, tokenName, lpTokenName, pid, accounts, masterChef, pgovToken):
    # Precondition
    lpToken = tokens[lpTokenName]
    token = tokens[tokenName]
    account1 = accounts[2]
    account2 = accounts[3]
    initBalance(account1, token, lpToken, INITIAL_LP_TOKEN_ACCOUNT_AMOUNT)
    initBalance(account2, token, lpToken, INITIAL_LP_TOKEN_ACCOUNT_AMOUNT)

    masterChefLPBalanceBefore = lpToken.balanceOf(masterChef);
    lpBalance1 = lpToken.balanceOf(account1)
    lpBalance2 = lpToken.balanceOf(account2)
    depositAmount1 = lpBalance1 - 10000
    depositAmount2 = lpBalance2 - 10000
    lpToken.approve(masterChef, 2**256-1, {'from': account1})
    lpToken.approve(masterChef, 2**256-1, {'from': account2})

    # Test procedure
    tx1 = masterChef.deposit(pid, depositAmount1, {'from': account1})
    assert tx1.status.name == 'Confirmed'

    # Once user deposit LP tokens, we expect that LP token balance is changed
    assert lpToken.balanceOf(account1) == lpBalance1 - depositAmount1
    # pendingGOVs will be 0 because we are the first who deposit LP tokens
    # and it will be changed after the second deposit/withdraw transaction (for any user)
    # pgovToken.balanceOf(account1) will be 0 and will be also changed if this user deposit again

    # The second deposit transaction for user2, this will trigger on calculation of pendingGOVs (pool.accBgovPerShare
    # will be > 0)
    tx2 = masterChef.deposit(pid, depositAmount2, {'from': account2})
    masterChef.updatePool(pid)  # trigger calculate pending tokens
    assert masterChef.pendingGOV(pid, account1) > 0
    assert tx2.status.name == 'Confirmed'
    assert lpToken.balanceOf(account2) == lpBalance2 - depositAmount2
    assert masterChef.pendingGOV(pid, account2) > 0
    assert masterChef.poolInfo(pid)[3] > 0  # accBgovPerShare > 0
    assert lpToken.balanceOf(masterChef) == masterChefLPBalanceBefore + depositAmount1 + depositAmount2

    # Second transaction for the same user
    bgovBefore = masterChef.pendingGOV(pid, account1)
    tx3 = masterChef.deposit(pid, 10000, {'from': account1})
    masterChef.updatePool(pid)

    assert lpToken.balanceOf(account1) == 0
    assert lpToken.balanceOf(masterChef) == masterChefLPBalanceBefore + depositAmount1 + depositAmount2 + 10000
    assert masterChef.pendingGOV(pid, account1) + pgovToken.balanceOf(account1) > bgovBefore

    # checking Deposit event
    depositEvent = tx3.events['Deposit'][0]
    assert (depositEvent['user'] == account1)
    assert (depositEvent['pid'] == pid)
    assert (depositEvent['amount'] == 10000)


@pytest.mark.parametrize("tokenName, lpTokenName, pid", testdata)
def testFarming_withdraw(requireFork, tokens, tokenName, lpTokenName, pid, accounts, masterChef, pgovToken):
    # Precondition
    lpToken = tokens[lpTokenName]
    token = tokens[tokenName]
    account1 = accounts[4]
    initBalance(account1, token, lpToken, INITIAL_LP_TOKEN_ACCOUNT_AMOUNT)
    bgovBalanceInitial = pgovToken.balanceOf(account1);
    lpBalance1 = lpToken.balanceOf(account1)
    depositAmount = lpBalance1 - 10000
    masterchefBalance = lpToken.balanceOf(masterChef);

    lpToken.approve(masterChef, 2**256-1, {'from': account1})
    tx1 = masterChef.deposit(pid, depositAmount, {'from': account1})
    assert tx1.status.name == 'Confirmed'
    masterChefLPBalanceBefore = lpToken.balanceOf(masterChef);
    lpBalanceBefore1 = lpToken.balanceOf(account1)
    masterChef.updatePool(pid)  # trigger calculate pending tokens
    assert masterChef.pendingGOV(pid, account1) > 0
    expectedBgovBalance = bgovBalanceInitial + masterChef.pendingGOV(pid, account1);

    # Test procedure
    # Withdraw 1th part
    tx2 = masterChef.withdraw(pid, depositAmount - 10000, {'from': account1})
    assert tx2.status.name == 'Confirmed'
    masterChef.updatePool(pid)
    assert pgovToken.balanceOf(account1) >= expectedBgovBalance
    assert lpToken.balanceOf(masterChef) < masterChefLPBalanceBefore
    assert masterChef.pendingGOV(pid, account1) > 0
    assert lpToken.balanceOf(account1) == lpBalanceBefore1 + depositAmount - 10000
    
    # Withdraw 2th part
    expectedBgovBalance = pgovToken.balanceOf(account1) + masterChef.pendingGOV(pid, account1);
    masterChef.updatePool(pid)
    tx3 = masterChef.withdraw(pid, 10000, {'from': account1})
    assert pgovToken.balanceOf(account1) >= expectedBgovBalance
    assert lpToken.balanceOf(masterChef) < masterChefLPBalanceBefore
    assert masterChef.pendingGOV(pid, account1) == 0
    assert lpToken.balanceOf(account1) == lpBalanceBefore1 + depositAmount
    assert lpToken.balanceOf(masterChef) == masterchefBalance

    # checking Withdraw event
    withdrawEvent = tx3.events['Withdraw'][0]
    assert (withdrawEvent['user'] == account1)
    assert (withdrawEvent['pid'] == pid)
    assert (withdrawEvent['amount'] == 10000)


@pytest.mark.parametrize("tokenName, lpTokenName, pid", testdata)
def testFarming_claim_reward(requireFork, tokens, tokenName, lpTokenName, pid, accounts, masterChef, pgovToken):
    # Precondition
    lpToken = tokens[lpTokenName]
    token = tokens[tokenName]
    account1 = accounts[5]
    initBalance(account1, token, lpToken, INITIAL_LP_TOKEN_ACCOUNT_AMOUNT)
    bgovBalanceInitial = pgovToken.balanceOf(account1);
    lpBalance1 = lpToken.balanceOf(account1)
    depositAmount = lpBalance1 - 10000
    masterChefLPBalanceBefore = lpToken.balanceOf(masterChef);
    lpToken.approve(masterChef, 2**256-1, {'from': account1})
    tx1 = masterChef.deposit(pid, depositAmount, {'from': account1})
    assert tx1.status.name == 'Confirmed'
    lpBalanceBefore1 = lpToken.balanceOf(account1)
    masterChef.updatePool(pid)  # trigger calculate pending tokens
    assert masterChef.pendingGOV(pid, account1) > 0
    expectedBgovBalance = bgovBalanceInitial + masterChef.pendingGOV(pid, account1);

    # Test procedure
    masterChef.claimReward(pid, {'from': account1})
    assert pgovToken.balanceOf(account1) >= expectedBgovBalance
    assert lpToken.balanceOf(masterChef) == masterChefLPBalanceBefore + depositAmount
    assert masterChef.pendingGOV(pid, account1) == 0
    assert lpToken.balanceOf(account1) == lpBalanceBefore1


# Withdraw without caring about rewards
@pytest.mark.parametrize("tokenName, lpTokenName, pid", testdata)
def testFarming_emergencyWithdraw(requireFork, tokens, tokenName, lpTokenName, pid, accounts, masterChef, pgovToken):
    # Precondition
    lpToken = tokens[lpTokenName]
    token = tokens[tokenName]
    account1 = accounts[6]
    initBalance(account1, token, lpToken, INITIAL_LP_TOKEN_ACCOUNT_AMOUNT)
    lpBalance1 = lpToken.balanceOf(account1)
    depositAmount = lpBalance1 - 10000
    masterchefBalance = lpToken.balanceOf(masterChef);
    lpToken.approve(masterChef, 2**256-1, {'from': account1})
    tx1 = masterChef.deposit(pid, depositAmount, {'from': account1})
    assert tx1.status.name == 'Confirmed'
    assert lpToken.balanceOf(account1) == lpBalance1 - depositAmount

    # Test procedure
    masterChef.emergencyWithdraw(pid, {'from': account1})
    lpBalanceBefore1 = lpToken.balanceOf(account1)
    assert lpToken.balanceOf(masterChef) == masterchefBalance
    assert lpToken.balanceOf(account1) == lpBalance1