// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

//Pablo Acebedo ---> 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//Olga Caro ---> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//Monica Chiffoleau ---> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract ERC20Basic is IERC20 {
    string public constant name = "ReefCoin";
    string public constant symblo = "REEF";
    uint8 public constant decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 tokens
    );

    using SafeMath for uint256;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 totalSupply_;

    constructor(uint256 initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function increaseTotalSuply(uint256 newTokensAmount) public {
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transfer(address recipient, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[recipient] = balances[recipient].add(numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
