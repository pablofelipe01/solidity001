// SPDX-License-Identifier: MIT
//Indicando la version
pragma solidity >=0.4.4 <0.7.0;

contract Operadores {
    // Operadores matematicos
    uint256 a = 32;
    uint256 b = 4;

    uint256 public suma = a + b;
    uint256 public resta = a - b;
    uint256 public division = a / b;
    uint256 public multiplicacion = a * b;
    uint256 public residuo = a % b;
    uint256 public exponenciacion = a**b;

    //Comparar enteros
    uint256 c = 3;
    uint256 d = 3;

    bool public test_1 = a > b;
    bool public test_2 = a < b;
    bool public test_3 = c == d;
    bool public test_4 = a == d;
    bool public test_5 = a != b;
    bool public test_6 = a >= b;

    //Operadores booleanos

    //Criterio de divisibilidad entre 5: si el numero termina en 0 o en 5

    function divisibilidad(uint256 _k) public pure returns (bool) {
        uint256 ultima_cifra = _k % 10;

        if ((ultima_cifra == 0) || (ultima_cifra == 5)) {
            return true;
        } else {
            return false;
        }
    }

    function divisibilidadV2(uint256 _k) public pure returns (bool) {
        uint256 ultima_cifra = _k % 10;

        if ((ultima_cifra != 0) && (ultima_cifra != 5)) {
            return false;
        } else {
            return true;
        }
    }
}
