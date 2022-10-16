/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.ebutler.swp.controllers;

import com.ebutler.swp.dao.OrderDAO;
import com.ebutler.swp.dao.ProductDAO;
import com.ebutler.swp.dto.CartDTO;
import com.ebutler.swp.dto.CartServiceDTO;
import com.ebutler.swp.dto.ConfirmDTO;
import com.ebutler.swp.dto.OrderDTO;
import com.ebutler.swp.dto.ProductDetailDTO;
import com.ebutler.swp.dto.ServiceDetailDTO;
import com.ebutler.swp.dto.UserDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author thekh
 */
@WebServlet(name = "CheckoutController", urlPatterns = {"/CheckoutController"})
public class CheckoutController extends HttpServlet {

    private static final String ERROR = "errorPage.jsp";
    private static final String SUCCESS = "customer_confirmation.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            double total = Double.parseDouble(request.getParameter("total"));
            OrderDTO order = new OrderDTO();
            OrderDAO orderDao = new OrderDAO();
            ProductDAO productDao = new ProductDAO();
            ConfirmDTO confirmation = new ConfirmDTO("Thank you for your order!", "We're sorry! Your order was unsuccessful");
            String statement = confirmation.getFail();
            HttpSession session = request.getSession();
            if (session != null) {
                UserDTO user = (UserDTO) session.getAttribute("LOGIN_USER");
                CartDTO cart = (CartDTO) session.getAttribute("CART");
                CartServiceDTO cartService = (CartServiceDTO) session.getAttribute("CART_SERVICE");
                if (cart != null) {
                    /*flag to count whether the quatity equals to the size of cart
                    if true --> success | false --> fail*/
                    int count = 0;

//                  Check quantity
                    for (ProductDetailDTO product : cart.getCart().values()) {
                        if (productDao.checkQuantiy(product.getId(), product.getQuantity())) {
                            count++;
                        }
                    }

//                  Insert
                    if (count == cart.getCart().values().size()) {
                        orderDao.insertOrder(java.sql.Date.valueOf(java.time.LocalDate.now()), user.getUsername(), 0, total);
                        for (ProductDetailDTO product : cart.getCart().values()) {
                            int order_ID = orderDao.getAllOrder().size();
                            orderDao.insertOrderDetail(product.getId(), order_ID, product.getQuantity(), product.getPrice(), 1);
                            productDao.setQuantiy(product.getId(), product.getQuantity());
                        }
                        statement = confirmation.getSuccess();
                    }
                }
                if (cartService == null) {
                    /*count para to check whether the status of staff is 1 or 0
                    if 1 --> success | 0 --> fail*/
                    int count = 0;
                    for (ServiceDetailDTO service : cartService.getCart().values()) {
                        if (service.getStatus() != 1) {
                            count++;
                        }
                    }
//                    Insert
                    if (count == cartService.getCart().values().size()) {
                        orderDao.insertOrder(java.sql.Date.valueOf(java.time.LocalDate.now()), "hello", 0, total);
                        for (ServiceDetailDTO service : cartService.getCart().values()) {
                            int order_ID = orderDao.getAllOrder().size() + 1;
                            orderDao.insertOrderServiceDetail(service.getStaff_ID(), Integer.parseInt(service.getService_ID()), order_ID, service.getPrice(), 0);
                        }
                    }
                }
            }
            session.setAttribute("STATEMENT", statement);
            url = SUCCESS;
        } catch (Exception e) {
            log("Error at CheckoutController" + e.toString());
        } finally {
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