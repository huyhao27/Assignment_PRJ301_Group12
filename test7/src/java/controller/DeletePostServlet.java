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
@WebServlet(name = "DeletePostServlet", urlPatterns = {"/delete-post"})
public class DeletePostServlet extends HttpServlet {

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
            out.println("<title>Servlet DeletePostServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeletePostServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String postIdRaw = request.getParameter("postId");
        if (postIdRaw == null) {
            response.sendRedirect("profile.jsp");
            return;
        }

        int postId = Integer.parseInt(postIdRaw);
        PostDAO postDAO = new PostDAO();
        Post post = postDAO.getPostById(postId);

        if (post == null || post.getUserId() != acc.getUserId()) {
            // Không tìm thấy post hoặc user không có quyền
            response.sendRedirect("profile.jsp");
            return;
        }

        // Xóa ảnh khỏi thư mục nếu có
        if (post.getImage() != null && !post.getImage().isEmpty()) {
            String buildPath = getServletContext().getRealPath("/images/post/" + post.getImage());
            String sourcePath = new File(getServletContext().getRealPath("/")).getParentFile().getParent()
                    + File.separator + "web" + File.separator + "images" + File.separator + "post" + File.separator + post.getImage();

            new File(buildPath).delete();
            new File(sourcePath).delete();
        }

        postDAO.deletePost(postId);
        response.sendRedirect("profile.jsp");

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
