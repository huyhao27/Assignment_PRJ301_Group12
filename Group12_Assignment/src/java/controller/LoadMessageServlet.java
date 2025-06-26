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
import jakarta.servlet.http.HttpSession;
import model.*;
import dao.*;
import java.util.*;

/**
 *
 * @author admin
 */
@WebServlet(name = "LoadMessageServlet", urlPatterns = {"/load-messages"})
public class LoadMessageServlet extends HttpServlet {

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
            out.println("<title>Servlet LoadMessageServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadMessageServlet at " + request.getContextPath() + "</h1>");
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
        Account currentUser = (Account) session.getAttribute("account");
        if (currentUser == null) {
            response.setStatus(401);
            return;
        }

        String otherIdRaw = request.getParameter("userId");
        if (otherIdRaw == null) {
            response.setStatus(400);
            return;
        }

        int currentUserId = currentUser.getUserId();
        int otherUserId;

        try {
            otherUserId = Integer.parseInt(otherIdRaw);
        } catch (NumberFormatException e) {
            response.setStatus(400);
            return;
        }

        MessageDAO dao = new MessageDAO();
        AccountDAO accDao = new AccountDAO();
        ArrayList<Message> messages = dao.getMessagesBetweenUsers(currentUserId, otherUserId);

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            for (Message m : messages) {
                boolean isSender = m.getSenderId() == currentUserId;
                out.println("<div class='message " + (isSender ? "sent" : "received") + "'>");
                if (!isSender) {
                    Account sender = accDao.getAccountById(m.getSenderId());
                    String avatar = (sender != null && sender.getAvatar() != null)
                            ? sender.getAvatar()
                            : "default.png";
                    out.println("<img src='images/avatar/" + escapeHtml(avatar) + "' class='message-avatar'/>");
                }
                out.println("<div class='message-content'>" + escapeHtml(m.getContent()) + "</div>");
                out.println("</div>");
            }
        }

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

    private String escapeHtml(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }

}
