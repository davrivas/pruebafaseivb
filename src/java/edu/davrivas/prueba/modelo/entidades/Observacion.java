/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.modelo.entidades;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author davrivas
 */
@Entity
@Table(name = "tbl_observaciones")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Observacion.findAll", query = "SELECT o FROM Observacion o")
    , @NamedQuery(name = "Observacion.findById", query = "SELECT o FROM Observacion o WHERE o.id = :id")
    , @NamedQuery(name = "Observacion.findByTipo", query = "SELECT o FROM Observacion o WHERE o.tipo = :tipo")
    , @NamedQuery(name = "Observacion.findByObservacion", query = "SELECT o FROM Observacion o WHERE o.observacion = :observacion")
    , @NamedQuery(name = "Observacion.findByFecha", query = "SELECT o FROM Observacion o WHERE o.fecha = :fecha")})
public class Observacion implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;
    @Column(name = "tipo")
    private Short tipo;
    @Column(name = "observacion")
    private String observacion;
    @Column(name = "fecha")
    private String fecha;
    @JoinColumn(name = "tbl_cuentas_id", referencedColumnName = "id")
    @ManyToOne(optional = false)
    private Cuenta tblCuentasId;

    public Observacion() {
    }

    public Observacion(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Short getTipo() {
        return tipo;
    }

    public void setTipo(Short tipo) {
        this.tipo = tipo;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public Cuenta getTblCuentasId() {
        return tblCuentasId;
    }

    public void setTblCuentasId(Cuenta tblCuentasId) {
        this.tblCuentasId = tblCuentasId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Observacion)) {
            return false;
        }
        Observacion other = (Observacion) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "edu.davrivas.modelo.entidades.Observacion[ id=" + id + " ]";
    }

}
