/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.modelo.dao;

import edu.davrivas.prueba.modelo.entidades.Cuenta;
import edu.davrivas.prueba.modelo.entidades.Usuario;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author davrivas
 */
@Local
public interface CuentaFacadeLocal {

    void create(Cuenta cuenta);

    void edit(Cuenta cuenta);

    void remove(Cuenta cuenta);

    Cuenta find(Object id);

    List<Cuenta> findAll();

    List<Cuenta> findRange(int[] range);

    int count();

    List<Cuenta> findAllNoCanceladas();

    List<Cuenta> findCuentasAhorrosAbiertas();

    List<Cuenta> findCuentasCDTMasUnYear();

    List<Cuenta> findCuentasCliente(Usuario cliente);
}
