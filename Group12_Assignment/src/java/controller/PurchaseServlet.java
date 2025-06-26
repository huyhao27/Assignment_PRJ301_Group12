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
import model.*;
import dao.*;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.*;

/**
 *
 * @author admin
 */
@WebServlet(name = "PurchaseServlet", urlPatterns = {"/purchase"})
public class PurchaseServlet extends HttpServlet {

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
            out.println("<title>Servlet PurchaseServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PurchaseServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = acc.getUserId();
        String[] selectedProductIds = request.getParameterValues("selectedProductId[]");
        String shippingAddress = request.getParameter("shippingAddress");

        if (selectedProductIds == null || selectedProductIds.length == 0) {
            response.sendRedirect("cart.jsp");
            return;
        }

        // DAO
        CartDAO cartDAO = new CartDAO();
        CartItemDAO cartItemDAO = new CartItemDAO();
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderItemDAO orderItemDAO = new OrderItemDAO();

        // Lấy giỏ hàng
        Cart cart = cartDAO.getCartByUserId(userId);
        ArrayList<CartItem> allItems = cartItemDAO.getCartItemsByCartId(cart.getCartId());

        // Gom nhóm sản phẩm theo seller
        Map<Integer, List<CartItem>> groupedBySeller = new HashMap<>();
        for (String idStr : selectedProductIds) {
            int pid = Integer.parseInt(idStr);
            for (CartItem item : allItems) {
                if (item.getProductId() == pid) {
                    Product p = productDAO.getProductById(pid);
                    int sellerId = p.getSellerId();
                    groupedBySeller.putIfAbsent(sellerId, new ArrayList<>());
                    groupedBySeller.get(sellerId).add(item);
                    break;
                }
            }
        }

        // Xử lý từng đơn theo seller
        for (Map.Entry<Integer, List<CartItem>> entry : groupedBySeller.entrySet()) {
            List<CartItem> sellerItems = entry.getValue();

            double total = 0;
            for (CartItem item : sellerItems) {
                Product p = productDAO.getProductById(item.getProductId());
                total += p.getPrice() * item.getQuantity();
            }

            Order order = new Order();
            order.setUserId(userId);
            order.setTotalPrice(total);
            order.setStatus("Pending");
            order.setShippingAddress(shippingAddress);
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));

            int orderId = orderDAO.insertOrder(order);

            // Thêm từng OrderItem
            for (CartItem item : sellerItems) {
                Product p = productDAO.getProductById(item.getProductId());

                OrderItem oi = new OrderItem();
                oi.setOrderId(orderId);
                oi.setProductId(p.getProductId());
                oi.setQuantity(item.getQuantity());

                orderItemDAO.addOrderItem(oi);

                // Trừ tồn kho
                p.setQuantity(p.getQuantity() - item.getQuantity());
                productDAO.updateProduct(p);
            }

            // Xóa khỏi giỏ
            for (CartItem item : sellerItems) {
                cartItemDAO.removeCartItem(cart.getCartId(), item.getProductId());
            }
        }

        response.sendRedirect("shop.jsp");
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
