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
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.OutputStream;
import java.util.UUID;
import model.Account;
import dao.*;
import jakarta.servlet.annotation.MultipartConfig;

/**
 *
 * @author admin
 */
@MultipartConfig
@WebServlet(name = "UpdateAccountServlet", urlPatterns = {"/update-account"})
public class UpdateAccountServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdateAccountServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateAccountServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private String getFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 2, cd.length() - 1);
            }
        }
        return null;
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

        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);

        // Xử lý ảnh đại diện nếu có
        Part avatarPart = request.getPart("avatar");
        String fileName = null;

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String originalName = getFileName(avatarPart);
            String extension = originalName.substring(originalName.lastIndexOf('.'));
            fileName = UUID.randomUUID().toString() + extension;

            // Lưu vào build/web/images/avatar
            String buildPath = getServletContext().getRealPath("/images/avatar");
            File buildDir = new File(buildPath);
            if (!buildDir.exists()) {
                buildDir.mkdirs();
            }
            File file1 = new File(buildDir, fileName);
            try (InputStream input = avatarPart.getInputStream(); OutputStream out = new FileOutputStream(file1)) {
                input.transferTo(out);
            }

            // Copy sang web/images/avatar
            String rootPath = getServletContext().getRealPath("/");
            String webPath = new File(rootPath).getParentFile().getParent()
                    + File.separator + "web" + File.separator + "images" + File.separator + "avatar";
            File webDir = new File(webPath);
            if (!webDir.exists()) {
                webDir.mkdirs();
            }
            try (InputStream input2 = new FileInputStream(file1); OutputStream out2 = new FileOutputStream(new File(webDir, fileName))) {
                input2.transferTo(out2);
            }

            account.setAvatar(fileName); // Cập nhật avatar mới
        }

        // Cập nhật DB
        AccountDAO dao = new AccountDAO();
        boolean updated = dao.updateProfile(account, fileName != null);

        // Cập nhật lại session
        if(updated)session.setAttribute("account", account);

        // Chuyển trang
        response.sendRedirect("settings.jsp");

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
