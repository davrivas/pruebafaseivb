/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.peticiones;

import edu.davrivas.prueba.modelo.dao.UsuarioFacadeLocal;
import edu.davrivas.prueba.modelo.entidades.Cuenta;
import edu.davrivas.prueba.modelo.entidades.Usuario;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.EJB;
import javax.inject.Named;
import javax.enterprise.context.RequestScoped;

/**
 *
 * @author davrivas
 */
@Named(value = "clienteControlador")
@RequestScoped
public class ClienteControlador {

    @EJB
    private UsuarioFacadeLocal ufl;
//    private List<Usuario> clientes;
//    private List<Usuario> clientesNoBloqueados;
    private List<Usuario> clientesSinCuentas;

    /**
     * Creates a new instance of ClienteControlador
     */
    public ClienteControlador() {
    }

    public List<Usuario> getClientes() {
        return ufl.findClientes();
    }
    public List<Usuario> getClientesNoBloqueados() {
        return ufl.findClientesNoBloqueados();
    }

    public List<Usuario> getClientesSinCuentas() {
        clientesSinCuentas = new ArrayList<>();
        int conMovimientos;

        for (Usuario cl : ufl.findClientesNoBloqueados()) {
            conMovimientos = 0;

            for (Cuenta c : cl.getCuentaList()) {
                if (c.getEstado().equals("ABIERTA")) {
                    conMovimientos++;
                }
            }

            if (conMovimientos == 0) {
                clientesSinCuentas.add(cl);
            }
        }
        return clientesSinCuentas;
    }

}
