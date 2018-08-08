/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.acciones;

import com.mysql.jdbc.Connection;
import edu.davrivas.prueba.controladores.mail.Mail;
import edu.davrivas.prueba.controladores.sesion.SesionControlador;
import edu.davrivas.prueba.modelo.dao.CiudadFacadeLocal;
import edu.davrivas.prueba.modelo.dao.CuentaFacadeLocal;
import edu.davrivas.prueba.modelo.dao.MovimientoCuentaFacadeLocal;
import edu.davrivas.prueba.modelo.dao.TipoCuentaFacadeLocal;
import edu.davrivas.prueba.modelo.dao.TipoDocumentoFacadeLocal;
import edu.davrivas.prueba.modelo.dao.TipoUsuarioFacadeLocal;
import edu.davrivas.prueba.modelo.dao.UsuarioFacadeLocal;
import edu.davrivas.prueba.modelo.entidades.Ciudad;
import edu.davrivas.prueba.modelo.entidades.Cuenta;
import edu.davrivas.prueba.modelo.entidades.MovimientoCuenta;
import edu.davrivas.prueba.modelo.entidades.TipoCuenta;
import edu.davrivas.prueba.modelo.entidades.TipoDocumento;
import edu.davrivas.prueba.modelo.entidades.Usuario;
import java.io.File;
import java.io.OutputStream;
import javax.inject.Named;
import javax.enterprise.context.SessionScoped;
import java.io.Serializable;
import java.sql.DriverManager;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

/**
 *
 * @author davrivasivas
 */
@Named(value = "empleadoControlador")
@SessionScoped
public class EmpleadoControlador implements Serializable {

    @Inject
    private SesionControlador sc;
    @EJB
    private UsuarioFacadeLocal ufl;
    private Usuario cliente = new Usuario();
    private Usuario clienteSeleccionado = new Usuario();
    @EJB
    private MovimientoCuentaFacadeLocal mcfl;
    private MovimientoCuenta movimientoCuenta = new MovimientoCuenta();
    @EJB
    private CuentaFacadeLocal cfl;
    private Cuenta cuentaSeleccionada;
    @EJB
    private TipoCuentaFacadeLocal tcfl;
    private List<TipoCuenta> tiposCuenta;
    @EJB
    private TipoUsuarioFacadeLocal tufl;
    @EJB
    private TipoDocumentoFacadeLocal tdfl;
    private List<TipoDocumento> tiposDocumento;
    @EJB
    private CiudadFacadeLocal cdfl;
    private List<Ciudad> ciudades;

    /**
     * Creates a new instance of EmpleadoControlador
     */
    public EmpleadoControlador() {
    }

    public Cuenta getCuentaSeleccionada() {
        return cuentaSeleccionada;
    }

    public void setCuentaSeleccionada(Cuenta cuentaSeleccionada) {
        this.cuentaSeleccionada = cuentaSeleccionada;
    }

    public List<TipoCuenta> getTiposCuenta() {
        return tcfl.findAll();
    }

    public MovimientoCuenta getMovimientoCuenta() {
        return movimientoCuenta;
    }

    public void setMovimientoCuenta(MovimientoCuenta movimientoCuenta) {
        this.movimientoCuenta = movimientoCuenta;
    }

    public Usuario getCliente() {
        return cliente;
    }

    public void setCliente(Usuario cliente) {
        this.cliente = cliente;
    }

    public Usuario getClienteSeleccionado() {
        return clienteSeleccionado;
    }

    public void setClienteSeleccionado(Usuario clienteSeleccionado) {
        this.clienteSeleccionado = clienteSeleccionado;
    }

    public List<TipoDocumento> getTiposDocumento() {
        return tdfl.findAll();
    }

    public List<Ciudad> getCiudades() {
        return cdfl.findAll();
    }

    public String registrarConsignacion() {
        movimientoCuenta.setFecha(new Date());
        movimientoCuenta.setTipoMovimiento("CONSIGNACION");
        mcfl.create(movimientoCuenta);

        // Actualiza el saldo
        Cuenta cuentaAEditar = cfl.find(movimientoCuenta.getTblCuentasId().getId());
        Double saldoAntiguo = cuentaAEditar.getSaldo();
        Double saldoNuevo = movimientoCuenta.getValor();
        Double saldo = saldoAntiguo + saldoNuevo;
        cuentaAEditar.setSaldo(saldo);
        cfl.edit(cuentaAEditar);

        Usuario cliente = cuentaAEditar.getTblUsuariosId();
        String correoCliente = cliente.getCorreo();
        DateFormat formatoFecha = new SimpleDateFormat("yyyy/MM/dd");

        String titulo = "Hola " + cliente.getNombres() + " " + cliente.getPrimerApellido() + " " + cliente.getSegundoApellido();
        String html = "<p>Se ha hecho una consignación a su cuenta "
                + cuentaAEditar.getTblTiposCuentasId().getNombre() + " #" + cuentaAEditar.getNumero()
                + " por valor de $" + movimientoCuenta.getValor() + " el dia "
                + formatoFecha.format(movimientoCuenta.getFecha()) + "</p>"
                + "<p>El saldo de su cuenta es ahora de $" + cuentaAEditar.getSaldo() + "</p>";
        String asunto = "Consignación a cuenta " + cuentaAEditar.getTblTiposCuentasId().getNombre() + " #" + cuentaAEditar.getNumero();
        Mail.sendMail(correoCliente, titulo, asunto, html);

        movimientoCuenta = new MovimientoCuenta();
        return "movimientos.xhtml?faces-redirect=true"; // CAMBIAR
    }

    public String registrarRetiro() {
        movimientoCuenta.setFecha(new Date());
        movimientoCuenta.setTipoMovimiento("RETIRO");
        mcfl.create(movimientoCuenta);

        Cuenta cuentaAEditar = cfl.find(movimientoCuenta.getTblCuentasId().getId());
        Double saldoAntiguo = cuentaAEditar.getSaldo();
        Double saldoNuevo = movimientoCuenta.getValor();
        Double saldo = saldoAntiguo - saldoNuevo;
        cuentaAEditar.setSaldo(saldo);
        cfl.edit(cuentaAEditar);

        Usuario empleado = sc.getUsuario();
        Usuario cliente = cuentaAEditar.getTblUsuariosId();
        String correoCliente = clienteSeleccionado.getCorreo();
        DateFormat formatoFecha = new SimpleDateFormat("yyyy/MM/dd");

        String titulo = "Hola " + cliente.getNombres() + " " + cliente.getPrimerApellido() + " " + cliente.getSegundoApellido();
        String html = "<p>Se ha hecho un retiro a su cuenta "
                + cuentaAEditar.getTblTiposCuentasId().getNombre() + " #"
                + cuentaAEditar.getNumero() + " por valor de $"
                + movimientoCuenta.getValor() + " el dia "
                + formatoFecha.format(movimientoCuenta.getFecha()) + "</p>"
                + "<p>El saldo de su cuenta es ahora de $" + cuentaAEditar.getSaldo() + "</p>";
        String asunto = "Retiro de cuenta " + cuentaAEditar.getTblTiposCuentasId().getNombre() + " #" + cuentaAEditar.getNumero();
        Mail.sendMail(correoCliente, titulo, asunto, html);

        movimientoCuenta = new MovimientoCuenta();
        return "movimientos.xhtml?faces-redirect=true"; // CAMBIAR
    }

    public String registrarCliente() {
        cliente.setTblTiposUsuariosId(tufl.find(3));
        ufl.create(cliente);

        cliente = new Usuario();
        return "index.xhtml?faces-redirect=true";
    }

    public void seleccionarCuenta(Cuenta c) {
        cuentaSeleccionada = c;
    }

    public String cancelarCuentaAC() {
        cuentaSeleccionada.setEstado("CANCELADA");
        cfl.edit(cuentaSeleccionada);
        cuentaSeleccionada = new Cuenta();
        return "cuentas.xhtml?faces-redirect=true";
    }

    public String cancelarCuentaCDT() {
        // Registro el movimiento
        MovimientoCuenta mv = new MovimientoCuenta();
        mv.setFecha(new Date());
        mv.setTipoMovimiento("RETIRO");
        mv.setTblCuentasId(cuentaSeleccionada);
        mv.setValor(cuentaSeleccionada.getSaldo());
        mcfl.create(mv);

        // Cancelo la cuenta
        cuentaSeleccionada.setEstado("CERRADA");
        cuentaSeleccionada.setSaldo(0);
        cfl.edit(cuentaSeleccionada);
        cuentaSeleccionada = new Cuenta();
        return "cuentas.xhtml?faces-redirect=true";
    }

    public void seleccionarCliente(Usuario cl) {
        clienteSeleccionado = cl;
    }

    public String bloquearCliente() {
        Short estado = 0;
        clienteSeleccionado.setEstado(estado);
        ufl.edit(clienteSeleccionado);
        clienteSeleccionado = new Usuario();

        return "clientes.xhtml?faces-redirect=true";
    }

    public String generarReporte() {
        try {
            FacesContext fc = FacesContext.getCurrentInstance();
            ExternalContext ec = fc.getExternalContext();
            Connection conexion;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            conexion = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/db_prueba", "root", "");

            try {
                Map<String, Object> params = new HashMap<>();
                params.put("cliente", cliente.getId());
                params.put("imagen", "/resources/img/logo.png");
                File jasper = new File(ec.getRealPath("/WEB-INF/classes/edu/davrivas/prueba/reportes/cuentas-cliente.jasper"));
                JasperPrint jp = JasperFillManager.fillReport(jasper.getPath(), params, conexion);
                HttpServletResponse hsr = (HttpServletResponse) ec.getResponse();
                hsr.addHeader("Content-disposition", "attachment; filename=Reporte de cuentas de un cliente.pdf");
                OutputStream os = hsr.getOutputStream();
                JasperExportManager.exportReportToPdfStream(jp, os);
                os.flush();
                os.close();
                fc.responseComplete();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        cliente = new Usuario();
        
        return "";
    }
}
