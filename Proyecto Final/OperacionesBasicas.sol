// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";

contract OperacionesBasicas {
    using SafeMath for uint256;

    //Contrato abstracto
    constructor() internal {}

    function calcularPrecioTokens(uint256 _numTokens)
        internal
        pure
        returns (uint256)
    {
        return _numTokens.mul(1 ether);
    }

    function getBalance() public view returns (uint256 ethers) {
        return payable(address(this)).balance;
    }

    // Funcion para pasar de uint a string
    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }
}
