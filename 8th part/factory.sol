// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

contract SmartContract1 {
    mapping(address => address) public MiContratoPersonal;

    function Factory() public {
        address direccion_nuevo_contrato = address(
            new SmartContract2(msg.sender)
        );
        MiContratoPersonal[msg.sender] = direccion_nuevo_contrato;
    }
}

contract SmartContract2 {
    address public owner;

    constructor(address _direccion) public {
        owner = _direccion;
    }
}
