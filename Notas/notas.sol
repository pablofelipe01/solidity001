// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract notas {
    address public profesor;

    constructor() public {
        profesor = msg.sender;
    }

    mapping(bytes32 => uint256) Notas;

    string[] revisiones;

    event alumno_evaluado(bytes32);
    event evento_revision(string);

    function Evaluar(string memory _idAlumno, uint256 _nota)
        public
        UnicamenteProfesor(msg.sender)
    {
        bytes32 hash_idAlumno = keccak256(abi.encode(_idAlumno));
        Notas[hash_idAlumno] = _nota;
        emit alumno_evaluado(hash_idAlumno);
    }

    modifier UnicamenteProfesor(address _direccion) {
        require(
            _direccion == profesor,
            "No tiene permiso para ejecutar esta funcion"
        );
        _;
    }

    function VerNotas(string memory _idAlumno) public view returns (uint256) {
        bytes32 hash_idAlumno = keccak256(abi.encode(_idAlumno));
        uint256 nota_alumno = Notas[hash_idAlumno];
        return nota_alumno;
    }

    function Revision(string memory _idAlumno) public {
        revisiones.push(_idAlumno);
        emit evento_revision(_idAlumno);
    }

    function VerRevisiones()
        public
        view
        UnicamenteProfesor(msg.sender)
        returns (string[] memory)
    {
        return revisiones;
    }
}
