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

    // Precio del boleto en Tokens
    uint256 public PrecioBoleto = 5;
    // Relacion entre la persona que compra los boletos y los numeros de los boletos
    mapping(address => uint256[]) idPersona_boletos;
    // Relacion necesaria para identificar al ganador
    mapping(uint256 => address) ADN_boleto;
    // Numero aleatorio
    uint256 randNonce = 0;
    // Boletos generados
    uint256[] boletos_comprados;
    // Eventos
    event boleto_comprado(uint256, address); // Evento cuando se compra un boleto
    event boleto_ganador(uint256); // Evento del ganador
    event tokens_devueltos(uint256, address); // Evento para devolver tokens

    function CompraBoleto(uint256 _boletos) public {
        uint256 precio_total = _boletos * PrecioBoleto;
        require(precio_total >= MisTokens(), "Necesitas mas tokens");
        token.transferencia_loteria(msg.sender, owner, precio_total);
        for (uint256 i = 0; i < _boletos; i++) {
            uint256 random = uint256(
                keccak256(abi.encodePacked(now, msg.sender, randNonce))
            ) % 10000;
            randNonce++;
            idPersona_boletos[msg.sender].push(random);
            boletos_comprados.push(random);
            ADN_boleto[random] = msg.sender;
            emit boleto_comprado(random, msg.sender);
        }
    }

    function TusBoletos() public view returns (uint256[] memory) {
        return idPersona_boletos[msg.sender];
    }

    function GeneraGanador() public Unicamente(msg.sender) {
        require(boletos_comprados.length > 0, "No hay boletos comprados");
        uint256 longitud = boletos_comprados.length;
        uint256 posicion_array = uint256(
            uint256(keccak256(abi.encodePacked(now))) % longitud
        );
        uint256 eleccion = boletos_comprados[posicion_array];
        emit boleto_ganador(eleccion);
        address direcion_ganador = ADN_boleto[eleccion];
        token.transferencia_loteria(msg.sender, direcion_ganador, Bote());
    }

    function DevolverTokens(uint256 _numTokens) public payable {
        require(_numTokens > 0, "No tienes tokens con nosotros");
        require(
            _numTokens <= MisTokens(),
            "No tienes los tokens que desas devolver"
        );
        token.transferencia_loteria(msg.sender, address(this), _numTokens);
        msg.sender.transfer(PrecioTokens(_numTokens));
        emit tokens_devueltos(_numTokens, msg.sender);
    }
}
