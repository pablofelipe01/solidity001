// SPDX-License-Identifier: MIT
//Indicamos la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

contract view_pure_payable {
    //Modificador de view
    string[] lista_alumnos;

    function nuevo_alumno(string memory _alumno) public {
        lista_alumnos.push(_alumno);
    }

    function ver_alumno(uint256 _posicion) public view returns (string memory) {
        return lista_alumnos[_posicion];
    }

    uint256 x = 10;

    function sumarAx(uint256 _a) public view returns (uint256) {
        return x + _a;
    }

    //Modificador de pure

    function exponenciacion(uint256 _a, uint256 _b)
        public
        pure
        returns (uint256)
    {
        return _a**_b;
    }

    //Modificador de payable

    mapping(address => cartera) DineroCartera;

    struct cartera {
        string nombre_persona;
        address direccion_persona;
        uint256 dinero_persona;
    }

    function Pagar(string memory _nombrePersona, uint256 _cantidad)
        public
        payable
    {
        cartera memory mi_cartera;
        mi_cartera = cartera(_nombrePersona, msg.sender, _cantidad);
        DineroCartera[msg.sender] = mi_cartera;
    }

    function verSaldo() public view returns (cartera) {
        return DineroCartera[msg.sender];
    }
}
