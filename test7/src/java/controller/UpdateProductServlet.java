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
import jakarta.servlet.annotation.MultipartConfig;
import java.io.*;
import java.util.UUID;
import dao.ProductDAO;
import jakarta.servlet.http.Part;
import model.Product;

/**
 *
 * @author admin
 */
@MultipartConfig
@WebServlet(name = "UpdateProductServlet", urlPatterns = {"/update-product"})
public class UpdateProductServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdateProductServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProductServlet at " + request.getContextPath() + "</h1>");
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy dữ liệu từ form
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        ProductDAO productDAO = new ProductDAO();
        Product oldProduct = productDAO.getProductById(productId);

        if (oldProduct == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        // Kiểm tra ảnh mới
        Part filePart = request.getPart("image");
        String imageName = oldProduct.getImage();

        if (filePart != null && filePart.getSize() > 0 && filePart.getSubmittedFileName() != null && !filePart.getSubmittedFileName().isEmpty()) {
            // Tạo tên file mới
            String originalName = filePart.getSubmittedFileName();
            String extension = originalName.substring(originalName.lastIndexOf('.'));
            String newFileName = UUID.randomUUID().toString() + extension;

            // 1. Lưu vào thư mục build
            String buildPath = getServletContext().getRealPath("/images/product");
            File buildDir = new File(buildPath);
            if (!buildDir.exists()) {
                buildDir.mkdirs();
            }

            File file1 = new File(buildDir, newFileName);
            try (InputStream input = filePart.getInputStream(); OutputStream out = new FileOutputStream(file1)) {
                input.transferTo(out);
            }

            String projectRoot = getServletContext().getRealPath("/");
            String sourcePath = new File(projectRoot).getParentFile().getParent() + File.separator + "web" + File.separator + "images" + File.separator + "product";
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }

            try (InputStream input2 = new FileInputStream(file1); OutputStream out2 = new FileOutputStream(new File(sourceDir, newFileName))) {
                input2.transferTo(out2);
            }

            // Cập nhật tên ảnh mới
            imageName = newFileName;
        }

        // Tạo product mới để cập nhật
        Product updatedProduct = new Product(
                productId,
                oldProduct.getSellerId(),
                productName,
                imageName,
                description,
                price,
                quantity,
                categoryId,
                oldProduct.getCreatedAt()
        );

        boolean success = productDAO.updateProduct(updatedProduct);

        if (success) {
            response.sendRedirect("profile.jsp");
        } else {
            response.getWriter().println("Cập nhật thất bại.");
        }
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
