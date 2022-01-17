//SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.7.0;

contract tiempo {
    //Unidades de tiempo
    uint256 public tiempo_actual = now;
    uint256 public un_minuto = 1 minutes;
    uint256 public dos_horas = 2 hours;
    uint256 public cincuenta_dias = 50 days;
    uint256 public una_semana = 1 weeks;

    //Operamos con las unidades de tiempo

    function MasSegundos() public view returns (uint256) {
        return now + 50 seconds;
    }

    function MasHoras() public view returns (uint256) {
        return now + 1 hours;
    }

    function MasDias() public view returns (uint256) {
        return now + 3 days;
    }

    function MasSemanas() public view returns (uint256) {
        return now + 1 weeks;
    }
}
