// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZenQuestXP {
    // XP storage and roles
    mapping(address => uint256) private _xpBalances;
    mapping(bytes32 => mapping(address => bool)) private _roles;
    
    // Role constants
    bytes32 public constant XP_MINTER_ROLE = keccak256("XP_MINTER_ROLE");
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

    // Events
    event ExperienceEarned(address indexed user, uint256 amount);
    event RoleGranted(bytes32 indexed role, address indexed account);

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(XP_MINTER_ROLE, msg.sender);
    }

    // Main XP functions
    function earnXP(address user, uint256 amount) external {
        require(hasRole(XP_MINTER_ROLE, msg.sender), "Need minter role");
        _xpBalances[user] += amount;
        emit ExperienceEarned(user, amount);
    }

    function getXP(address user) external view returns (uint256) {
        return _xpBalances[user];
    }

    // Role management
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }

    function _setupRole(bytes32 role, address account) internal {
        _roles[role][account] = true;
        emit RoleGranted(role, account);
    }

    // Security functions
    modifier onlyRole(bytes32 role) {
        require(hasRole(role, msg.sender), "Unauthorized");
        _;
    }

    // Additional XP features
    function transferXP(address to, uint256 amount) external {
        require(_xpBalances[msg.sender] >= amount, "Insufficient XP");
        _xpBalances[msg.sender] -= amount;
        _xpBalances[to] += amount;
    }

    function burnXP(uint256 amount) external {
        require(_xpBalances[msg.sender] >= amount, "Insufficient XP");
        _xpBalances[msg.sender] -= amount;
    }
}
