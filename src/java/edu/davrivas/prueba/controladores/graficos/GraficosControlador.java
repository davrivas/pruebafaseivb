/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.graficos;

import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import javax.annotation.PostConstruct;
import javax.inject.Named;
import javax.enterprise.context.RequestScoped;
import javax.faces.context.FacesContext;

/**
 *
 * @author davrivas
 */
@Named(value = "graphicController")
@RequestScoped
public class GraficosControlador {

    private List<DatoGrafico> datos;

    /**
     * Creates a new instance of GraphicController
     */
    public GraficosControlador() {
    }

    @PostConstruct
    public void init() {
    }

    public List<DatoGrafico> getDatos() {
        if (datos == null || datos.isEmpty()) {
            datos = new ArrayList<>();
//            datos.add(new DatoGrafico(1, new Random().nextDouble(), "Manzanas"));
            // Agregar de aquí en adelante info de base de datos
        }
        return datos;
    }

    public String getDatosJson() {
        Gson gson = new Gson();
        return gson.toJson(getDatos());
    }

    public void nuevosDatos() {
        FacesContext fc = FacesContext.getCurrentInstance();
        fc.getPartialViewContext().getEvalScripts().add("updateDatos(" + getDatosJson() + ")");
        datos = null;
    }

    public void actualizarDatos() {
        datos = null;
    }

}
