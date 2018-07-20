/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.sesion;

import java.io.IOException;
import javax.inject.Inject;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ismael
 */
@WebFilter(filterName = "FilterRecuperar", urlPatterns = {"/recuperar.xhtml"})
public class FilterRecuperar implements Filter {

    private static final boolean debug = true;

    @Inject
    private SesionControlador sc;

    // The filter configuration object we are associated with.  If
    // this value is null, this filter instance is not currently
    // configured.
    public FilterRecuperar() {
    }

    /**
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest hsrequest = (HttpServletRequest) request;
        HttpServletResponse hsresponse = (HttpServletResponse) response;
        if (sc != null && sc.getUsuario() != null) {
            switch (sc.getRol().getId()) {
                case 1:
                    hsresponse.sendRedirect(hsrequest.getContextPath() + "/administrador/");
                    break;
                case 2:
                    hsresponse.sendRedirect(hsrequest.getContextPath() + "/empleado/");
                    break;
                case 3:
                    hsresponse.sendRedirect(hsrequest.getContextPath() + "/cliente/");
                    break;
            }
        } else {
            chain.doFilter(request, response);
        }
    }

}
