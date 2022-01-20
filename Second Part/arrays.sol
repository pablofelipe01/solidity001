// SPDX-License-Identifier: MIT
//Indicamos la version
pragma solidity >=0.4.4 <0.7.0;

contract Arrays {
    uint256[5] public array_enteros = [1, 2, 3];

    uint32[7] public array_enteros_32_bits;

    string[15] public array_stringd;

    uint256[] public dinamico_enteros;

    struct Persona {
        string nombre;
        uint256 edad;
    }

    Persona[] public array_dinamico_persona;

    // function modificar_array(string memory _nombre, uint _edad) public {
    // dinamico_enteros.push(_numero);
    // array_enteros[3] = 56;
    // array_dinamico_persona.push(Persona(_nombre, _edad));
    // }

    function modificar_array() public {
        // dinamico_enteros.push(_numero);
        array_enteros[3] = 56;
        // array_dinamico_persona.push(Persona(_nombre, _edad));
    }

    uint256 public test = array_enteros[2];
}
