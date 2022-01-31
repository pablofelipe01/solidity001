// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;

contract Comida {
    struct plato {
        string nombre;
        string ingredientes;
        uint256 tiempo;
    }

    plato[] platos;

    mapping(string => string) ingredientes;

    function NuevoPlato(
        string memory _nombre,
        string memory _ingredientes,
        uint256 _tiempo
    ) internal {
        platos.push(plato(_nombre, _ingredientes, _tiempo));
        ingredientes[_nombre] = _ingredientes;
    }

    function Ingredientes(string memory _nombre)
        internal
        view
        returns (string memory)
    {
        return ingredientes[_nombre];
    }
}

contract Sandwitch is Comida {
    function sandwitch(string memory _ingredientes, uint256 _tiempo) external {
        NuevoPlato("Sandwitch", _ingredientes, _tiempo);
    }

    function verIngredientes() external view returns (string memory) {
        return Ingredientes("Sandwitch");
    }
}
