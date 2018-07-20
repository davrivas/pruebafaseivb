/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.peticiones;

import edu.davrivas.prueba.modelo.dao.MovimientoCuentaFacadeLocal;
import edu.davrivas.prueba.modelo.entidades.MovimientoCuenta;
import java.util.List;
import javax.ejb.EJB;
import javax.inject.Named;
import javax.enterprise.context.RequestScoped;

/**
 *
 * @author davrivas
 */
@Named(value = "movimientosCuentaControlador")
@RequestScoped
public class MovimientosCuentaControlador {

    @EJB
    private MovimientoCuentaFacadeLocal mcfl;
    private List<MovimientoCuenta> movimientos;

    /**
     * Creates a new instance of MovimientosCuentaControlador
     */
    public MovimientosCuentaControlador() {
    }

    public List<MovimientoCuenta> getMovimientos() {
        return mcfl.findAll();
    }

}
