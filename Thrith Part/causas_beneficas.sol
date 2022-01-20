// SPDX-License-Identifier: MIT
//Especificamos la version
pragma solidity >=0.4.4 <0.8.12;

contract causasBeneficas {
    struct Causa {
        uint256 Id;
        string name;
        uint256 precio_objectivo;
        uint256 cantidad_recaudada;
    }

    uint256 contador_causas = 0;
    mapping(string => Causa) causas;

    function nuevaCausa(string memory _nombre, uint256 _precio_ojetivo)
        public
        payable
    {
        contador_causas = contador_causas++;
        // Causa memory causa = Causa(contador_causas, _nombre, _precio_ojetivo, 0);
        causas[_nombre] = Causa(contador_causas, _nombre, _precio_ojetivo, 0);
    }

    function objetivoCumplido(string memory _nombre, uint256 _donacion)
        private
        view
        returns (bool)
    {
        bool flag = false;
        Causa memory causa = causas[_nombre];
        if (causa.precio_objectivo >= (causa.cantidad_recaudada + _donacion)) {
            flag = true;
        }
        return flag;
    }

    function donar(string memory _nombre, uint256 _cantidad)
        public
        returns (bool)
    {
        bool aceptar_donacion = true;

        if (objetivoCumplido(_nombre, _cantidad)) {
            causas[_nombre].cantidad_recaudada =
                causas[_nombre].cantidad_recaudada +
                _cantidad;
        } else {
            aceptar_donacion = false;
        }
        return aceptar_donacion;
    }

    function comprobarCausa(string memory _nombre)
        public
        view
        returns (bool, uint256)
    {
        bool limite_alcanzado = false;
        Causa memory causa = causas[_nombre];

        if (causa.cantidad_recaudada >= causa.precio_objectivo) {
            limite_alcanzado = true;
        }

        return (limite_alcanzado, causa.cantidad_recaudada);
    }
}
