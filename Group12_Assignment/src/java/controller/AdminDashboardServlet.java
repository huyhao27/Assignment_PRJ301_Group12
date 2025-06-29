package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalUsers", new AccountDAO().getTotalAccounts());
        request.setAttribute("totalProducts", new ProductDAO().getTotalProducts());
        request.setAttribute("totalPosts", new PostDAO().getTotalPosts());
        request.setAttribute("totalOrders", new OrderDAO().getTotalOrders());
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}