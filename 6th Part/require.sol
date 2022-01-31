// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

contract Require {
    function password(string memory _pas) public pure returns (string memory) {
        require(
            keccak256(abi.encodePacked(_pas)) ==
                keccak256(abi.encodePacked("12345")),
            "contrasena incorrecta"
        );
        return "contrasena correcta";
    }

    uint256 tiempo = 0;
    uint256 public cartera = 0;

    function pagar(uint256 _cantidad) public returns (uint256) {
        require(block.timestamp > tiempo + 5 seconds, "Aun no puedes pagar");
        tiempo = block.timestamp;
        cartera = cartera + _cantidad;
        return cartera;
    }

    string[] nombres;

    function nuevoNombre(string memory _nombre) public {
        for (uint256 i = 0; i < nombres.length; i++) {
            require(
                keccak256(abi.encodePacked(_nombre)) !=
                    keccak256(abi.encodePacked(nombres[i])),
                "ya esta en al lista"
            );
        }

        nombres.push(_nombre);
    }
}
