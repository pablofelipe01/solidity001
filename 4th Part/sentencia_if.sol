// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

contract Centencia_if {
    function suerte(uint256 _numero) public pure returns (bool) {
        bool ganador;

        if (_numero == 100) {
            ganador = true;
        } else {
            ganador = false;
        }

        return ganador;
    }

    function valorAbsoluto(int256 _k) public pure returns (uint256) {
        uint256 valor_absoluto_numero;
        if (_k < 0) {
            valor_absoluto_numero = uint256(-_k);
        } else {
            valor_absoluto_numero = uint256(_k);
        }

        return valor_absoluto_numero;
    }

    function parTresCifras(uint256 _numero) public pure returns (bool) {
        bool flag;

        if ((_numero % 2 == 0) && (_numero >= 100) && (_numero < 999)) {
            flag = true;
        } else {
            flag = false;
        }
        return flag;
    }

    function votar(string memory _candidato)
        public
        pure
        returns (string memory)
    {
        string memory mensaje;

        if (
            keccak256(abi.encodePacked(_candidato)) ==
            keccak256(abi.encodePacked("Pablo"))
        ) {
            mensaje = "Has votado correctamente a Pablo";
        } else {
            if (
                keccak256(abi.encodePacked(_candidato)) ==
                keccak256(abi.encodePacked("David"))
            ) {
                mensaje = "Has votado correctamente a David";
            } else {
                if (
                    keccak256(abi.encodePacked(_candidato)) ==
                    keccak256(abi.encodePacked("Matias"))
                ) {
                    mensaje = "Has votado correctamente a Matias";
                } else {
                    mensaje = "no esta en la lista";
                }
            }
        }

        return mensaje;
    }
}
