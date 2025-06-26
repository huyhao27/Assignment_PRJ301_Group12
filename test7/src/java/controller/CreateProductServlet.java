/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.*;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import dao.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.util.UUID;

/**
 *
 * @author admin
 */
@MultipartConfig
@WebServlet(name="CreateProductServlet", urlPatterns={"/create-product"})
public class CreateProductServlet extends HttpServlet {
   
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
            out.println("<title>Servlet CreateProductServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateProductServlet at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu form
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        Part filePart = request.getPart("image");

        // Xử lý ảnh
        String imageFileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            String originalName = getFileName(filePart);
            String extension = originalName.substring(originalName.lastIndexOf('.'));
            imageFileName = UUID.randomUUID().toString() + extension;

            // Lưu vào build/web/images/product
            String buildPath = getServletContext().getRealPath("/images/product");
            File buildDir = new File(buildPath);
            if (!buildDir.exists()) buildDir.mkdirs();

            // Lưu vào web/images/product
            String sourcePath = new File(getServletContext().getRealPath("/")).getParentFile().getParent()
                    + File.separator + "web" + File.separator + "images" + File.separator + "product";
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) sourceDir.mkdirs();

            // Ghi ảnh
            File file1 = new File(buildDir, imageFileName);
            try (InputStream input = filePart.getInputStream(); OutputStream out = new FileOutputStream(file1)) {
                input.transferTo(out);
            }

            try (InputStream input2 = new FileInputStream(file1);
                 OutputStream out2 = new FileOutputStream(new File(sourceDir, imageFileName))) {
                input2.transferTo(out2);
            }
        }

        Product product = new Product();
        product.setSellerId(acc.getUserId());
        product.setProductName(productName);
        product.setDescription(description);
        product.setPrice(price);
        product.setQuantity(quantity);
        product.setCategoryId(categoryId);
        product.setImage(imageFileName);

        // Thêm vào DB
        ProductDAO dao = new ProductDAO();
        dao.addProduct(product);

        response.sendRedirect("shop.jsp");

    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        for (String content : header.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
