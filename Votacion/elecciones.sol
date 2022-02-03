// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  CANDIDATO   |   EDAD   |      ID
// -----------------------------------
//  Toni,20,12345X
//  Alberto,23,54321T
//  Joan,21,98765P
//  Javier,19,56789W
//  Pablo, 53,79454P

contract votaciones {
    address owner;
    uint256 empiezan_votaciones;

    constructor() public {
        owner = msg.sender;
    }

    mapping(string => bytes32) ID_Candidato;
    mapping(string => uint256) votos_candidato;

    string[] candidatos;

    bytes32[] votantes;

    function Representar(
        string memory _nombreCandidato,
        uint256 _edadCandidato,
        string memory _idCandidato
    ) public {
        bytes32 hash_Candidato = keccak256(
            abi.encodePacked(_nombreCandidato, _edadCandidato, _idCandidato)
        );

        ID_Candidato[_nombreCandidato] = hash_Candidato;

        candidatos.push(_nombreCandidato);
    }

    function VerCandidatos() public view returns (string[] memory) {
        return candidatos;
    }

    function Votar(string memory _candidato) public {
        bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));

        for (uint256 i = 0; i < votantes.length; i++) {
            require(votantes[i] != hash_Votante, "Ya has votado");
        }

        votantes.push(hash_Votante);
        votos_candidato[_candidato]++;
    }

    function VerVotos(string memory _candidato) public view returns (uint256) {
        return votos_candidato[_candidato];
    }

    function uint2str(uint256 _i)
        internal
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + (_i % 10)));
            _i /= 10;
        }
        return string(bstr);
    }

    function VerResultados() public view returns (string memory) {
        string memory resultados = "";

        for (uint256 i = 0; i < candidatos.length; i++) {
            resultados = string(
                abi.encodePacked(
                    resultados,
                    "(",
                    candidatos[i],
                    ",",
                    uint2str(VerVotos(candidatos[i])),
                    ") -----"
                )
            );
        }

        return resultados;
    }

    function Ganador() public view returns (string memory) {
        string memory ganador = candidatos[0];
        bool flag;

        for (uint256 i = 0; i < candidatos.length; i++) {
            if (votos_candidato[ganador] < votos_candidato[candidatos[i]]) {
                ganador = candidatos[i];
                flag = false;
            } else {
                if (
                    votos_candidato[ganador] == votos_candidato[candidatos[i]]
                ) {
                    flag = true;
                }
            }
        }

        if (flag = true) {
            ganador = "hay un empate";
        }
        return ganador;
    }
}
