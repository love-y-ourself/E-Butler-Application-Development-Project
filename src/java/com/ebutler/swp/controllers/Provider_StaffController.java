/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ebutler.swp.controllers;

import com.ebutler.swp.dao.ProviderDAO;
import com.ebutler.swp.dto.ProviderDTO;
import com.ebutler.swp.dto.ProviderServiceDTO1;
import com.ebutler.swp.dto.ProviderStaffDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author DELL
 */
public class Provider_StaffController extends HttpServlet {

     private static final String ERROR  = "index.jsp"; 
    private static final String SUCCESS  = "StaffProvider.jsp"; 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR ; 
        try {
            List<ProviderStaffDTO> listStaff = new ArrayList() ; 
            ProviderDAO dao = new ProviderDAO() ; 
            HttpSession session = request.getSession() ;  
            ProviderDTO provider = new ProviderDTO() ; 
            String chooseCategory = request.getParameter("serviceID_ADD"); 
            request.setAttribute("choose", chooseCategory); 
            provider = (ProviderDTO) session.getAttribute("LOGIN_PROVIDER") ; 
            List<ProviderServiceDTO1> listServiceCategory = dao.loadListServiceCategory() ;
            List<ProviderServiceDTO1> listServiceCategoryChoose = dao.loadListServiceCategoryChoose(chooseCategory) ;
            listStaff = dao.loadListStaff(provider) ; 
            if (listStaff != null) {
                session.setAttribute("Provider_ListStaff", listStaff); 
                session.setAttribute("Providder_ListServiceCategory", listServiceCategory); 
                session.setAttribute("Providder_ListServiceCategoryChoose", listServiceCategoryChoose); 
                url = SUCCESS ; 
            } 
            
        } catch (Exception e) {
        } 
        finally {
            request.getRequestDispatcher(url).include(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
