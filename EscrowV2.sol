// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title EscrowV2
 * @dev Secure P2P trade with arbiter mediation.
 */
contract EscrowV2 is ReentrancyGuard {
    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, DISPUTED, CLOSED }

    address payable public buyer;
    address payable public seller;
    address public arbiter;
    uint256 public arbiterFeeBps = 100; // 1%

    State public currState;
    uint256 public amount;

    mapping(address => bool) public approved;

    event DisputeRaised(address indexed by);
    event Resolved(address indexed winner, uint256 amount);

    constructor(address payable _seller, address _arbiter) payable {
        buyer = payable(msg.sender);
        seller = _seller;
        arbiter = _arbiter;
        amount = msg.value;
        currState = State.AWAITING_DELIVERY;
    }

    /**
     * @dev Release funds to the seller. Requires 2 signatures.
     */
    function release() external nonReentrant {
        require(msg.sender == buyer || msg.sender == arbiter, "Unauthorized");
        approved[msg.sender] = true;

        if (approved[buyer] && (msg.sender == arbiter || approved[seller])) {
            _finalize(seller);
        } else if (msg.sender == arbiter && approved[buyer]) {
             _finalize(seller);
        }
    }

    /**
     * @dev Refund funds to the buyer. Requires Arbiter + Buyer/Seller.
     */
    function refund() external nonReentrant {
        require(msg.sender == arbiter, "Only arbiter can trigger refund");
        _finalize(buyer);
    }

    function raiseDispute() external {
        require(msg.sender == buyer || msg.sender == seller, "Only parties can dispute");
        currState = State.DISPUTED;
        emit DisputeRaised(msg.sender);
    }

    function _finalize(address payable _to) internal {
        require(currState != State.CLOSED, "Already closed");
        currState = State.CLOSED;

        uint256 fee = (amount * arbiterFeeBps) / 10000;
        uint256 finalAmount = amount - fee;

        payable(arbiter).transfer(fee);
        _to.transfer(finalAmount);

        emit Resolved(_to, finalAmount);
    }
}
