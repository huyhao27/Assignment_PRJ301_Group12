/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;
import dao.*;
import model.*;

/**
 *
 * @author admin
 */
@WebServlet(name = "AddToCartServlet", urlPatterns = {"/add-to-cart"})
public class AddToCartServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddToCartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddToCartServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        Account acc = (Account) request.getSession().getAttribute("account");
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = acc.getUserId();
        int productId = 0, quantity = 0;
        try {
            productId = Integer.parseInt(request.getParameter("productId"));
            quantity = Integer.parseInt(request.getParameter("quantity"));
        } catch (Exception e) {
            response.sendRedirect("error.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        CartItemDAO cartItemDAO = new CartItemDAO();
        Cart cart = cartDAO.getCartByUserId(userId);

        if (cart == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        int cartId = cart.getCartId();

        ArrayList<CartItem> listCartItems = cartItemDAO.getCartItemsByCartId(cartId);
        boolean isExisted = false;

        for (CartItem ci : listCartItems) {
            if (ci.getProductId() == productId) {
                isExisted = true;
                break;
            }
        }

        boolean success = false;
        if (isExisted) {
            success = cartItemDAO.addQuantity(cartId, productId, quantity);
        } else {
            CartItem cartItem = new CartItem();
            cartItem.setCartId(cartId);
            cartItem.setProductId(productId);
            cartItem.setQuantity(quantity);
            success = cartItemDAO.addCartItem(cartItem);
        }

        System.out.println("Insert successfully: " + success);
        response.sendRedirect("cart.jsp");

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
