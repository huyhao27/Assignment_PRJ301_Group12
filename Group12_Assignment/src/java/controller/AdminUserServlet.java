package controller;

import dao.AccountDAO;
import dao.SystemLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AccountDAO dao = new AccountDAO();
        ArrayList<Account> userList = dao.getAllAccounts();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/admin/manageUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        AccountDAO dao = new AccountDAO();
        SystemLogDAO logDAO = new SystemLogDAO();
        HttpSession session = request.getSession();
        Account admin = (Account) session.getAttribute("account");
        Integer adminId = (admin != null) ? admin.getUserId() : null;

        if ("delete".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean success = dao.deleteAccount(userId);
            if(success) {
                logDAO.addLog("INFO", "Admin deleted user ID: " + userId, adminId);
            }
        } else if ("reset_password".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            Account user = dao.getAccountById(userId);
            if (user != null) {
                user.setPassword("123456"); 
                boolean success = dao.updateAccount(user);
                 if(success) {
                    logDAO.addLog("INFO", "Admin reset password for user ID: " + userId, adminId);
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}