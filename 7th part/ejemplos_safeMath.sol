// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
import "./SafeMath.sol";

contract calculosSeguros {
    using SafeMath for uint256;

    function suma(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.add(_b);
    }

    function resta(uint256 _a, uint256 _b) public pure returns (uint256) {
        return _a.sub(_b);
    }

    function multiplicacion(uint256 _a, uint256 _b)
        public
        pure
        returns (uint256)
    {
        return _a.mul(_b);
    }
}
