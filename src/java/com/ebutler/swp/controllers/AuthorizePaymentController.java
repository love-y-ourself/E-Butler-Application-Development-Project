/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ebutler.swp.controllers;

import com.ebutler.swp.dto.CartDTO;
import com.ebutler.swp.dto.OrderPayPalDetail;
import com.ebutler.swp.dto.PaymentServiceDTO;
import com.ebutler.swp.dto.UserDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;

import com.paypal.base.rest.PayPalRESTException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author thekh
 */
@WebServlet(name = "AuthorizePaymentController", urlPatterns = {"/AuthorizePaymentController"})
public class AuthorizePaymentController extends HttpServlet {
    
    private static final String ERROR = "errorPage.jsp";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            String total = request.getParameter("total");
            String payment = request.getParameter("payment");
            HttpSession session = request.getSession();
            if (session != null) {
                OrderPayPalDetail order = new OrderPayPalDetail(String.valueOf(total), "0", String.valueOf(total));
                PaymentServiceDTO paymentServices = new PaymentServiceDTO();
                String approvalLink = paymentServices.authorizePayment(order);
                
                response.sendRedirect(approvalLink);
                session.setAttribute("TOTAL", total);
                session.setAttribute("PAYMENT", payment);
            }
            
        } catch (PayPalRESTException e) {
            log("Error at AuthorizePaymentController: " + e.getMessage());
            request.getRequestDispatcher(url).forward(request, response);
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