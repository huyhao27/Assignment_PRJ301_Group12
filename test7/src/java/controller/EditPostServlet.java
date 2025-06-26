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
import dao.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.*;
import java.io.*;
import java.util.UUID;

/**
 *
 * @author admin
 */
@MultipartConfig
@WebServlet(name = "EditPostServlet", urlPatterns = {"/edit-post"})
public class EditPostServlet extends HttpServlet {

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
            out.println("<title>Servlet EditPostServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditPostServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int postId = Integer.parseInt(request.getParameter("postId"));
        String content = request.getParameter("content");
        Part filePart = request.getPart("postphoto");

        PostDAO postDAO = new PostDAO();
        Post existingPost = postDAO.getPostById(postId);
        String fileName = existingPost.getImage(); // mặc định giữ ảnh cũ

        if (filePart != null && filePart.getSize() > 0) {
            String originalName = getFileName(filePart);
            String extension = originalName.substring(originalName.lastIndexOf('.'));
            fileName = UUID.randomUUID().toString() + extension;

            // build/web/images/post
            String buildPath = getServletContext().getRealPath("/images/post");
            File buildDir = new File(buildPath);
            if (!buildDir.exists()) {
                buildDir.mkdirs();
            }

            // web/images/post
            String projectRoot = getServletContext().getRealPath("/");
            String sourcePath = new File(projectRoot).getParentFile().getParent() + File.separator + "web" + File.separator + "images" + File.separator + "post";
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }

            // Save image to both folders
            File file1 = new File(buildDir, fileName);
            try (InputStream input = filePart.getInputStream(); OutputStream out = new FileOutputStream(file1)) {
                input.transferTo(out);
            }

            try (InputStream input2 = new FileInputStream(file1); OutputStream out2 = new FileOutputStream(new File(sourceDir, fileName))) {
                input2.transferTo(out2);
            }
        }

        // Update post
        Post updatedPost = new Post();
        updatedPost.setPostId(postId);
        updatedPost.setContent(content);
        updatedPost.setImage(fileName);
        postDAO.updatePost(updatedPost);

        response.sendRedirect("profile.jsp");

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
