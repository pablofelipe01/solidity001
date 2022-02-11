// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./OperacionesBasicas.sol";
import "./ERC20.sol";

contract InsuranceFactory is OperacionesBasicas {
    constructor() public {
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = msg.sender;
    }

    struct cliente {
        address DireccionCliente;
        bool AutorizacionCliente;
        address DireccionContrato;
    }

    struct servicio {
        string nombreServicio;
        uint256 precioTokensServicio;
        bool EstadoServicio;
    }

    struct lab {
        address direccionContratoLab;
        bool ValidacionLab;
    }

    ERC20Basic private token;

    address Insurance;
    address payable public Aseguradora;

    mapping(address => cliente) public MappingAsegurados;
    mapping(string => servicio) public MappingServicios;
    mapping(address => lab) public MappingLab;

    address[] DireccionesAsegurados;
    string[] private nombreServicios;
    address[] DireccionesLaboratorios;

    function FuncionUnicamenteAsegurados(address _direccionAsegurado)
        public
        view
    {
        require(
            MappingAsegurados[_direccionAsegurado].AutorizacionCliente == true,
            "No Autorizado."
        );
    }

    modifier UnicamenteAsegurados(address _direccionAsegurado) {
        FuncionUnicamenteAsegurados(_direccionAsegurado);
        _;
    }

    modifier UnicamenteAseguradora(address _direccionAseguradora) {
        require(Aseguradora == _direccionAseguradora, "No Autorizado.");
        _;
    }

    modifier Asegurado_o_Aseguradora(
        address _direccionAsegurado,
        address _direccionEntrante
    ) {
        require(
            (MappingAsegurados[_direccionEntrante].AutorizacionCliente ==
                true &&
                _direccionAsegurado == _direccionEntrante) ||
                Aseguradora == _direccionEntrante,
            "Solamente Aseguradoras y Asegurados"
        );
        _;
    }

    event EventoComprado(uint256);
    event EventoServicioProporcionado(address, string, uint256);
    event LaboratorioCreado(address, address);
    event AseguradoCreado(address, address);
    event EventoBajaAsegurado(address);
    event EventoNuevoServicio(string, uint256);
    event EventoBajaServicio(string);

    function creacionLab() public {
        DireccionesLaboratorios.push(msg.sender);
        address direccionLab = address(new Laboratorio(msg.sender, Insurance));
        MappingLab[msg.sender] = lab(direccionLab, true);
        emit LaboratorioCreado(msg.sender, direccionLab);
    }

    function crecionContratoAsegurado() public {
        DireccionesAsegurados.push(msg.sender);
        address direccionAsegurado = address(
            new InsuranceHealthRecord(msg.sender, token, Insurance, Aseguradora)
        );
        MappingAsegurados[msg.sender] = cliente(
            msg.sender,
            true,
            direccionAsegurado
        );
        emit AseguradoCreado(msg.sender, direccionAsegurado);
    }

    function Laboratorios()
        public
        view
        UnicamenteAseguradora(msg.sender)
        returns (address[] memory)
    {
        return DireccionesLaboratorios;
    }

    function Asegurados()
        public
        view
        UnicamenteAseguradora(msg.sender)
        returns (address[] memory)
    {
        return DireccionesAsegurados;
    }

    function consultaHistorialAsegurado(
        address _direccionAsegurado,
        address _direccionConsultor
    )
        public
        view
        Asegurado_o_Aseguradora(_direccionAsegurado, _direccionConsultor)
        returns (string memory)
    {
        string memory historial = "";
        address _direccionContratoAsegurado = MappingAsegurados[
            _direccionAsegurado
        ].DireccionContrato;
        for (uint256 i = 0; i < nombreServicios.length; i++) {
            if (
                MappingServicios[nombreServicios[i]].EstadoServicio &&
                InsuranceHealthRecord(_direccionContratoAsegurado)
                    .ServicioEstadoAsegurado(nombreServicios[i]) ==
                true
            ) {
                (
                    string memory nombreServicio,
                    uint256 precioSevicio
                ) = InsuranceHealthRecord(_direccionContratoAsegurado)
                        .HistorialAsegurado(nombreServicios[i]);

                historial = string(
                    abi.encodePacked(
                        historial,
                        "(",
                        nombreServicio,
                        ", ",
                        uint2str(precioSevicio),
                        ") ____"
                    )
                );
            }
        }
        return historial;
    }

    function darBajaCliente(address _direccionAsegurado)
        public
        UnicamenteAseguradora(msg.sender)
    {
        MappingAsegurados[_direccionAsegurado].AutorizacionCliente = false;
        InsuranceHealthRecord(
            MappingAsegurados[_direccionAsegurado].DireccionContrato
        ).darBaja;
        emit EventoBajaAsegurado(_direccionAsegurado);
    }

    function nuevoServicio(
        string memory _nombreServicio,
        uint256 _precioServicio
    ) public UnicamenteAseguradora(msg.sender) {
        MappingServicios[_nombreServicio] = servicio(
            _nombreServicio,
            _precioServicio,
            true
        );
        nombreServicios.push(_nombreServicio);
        emit EventoNuevoServicio(_nombreServicio, _precioServicio);
    }

    function darBajaServicio(string memory _nombreServicio)
        public
        UnicamenteAseguradora(msg.sender)
    {
        require(ServicioEstado(_nombreServicio) == true, "Servicio no existe");
        MappingServicios[_nombreServicio].EstadoServicio = false;
        emit EventoBajaServicio(_nombreServicio);
    }

    function ServicioEstado(string memory _nombreServicio)
        public
        view
        returns (bool)
    {
        return MappingServicios[_nombreServicio].EstadoServicio;
    }

    function getPrecioServicio(string memory _nombreServicio)
        public
        view
        returns (uint256 tokens)
    {
        require(ServicioEstado(_nombreServicio) == true, "Servicio no existe");
        return MappingServicios[_nombreServicio].precioTokensServicio;
    }

    function ConsultarServiciosActivos() public view returns (string[] memory) {
        string[] memory ServiciosActivos = new string[](nombreServicios.length);
        uint256 contador = 0;
        for (uint256 i = 0; i < nombreServicios.length; i++) {
            if (ServicioEstado(nombreServicios[i]) == true) {
                ServiciosActivos[contador] = nombreServicios[i];
                contador++;
            }
        }
        return ServiciosActivos;
    }

    function compraTokens(address _asegurado, uint256 _numTokens)
        public
        payable
        UnicamenteAsegurados(_asegurado)
    {
        uint256 Balance = balanceOf();
        require(_numTokens <= Balance, "No hay suficientes tokens");
        require(_numTokens > 0, "el numero de tokens debe ser positivo");
        token.transfer(msg.sender, _numTokens);
        emit EventoComprado(_numTokens);
    }

    function balanceOf() public view returns (uint256 tokens) {
        return (token.balanceOf(Insurance));
    }

    function generarTokens(uint256 _numTokens)
        public
        UnicamenteAseguradora(msg.sender)
    {
        token.increaseTotalSuply(_numTokens);
    }
}

contract InsuranceHealthRecord is OperacionesBasicas {
    enum Estado {
        alta,
        baja
    }

    struct Owner {
        address direccionPropietario;
        uint256 saldoPropietario;
        Estado estado;
        IERC20 tokens;
        address insurance;
        address payable aseguradora;
    }

    Owner propietario;

    constructor(
        address _owner,
        IERC20 _token,
        address _insurance,
        address payable _aseguradora
    ) public {
        propietario.direccionPropietario = _owner;
        propietario.saldoPropietario = 0;
        propietario.estado = Estado.alta;
        propietario.tokens = _token;
        propietario.insurance = _insurance;
        propietario.aseguradora = _aseguradora;
    }

    struct ServiciosSolicitados {
        string nombreServicio;
        uint256 precioSevicio;
        bool estadoServicio;
    }

    struct ServiciosSolicitadosLab {
        string nombreServicio;
        uint256 precioSevicio;
        address direccionLab;
    }

    mapping(string => ServiciosSolicitados) historialAsegurado;
    ServiciosSolicitadosLab[] historialAseguradoLaboratorio;

    event EventoSelfDestruct(address);
    event EventoDevolverTokens(address, uint256);
    event EventoServicioPagado(address, string, uint256);
    event EventoPeticionServicioLab(address, address, string);

    modifier Unicamente(address _direccion) {
        require(
            _direccion == propietario.direccionPropietario,
            "No es el asegurado"
        );
        _;
    }

    function HistorialAseguradoLaboratorio()
        public
        view
        returns (ServiciosSolicitadosLab[] memory)
    {
        return historialAseguradoLaboratorio;
    }

    function HistorialAsegurado(string memory _servicio)
        public
        view
        returns (string memory nombreServicio, uint256 precioSevicio)
    {
        return (
            historialAsegurado[_servicio].nombreServicio,
            historialAsegurado[_servicio].precioSevicio
        );
    }

    function ServicioEstadoAsegurado(string memory _servicio)
        public
        view
        returns (bool)
    {
        return historialAsegurado[_servicio].estadoServicio;
    }

    function darBaja() public Unicamente(msg.sender) {
        emit EventoSelfDestruct(msg.sender);
        selfdestruct(msg.sender);
    }

    function CompraTokens(uint256 _numTokens)
        public
        payable
        Unicamente(msg.sender)
    {
        require(_numTokens > 0, "el numero de tokens debe ser positivo");
        uint256 coste = calcularPrecioTokens(_numTokens);
        require(msg.value >= coste, "No te alcanza");
        uint256 returnValue = msg.value - coste;
        msg.sender.transfer(returnValue);
        InsuranceFactory(propietario.insurance).compraTokens(
            msg.sender,
            _numTokens
        );
    }

    function balanceOf()
        public
        view
        Unicamente(msg.sender)
        returns (uint256 _balance)
    {
        return (propietario.tokens.balanceOf(address(this)));
    }

    function devolverTokens(uint256 _numTokens)
        public
        payable
        Unicamente(msg.sender)
    {
        require(_numTokens > 0, "el numero de tokens debe ser positivo");
        require(_numTokens <= balanceOf(), "No alcanza para devolver");
        propietario.tokens.transfer(propietario.aseguradora, _numTokens);
        msg.sender.transfer(calcularPrecioTokens(_numTokens));
        emit EventoDevolverTokens(msg.sender, _numTokens);
    }

    function peticionServicio(string memory _servicio)
        public
        Unicamente(msg.sender)
    {
        require(
            InsuranceFactory(propietario.insurance).ServicioEstado(_servicio) ==
                true,
            "No esta disponible este servicio"
        );
        uint256 pagoTokens = InsuranceFactory(propietario.insurance)
            .getPrecioServicio(_servicio);
        require(pagoTokens <= balanceOf(), "Saldo Insuficiente");
        propietario.tokens.transfer(propietario.aseguradora, pagoTokens);
        historialAsegurado[_servicio] = ServiciosSolicitados(
            _servicio,
            pagoTokens,
            true
        );
        emit EventoServicioPagado(msg.sender, _servicio, pagoTokens);
    }

    function peticionServicioLab(address _direccionLab, string memory _servicio)
        public
        payable
        Unicamente(msg.sender)
    {
        Laboratorio contratoLab = Laboratorio(_direccionLab);
        require(
            msg.value ==
                contratoLab.ConsultarPrecioServicios(_servicio) * 1 ether,
            "Operacion Invalida"
        );
        contratoLab.DarServicio(msg.sender, _servicio);
        payable(contratoLab.DireccionLab()).transfer(
            contratoLab.ConsultarPrecioServicios(_servicio) * 1 ether
        );
        historialAseguradoLaboratorio.push(
            ServiciosSolicitadosLab(
                _servicio,
                contratoLab.ConsultarPrecioServicios(_servicio),
                _direccionLab
            )
        );
        emit EventoPeticionServicioLab(_direccionLab, msg.sender, _servicio);
    }
}

contract Laboratorio is OperacionesBasicas {
    address public DireccionLab;
    address contratoAseguradora;

    constructor(address _account, address _direccionContratoAseguradora)
        public
    {
        DireccionLab = _account;
        contratoAseguradora = _direccionContratoAseguradora;
    }

    mapping(address => string) public ServicioSolicitado;

    address[] public PeticionesServicios;

    mapping(address => ResultadoServicio) ResultadosServicioLab;

    struct ResultadoServicio {
        string diagnostico_servicio;
        string codigo_IPFS;
    }

    string[] nombreServiciosLab;

    mapping(string => ServicioLab) public serviciosLab;

    struct ServicioLab {
        string nombreServicio;
        uint256 precio;
        bool enFuncionamiento;
    }

    event EventoServicioFuncionando(string, uint256);
    event EventoDarServicio(address, string);

    modifier UnicamenteLab(address _direccion) {
        require(_direccion == DireccionLab, "No tiene Autorizacion");
        _;
    }

    function NuevoServicioLab(string memory _servicio, uint256 _precio)
        public
        UnicamenteLab(msg.sender)
    {
        serviciosLab[_servicio] = ServicioLab(_servicio, _precio, true);
        nombreServiciosLab.push(_servicio);
        emit EventoServicioFuncionando(_servicio, _precio);
    }

    function ConsultarServicios() public view returns (string[] memory) {
        return nombreServiciosLab;
    }

    function ConsultarPrecioServicios(string memory _servicio)
        public
        view
        returns (uint256)
    {
        return serviciosLab[_servicio].precio;
    }

    function DarServicio(address _direccionAsegurado, string memory _servicio)
        public
    {
        InsuranceFactory IF = InsuranceFactory(contratoAseguradora);
        IF.FuncionUnicamenteAsegurados(_direccionAsegurado);
        require(
            serviciosLab[_servicio].enFuncionamiento == true,
            "Fuera de servicio"
        );
        ServicioSolicitado[_direccionAsegurado] = _servicio;
        PeticionesServicios.push(_direccionAsegurado);
        emit EventoDarServicio(_direccionAsegurado, _servicio);
    }

    function DarResultados(
        address _direccionAsegurado,
        string memory _diagnostico,
        string memory _codigoIPFS
    ) public UnicamenteLab(msg.sender) {
        ResultadosServicioLab[_direccionAsegurado] = ResultadoServicio(
            _diagnostico,
            _codigoIPFS
        );
    }

    function VisualizacionResultados(address _direccionAsegurado)
        public
        view
        returns (string memory _diagnostico, string memory _codigoIPFS)
    {
        _diagnostico = ResultadosServicioLab[_direccionAsegurado]
            .diagnostico_servicio;
        _codigoIPFS = ResultadosServicioLab[_direccionAsegurado].codigo_IPFS;
    }
}
