package controller;

import dao.SystemLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminLogServlet", urlPatterns = {"/admin/logs"})
public class AdminLogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SystemLogDAO dao = new SystemLogDAO();
        request.setAttribute("logList", dao.getAllLogs());
        request.getRequestDispatcher("/admin/manageLogs.jsp").forward(request, response);
    }
}