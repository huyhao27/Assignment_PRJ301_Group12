/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.MessageDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 *
 * @author admin
 */
@MultipartConfig
@WebServlet(name = "ChatServlet", urlPatterns = {"/chat"})
public class ChatServlet extends HttpServlet {

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
            out.println("<title>Servlet ChatServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChatServlet at " + request.getContextPath() + "</h1>");
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
        response.setCharacterEncoding("UTF-8");

        String receiverParam = request.getParameter("receiver");
        String content = request.getParameter("content");

        System.out.println("== LOG ChatServlet ==");
        System.out.println("receiverParam: " + receiverParam);
        System.out.println("content: " + content);

        if (receiverParam == null || content == null || content.trim().isEmpty()) {
            System.out.println("❌ Thiếu dữ liệu gửi tin nhắn.");
            response.setStatus(400);
            return;
        }

        try {
            int receiverId = Integer.parseInt(receiverParam);
            Account sender = (Account) request.getSession().getAttribute("account");

            if (sender == null) {
                System.out.println("❌ Người gửi chưa đăng nhập.");
                response.setStatus(401);
                return;
            }

            int senderId = sender.getUserId();
            new MessageDAO().sendMessage(senderId, receiverId, content);

            System.out.println("Sent successfully");
            response.setStatus(200);
        } catch (NumberFormatException e) {
            System.out.println("Cannot pass receiverID" + receiverParam);
            response.setStatus(400);
        } catch (Exception e) {
            System.out.println("Other error");
            e.printStackTrace();
            response.setStatus(500);
        }

        System.out.println("Start");
        System.out.println("Receiver ID: " + receiverParam);
        System.out.println("Content: " + content);

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
