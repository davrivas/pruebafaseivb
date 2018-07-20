/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.modelo.dao;

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
public class UsuarioFacade extends AbstractFacade<Usuario> implements UsuarioFacadeLocal {

    @PersistenceContext(unitName = "pruebaPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public UsuarioFacade() {
        super(Usuario.class);
    }
    
    @Override
    public Usuario findByCorreo(String correo) {
        try {
            TypedQuery<Usuario> tq = getEntityManager().createQuery("SELECT u FROM Usuario u WHERE u.correo = :correo", Usuario.class);
            tq.setParameter("correo", correo);
            return tq.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public Usuario findByCorreoClave(String correo, String clave) {
        try {
            TypedQuery<Usuario> tq = getEntityManager().createQuery("SELECT u FROM Usuario u WHERE u.correo = :correo AND u.clave = :clave", Usuario.class);
            tq.setParameter("correo", correo);
            tq.setParameter("clave", clave);
            return tq.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public List<Usuario> findClientesNoBloqueados() {
        try {
            TypedQuery<Usuario> tq = getEntityManager().createQuery("SELECT u FROM Usuario u INNER JOIN u.tblTiposUsuariosId r WHERE r.id = 3 AND u.estado = 1", Usuario.class);
            return tq.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public List<Usuario> findClientes() {
        try {
            TypedQuery<Usuario> tq = getEntityManager().createQuery("SELECT u FROM Usuario u INNER JOIN u.tblTiposUsuariosId r WHERE r.id = 3", Usuario.class);
            return tq.getResultList();
        } catch (NoResultException e) {
            return null;
        }
    }
    
}
