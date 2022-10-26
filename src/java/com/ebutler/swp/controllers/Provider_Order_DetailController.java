/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ebutler.swp.controllers;

import com.ebutler.swp.dao.ProviderDAO;
import com.ebutler.swp.dto.OrderDetailDTO;
import com.ebutler.swp.dto.OrderDetailInfoDTO;
import com.ebutler.swp.dto.ProductDetailDTO;
import com.ebutler.swp.dto.ProviderDTO;
import com.ebutler.swp.dto.ProviderServiceDTO1;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
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
public class Provider_Order_DetailController extends HttpServlet {

    private final String SUCCESS = "OrderDetailProvider.jsp" ; 
    private final String ERROR = "OrderProvider.jsp" ; 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR ; 
        try {
            List<OrderDetailDTO> listOrderDetail = new ArrayList() ; 
            List<OrderDetailInfoDTO> listDetailInfo = new ArrayList() ; 
            List<ProductDetailDTO> listProductDetail = new ArrayList() ; 
            List<ProviderServiceDTO1> listServiceDetail = new ArrayList() ; 
            int orderID = Integer.parseInt(request.getParameter("orderID")) ;
            String customerID = request.getParameter("customerID") ; 
            HttpSession session = request.getSession() ; 
            ProviderDTO provider = (ProviderDTO) session.getAttribute("LOGIN_PROVIDER") ; 
            ProviderDAO providerDAO = new ProviderDAO() ; 
            listProductDetail = providerDAO.loadListProduct(provider) ; 
            listServiceDetail = providerDAO.loadListService(provider) ; 
            listOrderDetail = providerDAO.loadOrderDetail(provider, orderID) ;
            listDetailInfo = providerDAO.loadOrderInfo(orderID, customerID) ; 
//            if (listProductDetail.isEmpty() && listServiceDetail != null) {
//                
//            }else if (listProductDetail != null && listServiceDetail.isEmpty()) {
//                
//            }
            if (listOrderDetail != null) {
                url = SUCCESS ; 
                session.setAttribute("Order_Detail", listOrderDetail);
                session.setAttribute("Info_Detail", listDetailInfo); 
            }
        } catch (Exception e) {
        }
        finally {
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
