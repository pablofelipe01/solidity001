// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract loteria {
    ERC20Basic private token;

    address public owner;
    address public contrato;

    uint256 tokens_creados = 10000;

    event ComprandoTokens(uint256, address);

    constructor() public {
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }

    // ----------------------------------------  TOKEN ----------------------------------------

    // Establecer el precio de lo tokens en ethers
    function PrecioTokens(uint256 _numTokens) internal pure returns (uint256) {
        return _numTokens * (1 ether);
    }

    // Generar mas Tokens por la Loteria
    function GenerarTokens(uint256 _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSuply(_numTokens);
    }

    // Modificador para hacer funciones solamente accesibles por el owner del contrato
    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tiene permiso para esto");
        _;
    }

    // Comprar Tokens para comprar boletos/tickets para la loteria
    function CompraTokens(uint256 _numTokens) public payable {
        // Calcular el coste de los tokens
        uint256 coste = PrecioTokens(_numTokens);
        // Se requiere que el valor de ethers pagados sea equivalente al coste
        require(
            msg.value >= coste,
            "Compra menos Tokens o paga con mas Ethers."
        );
        // Diferencia a pagar
        uint256 returnValue = msg.value - coste;
        // Tranferencia de la diferencia
        msg.sender.transfer(returnValue);
        // Obtener el balance de Tokens del contrato
        uint256 Balance = TokensDisponibles();
        // Filtro para evaluar los tokens a comprar con los tokens disponibles
        require(_numTokens <= Balance, "Compra un numero de Tokens adecuado.");
        // Tranferencia de Tokens al comprador
        token.transfer(msg.sender, _numTokens);
        // Emitir el evento de compra tokens
        emit ComprandoTokens(_numTokens, msg.sender);
    }

    // Balance de tokens en el contrato de loteria
    function TokensDisponibles() public view returns (uint256) {
        return token.balanceOf(contrato);
    }

    // Obtener el balance de tokens acumulados en el Bote
    function Bote() public view returns (uint256) {
        return token.balanceOf(owner);
    }

    // Balance de Tokens de una persona
    function MisTokens() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }

    // ----------------------------------------  LOTERIA ----------------------------------------
}
