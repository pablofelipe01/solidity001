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

    function HistorialAseguradoLaboratorio()
        public
        view
        returns (ServiciosSolicitadosLab[] memory)
    {
        return historialAseguradoLaboratorio;
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
}
