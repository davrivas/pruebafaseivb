/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.acciones;

import edu.davrivas.prueba.modelo.dao.CuentaFacadeLocal;
import edu.davrivas.prueba.modelo.dao.ObservacionFacadeLocal;
import edu.davrivas.prueba.modelo.dao.UsuarioFacadeLocal;
import edu.davrivas.prueba.modelo.entidades.Cuenta;
import edu.davrivas.prueba.modelo.entidades.Observacion;
import edu.davrivas.prueba.modelo.entidades.Usuario;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import javax.inject.Named;
import javax.enterprise.context.SessionScoped;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.ejb.EJB;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

/**
 *
 * @author davrivas
 */
@Named(value = "administradorControlador")
@SessionScoped
public class AdministradorControlador implements Serializable {

    @EJB
    private UsuarioFacadeLocal ufl;
    private CuentaFacadeLocal cfl;
    private ObservacionFacadeLocal ofl;
    private Usuario clienteSeleccionado = new Usuario();
    private String formato;

    /**
     * Creates a new instance of AdministradorControlador
     */
    public AdministradorControlador() {
    }

    public Usuario getClienteSeleccionado() {
        return clienteSeleccionado;
    }

    public void setClienteSeleccionado(Usuario clienteSeleccionado) {
        this.clienteSeleccionado = clienteSeleccionado;
    }

    public void seleccionarCliente(Usuario cl) {
        clienteSeleccionado = cl;
    }

    public String getFormato() {
        return formato;
    }

    public void setFormato(String formato) {
        this.formato = formato;
    }

    public String bloquearCliente() {
        Short estado = 0;
        clienteSeleccionado.setEstado(estado);

        // Miro si el cliente tiene cuentas activas
        if (clienteSeleccionado.getCuentaList() != null || !clienteSeleccionado.getCuentaList().isEmpty()) {
            List<Observacion> observaciones;

            for (Cuenta c : clienteSeleccionado.getCuentaList()) {
                if (c.getEstado().equals("ABIERTA")) {
                    Observacion observacion = new Observacion();
                    c.setEstado("CERRADA");

                    observacion.setFecha(new Date().toString());
                    observacion.setObservacion("Se ha cerrado la cuenta");
                    observacion.setTblCuentasId(c);
                    observacion.setTipo(estado);

                    if (c.getObservacionList() == null || c.getObservacionList().isEmpty()) {
                        observaciones = new ArrayList<>();
                        observaciones.add(observacion);
                        c.setObservacionList(observaciones);
                    } else {
                        c.getObservacionList().add(observacion);
                    }

                    ofl.create(observacion);
                    cfl.edit(c);
                }
            }
        }

        ufl.edit(clienteSeleccionado);

        clienteSeleccionado = new Usuario();

        return "index.xhtml?faces-redirect=true";
    }

    public void generarReporte(String formato) {
        try {
            FacesContext fc = FacesContext.getCurrentInstance();
            ExternalContext ec = fc.getExternalContext();
            File jasper = new File(ec.getRealPath("/WEB-INF/classes/edu/davrivas/pruebas/reportes/reportecuentasclientes.jasper"));
            Map<String, Object> params = new HashMap<>();
            params.put("logo", ec.getRealPath("/resources/img/user-perfil.png"));
            JasperPrint jp = JasperFillManager.fillReport(jasper.getPath(), params, new JRBeanCollectionDataSource(clienteSeleccionado.getCuentaList(), false));
            HttpServletResponse hsr = (HttpServletResponse) ec.getResponse();
            hsr.addHeader("Content-disposition", "attachment; filename=reporte." + formato);
            OutputStream os = hsr.getOutputStream();
            JasperExportManager.exportReportToPdfStream(jp, os);
//            JasperExportManager.exportReport;
            os.flush();
            os.close();
            fc.responseComplete();
        } catch (JRException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}
