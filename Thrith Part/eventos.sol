// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

contract Eventos {
    event evento_1(string _nombrePersona);
    event evento_2(string _nombrePersona, uint256 _edad);
    event evento_3(string, uint256, address, bytes32);
    event abortar_mision();

    function EmitirEvento1(string memory _nombrePersona) public {
        emit evento_1(_nombrePersona);
    }

    function EmitirEvento2(string memory _nombrePersona, uint256 _edad) public {
        emit evento_2(_nombrePersona, _edad);
    }

    function EmitirEvento3(string memory _nombrePersona, uint256 _edad) public {
        bytes32 hash_id = keccak256(
            abi.encodePacked(_nombrePersona, _edad, msg.sender)
        );
        emit evento_3(_nombrePersona, _edad, msg.sender, hash_id);
    }

    function abortarMision() public {
        emit abortar_mision();
    }
}
