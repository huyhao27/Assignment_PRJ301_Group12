/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.*;
import model.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;

/**
 *
 * @author admin
 */
@WebServlet(name="DeleteProductServlet", urlPatterns={"/delete-product"})
public class DeleteProductServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet DeleteProductServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteProductServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String productIdRaw = request.getParameter("productId");
        if (productIdRaw == null) {
            response.sendRedirect("shop.jsp"); // hoặc trang khác tùy bạn
            return;
        }

        int productId = Integer.parseInt(productIdRaw);
        ProductDAO dao = new ProductDAO();
        Product product = dao.getProductById(productId);

        // Kiểm tra quyền sở hữu
        if (product == null || product.getSellerId() != acc.getUserId()) {
            response.sendRedirect("shop.jsp");
            return;
        }

        // Xóa ảnh nếu có
        if (product.getImage() != null && !product.getImage().isEmpty()) {
            String fileName = product.getImage();

            // 1. Build path
            String buildPath = getServletContext().getRealPath("/images/product/" + fileName);
            File buildFile = new File(buildPath);
            if (buildFile.exists()) buildFile.delete();

            // 2. Source (web) path
            String sourcePath = new File(getServletContext().getRealPath("/")).getParentFile().getParent()
                    + File.separator + "web" + File.separator + "images" + File.separator + "product" + File.separator + fileName;
            File sourceFile = new File(sourcePath);
            if (sourceFile.exists()) sourceFile.delete();
        }

        dao.deleteProduct(productId);
        response.sendRedirect("shop.jsp");

    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
