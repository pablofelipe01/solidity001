// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;

contract Banco {
    struct cliente {
        string _nombre;
        address direccion;
        uint256 dinero;
    }

    mapping(string => cliente) clientes;

    function nuevoCliente(string memory _nombre) public {
        clientes[_nombre] = cliente(_nombre, msg.sender, 0);
    }
}

contract Cliente is Banco {
    function altaCliente(string memory _nombre) public {
        nuevoCliente(_nombre);
    }

    function ingresarDinero(string memory _nombre, uint256 _cantidad) public {
        clientes[_nombre].dinero = clientes[_nombre].dinero + _cantidad;
    }

    function retirarDinero(string memory _nombre, uint256 _cantidad)
        public
        returns (bool)
    {
        bool flag = true;

        if (int256(clientes[_nombre].dinero) - int256(_cantidad) >= 0) {
            clientes[_nombre].dinero = clientes[_nombre].dinero - _cantidad;
        } else {
            flag = false;
        }

        return flag;
    }

    function consultarSaldo(string memory _nombre)
        public
        view
        returns (uint256)
    {
        return clientes[_nombre].dinero;
    }
}
