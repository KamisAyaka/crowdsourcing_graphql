// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICrowdfunding {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event ProjectCreated(
        uint indexed id,
        address indexed creator,
        string name,
        string description,
        uint goal,
        uint deadline
    );

    event DonationMade(
        uint indexed id,
        address indexed donor,
        uint amount,
        uint currentAmount
    );

    event ProjectCompleted(uint indexed id, bool isSuccessful);
    event FundsWithdrawn(uint indexed id, address indexed account, uint amount);
    event NFTMinted(
        uint indexed id,
        address indexed recipient,
        uint indexed tokenId,
        uint rank,
        uint donationAmount
    );

    event AllowenceIncreased(uint indexed id, uint allowence);

    event ProjectFailed(uint indexed id);

    /*//////////////////////////////////////////////////////////////
                            CORE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function createProject(
        string memory _name,
        string memory _description,
        uint _goal,
        uint _deadline
    ) external;

    function donate(uint _projectId) external payable;

    function completeProject(
        uint _projectId,
        address[] memory _recipients,
        uint[] memory _amounts
    ) external;

    function withdrawFunds(uint _projectId, uint amount) external;

    function refund(uint _projectId) external;

    /*//////////////////////////////////////////////////////////////
                            STATE GETTERS
    //////////////////////////////////////////////////////////////*/
    function projects(
        uint
    )
        external
        view
        returns (
            uint id,
            address payable creator,
            string memory name,
            string memory description,
            uint goal,
            uint deadline,
            uint currentAmount,
            uint totalAmount,
            uint allowence,
            bool completed,
            bool isSuccessful
        );

    function donorAmounts(address, uint) external view returns (uint);

    function getProjectInfo(
        uint _projectId
    )
        external
        view
        returns (
            uint id,
            address payable creator,
            string memory name,
            string memory description,
            uint goal,
            uint deadline,
            uint currentAmount,
            uint totalAmount,
            uint allowence,
            bool completed,
            bool isSuccessful
        );

    function getProjectCount() external view returns (uint);

    function increaseAllowence(uint _projectId, uint _amount) external;

    function setProjectFailed(uint _projectId) external;
}
