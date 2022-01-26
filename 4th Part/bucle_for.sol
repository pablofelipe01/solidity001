// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;

//Suma de los 100 primeros numeros a partir del numero introducido

contract bucle_for {
    function suma(uint256 _numero) public pure returns (uint256) {
        uint256 Suma = 0;

        for (uint256 i = _numero; i < (100 + _numero); i++) {
            Suma = Suma + i;
        }
        return Suma;
    }

    address[] direcciones;

    function asociar() public {
        direcciones.push(msg.sender);
    }

    function comprobarAsociacion() public view returns (bool, address) {
        for (uint256 i = 0; i < direcciones.length; i++) {
            if (msg.sender == direcciones[i]) {
                return (true, direcciones[i]);
            }
        }
    }

    function sumaFactorial() public pure returns (uint256) {
        uint256 sumas = 0;

        for (uint256 i = 1; i <= 10; i++) {
            uint256 factorial = 1;

            for (uint256 j = 2; j <= i; j++) {
                factorial = factorial * j;
            }

            sumas = sumas + factorial;
        }

        return sumas;
    }
}
