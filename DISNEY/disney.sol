// SPDX-License-Identifier: MIT
//Indicar la version
pragma solidity >=0.4.4 <0.8.12;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney {
    // --------------------------------- DECLARACIONES INICIALES ---------------------------------

    // Instancia del contato token
    ERC20Basic private token;

    // Direccion de (owner)
    address payable public owner;

    // Constructor
    constructor() public {
        token = new ERC20Basic(10000);
        owner = msg.sender;
    }

    // Estructura de datos para almacenar a los clientes de Disney
    struct cliente {
        uint256 tokens_comprados;
        string[] atracciones_disfrutadas;
    }

    // Mapping para el registro de clientes
    mapping(address => cliente) public Clientes;

    // --------------------------------- GESTION DE TOKENS ---------------------------------

    // Funcion para establecer el precio de un Token

    function PrecioTokens(uint256 _numTokens) internal pure returns (uint256) {
        // Conversion de Tokens a Ethers: 1 Token = 1 ether
        return _numTokens * (1 ether);
    }

    // Funcion para comprar Tokens:
    function CompraTokens(uint256 _numTokens) public payable {
        // Establecer el precio de los Tokens:
        uint256 coste = PrecioTokens(_numTokens);
        // Se evalua el dinero que el cliente paga por los Tokens:
        require(
            msg.value >= coste,
            "Compra menos Tokens o paga con mas ethers."
        );
        // Diferencia de lo que el cliente paga:
        uint256 returnValue = msg.value - coste;
        // Retorna la cantidad de ethers al cliente:
        msg.sender.transfer(returnValue);
        // Obtencion del numero de tokens disponibles:
        uint256 Balance = balanceOf();
        require(_numTokens <= Balance, "Compra un numero menor de Tokens");
        // Se transfiere el numero de tokens al cliente:
        token.transfer(msg.sender, _numTokens);
        // Registro de tokens comprados
        Clientes[msg.sender].tokens_comprados += _numTokens;
    }

    // Balance de tokens del contrato:
    function balanceOf() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Visualizar el numero de tokens restantes de un Cliente
    function MisTokens() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }

    // Funcion para generar mas tokens
    function GeneraTokens(uint256 _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSuply(_numTokens);
    }

    // Modificador para controlar las funciones ejecutables:
    modifier Unicamente(address _direccion) {
        require(
            _direccion == owner,
            "No tiene autorizacion para ejecutar esta funcion"
        );
        _;
    }

    // --------------------------------- GESTION DEL CONTRATO ---------------------------------
    //EVENTOS
    event disfruta_atraccion(string, uint256, address);
    event nueva_atraccion(string, uint256);
    event baja_atraccion(string);
    event nueva_comida(string, uint256, bool);
    event baja_comida(string);
    event disfruta_comida(string, uint256, address);

    //Struct atraccion

    struct atraccion {
        string nombre_atraccion;
        uint256 precio_atraccion;
        bool estado_atraccion;
    }

    //Struct comida
    struct comida {
        string nombre_comida;
        uint256 precio_comida;
        bool estado_comida;
    }

    // Mapping para relacion un nombre de una atraccion con una estructura de datos de la atraccion
    mapping(string => atraccion) public MappingAtracciones;

    // Mapping para relacion un nombre de una comida con una estructura de datos de la comida
    mapping(string => comida) public MappingComida;

    // Array para almacenar el nombre de las atracciones
    string[] Atracciones;

    // Array para almacenar el nombre de las comidas
    string[] Comidas;

    // Mapping para relacionar una identidad (cliente) con su historial de atracciones en DISNEY
    mapping(address => string[]) HistorialAtracciones;

    // Mapping para relacionar una identidad (cliente) con su historial de comidas en DISNEY
    mapping(address => string[]) HistorialComidas;

    // Star Wars -> 2 Tokens
    // Toy Story -> 5 Tokens
    // Piratas del Caribe -> 8 Tokens

    // Crear nuevas atracciones para DISNEY (SOLO es ejecutable por Disney)

    function NuevaAtraccion(string memory _nombreAtraccion, uint256 _precio)
        public
        Unicamente(msg.sender)
    {
        // Creacion de una atraccion en Disney
        MappingAtracciones[_nombreAtraccion] = atraccion(
            _nombreAtraccion,
            _precio,
            true
        );
        // Almacenamiento en un array el nombre de la atraccion
        Atracciones.push(_nombreAtraccion);
        // Emision del evento para la nueva atraccion
        emit nueva_atraccion(_nombreAtraccion, _precio);
    }

    // Crear nuevos menus para la comida en DISNEY (SOLO es ejecutable por Disney)
    function NuevaComida(string memory _nombreComida, uint256 _precio)
        public
        Unicamente(msg.sender)
    {
        // Creacion de una comida en Disney
        MappingComida[_nombreComida] = comida(_nombreComida, _precio, true);
        // Almacenar en un array las comidas que puede realizar una persona
        Comidas.push(_nombreComida);
        // Emision del evento para la nueva comida en Disney
        emit nueva_comida(_nombreComida, _precio, true);
    }

    // Dar de baja a las atracciones en Disney
    function BajaAtraccion(string memory _nombreAtraccion)
        public
        Unicamente(msg.sender)
    {
        // El estado de la atraccion pasa a FALSE => No esta en uso
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;
        // Emision del evento para la baja de la atraccion
        emit baja_atraccion(_nombreAtraccion);
    }

    // Dar de baja a las comida en Disney
    function BajaComida(string memory _nombreComida)
        public
        Unicamente(msg.sender)
    {
        // El estado de la comida pasa a FALSE => No esta en uso
        MappingComida[_nombreComida].estado_comida = false;
        // Emision del evento para la baja de la comida
        emit baja_comida(_nombreComida);
    }

    // Visualizar las atracciones de Disney
    function AtraccionesDisponibles() public view returns (string[] memory) {
        return Atracciones;
    }

    // Visualizar las comidas de Disney
    function ComidasDisponibles() public view returns (string[] memory) {
        return Comidas;
    }

    // Funcion para subirse a una atraccion de disney y pagar en tokens
    function subirseAtraccion(string memory _nombreAtraccion) public {
        // Precio de la atraccion (en tokens)
        uint256 tokens_atraccion = MappingAtracciones[_nombreAtraccion]
            .precio_atraccion;

        // Verifica el estado de la atraccion (si esta disponible para su uso)
        require(
            MappingAtracciones[_nombreAtraccion].estado_atraccion == true,
            "La atraccion no esta disponible en estos momentos."
        );
        // Verifica el numero de tokens que tiene el cliente para subirse a la atraccion
        require(
            tokens_atraccion <= MisTokens(),
            "Necesitas mas Tokens para subirte a esta atraccion."
        );

        /* El cliente paga la atraccion en Tokens:
        - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_disney'
        debido a que en caso de usar el Transfer o TransferFrom las direcciones que se escogian 
        para realizar la transccion eran equivocadas. Ya que el msg.sender que recibia el metodo Transfer o
        TransferFrom era la direccion del contrato.
        */
        token.transferencia_disney(msg.sender, address(this), tokens_atraccion);
        // Almacenamiento en el historial de atracciones del cliente
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);
        // Emision del evento para disfrutar de la atraccion
        emit disfruta_atraccion(_nombreAtraccion, tokens_atraccion, msg.sender);
    }

    // Funcion para comprar comida con tokens
    function ComprarComida(string memory _nombreComida) public {
        // Precio de la comida (en tokens)
        uint256 tokens_comida = MappingComida[_nombreComida].precio_comida;
        // Verifica el estado de la comida (si esta disponible)
        require(
            MappingComida[_nombreComida].estado_comida == true,
            "La comida no esta disponible en estos momentos."
        );
        // Verifica el numero de tokens que tiene el cliente para comer esa comida
        require(
            tokens_comida <= MisTokens(),
            "Necesitas mas Tokens para comer esta comida."
        );

        /* El cliente paga la atraccion en Tokens:
        - Ha sido necesario crear una funcion en ERC20.sol con el nombre de: 'transferencia_disney'
        debido a que en caso de usar el Transfer o TransferFrom las direcciones que se escogian 
        para realizar la transccion eran equivocadas. Ya que el msg.sender que recibia el metodo Transfer o
        TransferFrom era la direccion del contrato.
        */
        token.transferencia_disney(msg.sender, address(this), tokens_comida);
        // Almacenamiento en el historial de comidas del cliente
        HistorialComidas[msg.sender].push(_nombreComida);
        // Emision del evento para disfrutar de la comida
        emit disfruta_comida(_nombreComida, tokens_comida, msg.sender);
    }

    // Visualiza el historial completo de atracciones disfrutadas por un cliente
    function Historial() public view returns (string[] memory) {
        return HistorialAtracciones[msg.sender];
    }

    // Visualiza el historial completo de comidas disfrutadas por un cliente
    function HistorialComida() public view returns (string[] memory) {
        return HistorialComidas[msg.sender];
    }

    // Funcion para que un cliente de Disney pueda devolver Tokens
    function DevolverTokens(uint256 _numTokens) public payable {
        // El numero de tokens a devolver es positivo
        require(
            _numTokens > 0,
            "Necesitas devolver una cantidad positiva de tokens."
        );
        // El usuario debe tener el numero de tokens que desea devolver
        require(
            _numTokens <= MisTokens(),
            "No tienes los tokens que deseas devolver."
        );
        // El cliente devuelve los tokens
        token.transferencia_disney(msg.sender, address(this), _numTokens);
        // Devolucion de los ethers al cliente
        msg.sender.transfer(PrecioTokens(_numTokens));
    }
}
