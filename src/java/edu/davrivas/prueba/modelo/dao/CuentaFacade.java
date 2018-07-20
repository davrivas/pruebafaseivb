/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.modelo.dao;

import edu.davrivas.prueba.modelo.entidades.Cuenta;
import edu.davrivas.prueba.modelo.entidades.Usuario;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

/**
 *
 * @author davrivas
 */
@Stateless
public class CuentaFacade extends AbstractFacade<Cuenta> implements CuentaFacadeLocal {

    @PersistenceContext(unitName = "pruebaPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public CuentaFacade() {
        super(Cuenta.class);
    }

    @Override
    public List<Cuenta> findAllNoCanceladas() {
        try {
            TypedQuery tq = getEntityManager().createQuery("SELECT c FROM Cuenta c WHERE c.estado = 'ABIERTA'", Cuenta.class);
            return tq.getResultList();
        } catch (NoResultException nre) {
            return null;
        }
    }

    @Override
    public List<Cuenta> findCuentasAhorrosAbiertas() {
        try {
            TypedQuery tq = getEntityManager().createQuery("SELECT c FROM Cuenta c INNER JOIN c.tblTiposCuentasId t WHERE (t.id = 1 OR t.id = 2) AND c.estado = 'ABIERTA'", Cuenta.class);
            return tq.getResultList();
        } catch (NoResultException nre) {
            return null;
        }
    }

    @Override
    public List<Cuenta> findCuentasCDTMasUnYear() {
        try {
            TypedQuery tq = getEntityManager().createQuery("SELECT c FROM Cuenta c INNER JOIN c.tblTiposCuentasId t WHERE t.id = 3 AND c.estado = 'ABIERTA'", Cuenta.class);
            return tq.getResultList();
        } catch (NoResultException nre) {
            return null;
        }
    }

    @Override
    public List<Cuenta> findCuentasCliente(Usuario cliente) {
        try {
            TypedQuery tq = getEntityManager().createQuery("SELECT c FROM Cuenta c WHERE c.tblUsuariosId = :cliente", Cuenta.class);
            tq.setParameter("cliente", cliente);
            return tq.getResultList();
        } catch (NoResultException nre) {
            return null;
        }
    }

}
