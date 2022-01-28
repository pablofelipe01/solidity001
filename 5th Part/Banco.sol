// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;

contract Banco {
    struct cliente {
        string _nombre;
        address dirccion;
        uint256 dinero;
    }

    mapping(string => cliente) clientes;

    function nuevoCliente(string memory _nombre) public {
        clientes[_nombre] = cliente(_nombre, msg.sender, 0);
    }
}

contract Banco2 {}
