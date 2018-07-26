/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.sesion;

import edu.davrivas.prueba.controladores.mail.Mail;
import edu.davrivas.prueba.modelo.dao.UsuarioFacadeLocal;
import edu.davrivas.prueba.modelo.entidades.TipoUsuario;
import edu.davrivas.prueba.modelo.entidades.Usuario;
import edu.davrivas.prueba.util.CodigoAleatorio;
import java.io.IOException;
import javax.inject.Named;
import javax.enterprise.context.SessionScoped;
import java.io.Serializable;
import javax.ejb.EJB;
import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;

/**
 *
 * @author davrivas
 */
@Named(value = "sesionControlador")
@SessionScoped
public class SesionControlador implements Serializable {

    @EJB
    private UsuarioFacadeLocal ufl;
    private Usuario usuario;
    private TipoUsuario rol;
    private String correo;
    private String clave;
    private String correoRecuperar;
    private String claveActual;
    private String claveNueva;
    private String confirmacionClaveNueva;

    /**
     * Creates a new instance of SesionControlador
     */
    public SesionControlador() {
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public TipoUsuario getRol() {
        return rol;
    }

    public void setRol(TipoUsuario rol) {
        this.rol = rol;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getCorreoRecuperar() {
        return correoRecuperar;
    }

    public void setCorreoRecuperar(String correoRecuperar) {
        this.correoRecuperar = correoRecuperar;
    }

    public String getClaveActual() {
        return claveActual;
    }

    public void setClaveActual(String claveActual) {
        this.claveActual = claveActual;
    }

    public String getClaveNueva() {
        return claveNueva;
    }

    public void setClaveNueva(String claveNueva) {
        this.claveNueva = claveNueva;
    }

    public String getConfirmacionClaveNueva() {
        return confirmacionClaveNueva;
    }

    public void setConfirmacionClaveNueva(String confirmacionClaveNueva) {
        this.confirmacionClaveNueva = confirmacionClaveNueva;
    }

    public void iniciarSesion() throws IOException {
        FacesContext fc = FacesContext.getCurrentInstance();
        ExternalContext ec = fc.getExternalContext();

        try {
            String direccion = ec.getRequestContextPath();
            usuario = ufl.findByCorreoClave(correo, clave);
            rol = usuario.getTblTiposUsuariosId();

            // Reviso el estado del usuario
            if (usuario.getEstado() == 1) {
                // Reviso el tipo de usuario
                switch (rol.getId()) {
                    case 1:
                        direccion += "/administrador/index.xhtml";
                        break;
                    case 2:
                        direccion += "/empleado/index.xhtml";
                        break;
                    case 3:
                        direccion += "/cliente/index.xhtml";
                        break;
                }

                ec.redirect(direccion);
            } else {
                usuario = null;
                fc.addMessage("login", new FacesMessage(FacesMessage.SEVERITY_WARN, "Usuario bloqueado:", "contacta al administrador."));
            }
        } catch (NullPointerException e) {
            fc.addMessage("login", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Usuario no  encontrado:", "Revisa que hayas digitado bien los campos"));
        }
    }

    public void cerrarSesion() throws IOException {
        FacesContext fc = FacesContext.getCurrentInstance();
        ExternalContext ec = fc.getExternalContext();

        usuario = null;
        correo = "";
        clave = "";

        ec.invalidateSession(); // Cierra sesión
        ec.redirect(ec.getRequestContextPath()); // Redirige al index.xhtml
    }

    public void recuperarClave() {
        FacesContext fc = FacesContext.getCurrentInstance();
        ExternalContext ec = fc.getExternalContext();
        Usuario usuarioAMirar = new Usuario();

        try {
            usuarioAMirar = ufl.findByCorreo(correoRecuperar);

            if (usuarioAMirar.getEstado() == 1) {
                String claveGenerada = CodigoAleatorio.codigoAleatorio();
                usuarioAMirar.setClave(claveGenerada);
                ufl.edit(usuarioAMirar);
                
                String correoCliente = usuarioAMirar.getCorreo();
                String asunto = "Cambio de contraseña";
                String nombreCliente = usuarioAMirar.getNombres() + " " + usuarioAMirar.getPrimerApellido() + " " + usuarioAMirar.getSegundoApellido();
                String titulo = "Hola " + nombreCliente;
                String html = "<p>Te hemos asignado una nueva clave que es la siguiente: "
                        + "<strong>" + claveGenerada +"</strong></p>"
                        + "<p>Te recomendamos que la cambies tan pronto la recibas</p>";
                Mail.sendMail(correoCliente, asunto, titulo, html);
                
                fc.addMessage("recuperar", new FacesMessage(FacesMessage.SEVERITY_INFO, "Clave cambiada con éxito:", "revisa tu correo " + correoCliente));
            } else {
                fc.addMessage("recuperar", new FacesMessage(FacesMessage.SEVERITY_WARN, "Usuario bloqueado:", "contacta con el administrador"));
            }
        } catch (NullPointerException e) {
            fc.addMessage("recuperar", new FacesMessage(FacesMessage.SEVERITY_ERROR, "Usuario no  encontrado:", "Revise que haya digitado el correo electrónico correcto"));
        }
        
        correoRecuperar = "";
    }

    public void cambiarClave() {
        FacesContext fc = FacesContext.getCurrentInstance();
        ExternalContext ec = fc.getExternalContext();

        if (claveActual.equals(usuario.getClave())) {
            if (claveNueva.equals(confirmacionClaveNueva)) {
                usuario.setClave(claveNueva);
                ufl.edit(usuario);
                
                fc.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "¡Contraseña cambiada con éxito!", ""));
            } else {
                fc.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "Las contraseñas no coinciden:", "Revisa que hayas digitado bien la confirmación de nueva contraseña"));
            }
        } else {
            fc.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR, "La contraseña no coincide:", "Revisa que hayas digitado la contraseña correcta"));
        }
        
        claveActual = "";
        claveNueva = "";
        confirmacionClaveNueva = "";
    }

}
