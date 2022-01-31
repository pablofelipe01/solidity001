// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;

contract Modifier {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier soloPropietario() {
        require(
            msg.sender == owner,
            "no tiene permiso para ejecutar la funcion"
        );
        _;
    }

    function ejemplo1() public soloPropietario {}

    struct cliente {
        address direccion;
        string nombre;
    }

    mapping(string => address) clientes;

    function altaClientes(string memory _nombre) public {
        clientes[_nombre] = msg.sender;
    }

    modifier soloClientes(string memory _nombre) {
        require(clientes[_nombre] == msg.sender);
        _;
    }

    function ejemplo2(string memory _nombre) public soloClientes(_nombre) {}

    modifier MayorEdad(uint256 _edadMinima, uint256 _edadUsuario) {
        require(_edadUsuario > _edadMinima);
        _;
    }

    function conducir(uint256 _edad) public MayorEdad(18, _edad) {}
}
