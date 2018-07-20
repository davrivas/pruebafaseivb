/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.peticiones;

import edu.davrivas.prueba.modelo.dao.CuentaFacadeLocal;
import edu.davrivas.prueba.modelo.entidades.Cuenta;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import javax.ejb.EJB;
import javax.inject.Named;
import javax.enterprise.context.RequestScoped;

/**
 *
 * @author davrivas
 */
@Named(value = "cuentaControlador")
@RequestScoped
public class CuentaControlador {

    @EJB
    private CuentaFacadeLocal cfl;
    private List<Cuenta> cuentas;
    private List<Cuenta> cuentasAC;
    private List<Cuenta> cuentasCDTMasUnYear;

    /**
     * Creates a new instance of CuentaControlador
     */
    public CuentaControlador() {
    }

    public List<Cuenta> getCuentas() {
        return cfl.findAllNoCanceladas();
    }

    public List<Cuenta> getCuentasAC() {
        return cfl.findCuentasAhorrosAbiertas();
    }

    public List<Cuenta> getCuentasCDTMasUnYear() {
        cuentasCDTMasUnYear = new ArrayList<>();
        Calendar year = Calendar.getInstance();
        year.add(Calendar.YEAR, -1);

        for (Cuenta c : cfl.findCuentasCDTMasUnYear()) {
            if (c.getFechaApertura().before(year.getTime())) {
                cuentasCDTMasUnYear.add(c);
            }
        }

        return cuentasCDTMasUnYear;
    }

}
