// SPDX-License-Identifier: MIT
//Indicamos la version
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract hash {
    //Computo del hash de un string
    function calcularHash(string memory _cadena) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_cadena));
    }

    //Computo del hash de un string, un entero y una direccion
    function calcularHash2(
        string memory _cadena,
        uint256 _k,
        address _address
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_cadena, _k, _address));
    }

    /*Computo del hash de un string, un entero y una direccion mas otro string y entero que no estan
    dentro de una variable*/
    function calcularHash3(
        string memory _cadena,
        uint256 _k,
        address _address
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(_cadena, _k, _address, "hola", uint256(2))
            );
    }
}
