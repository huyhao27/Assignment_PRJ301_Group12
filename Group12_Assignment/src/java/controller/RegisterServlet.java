package controller;

import dao.AccountDAO;
import dao.CartDAO;
import model.Account;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

// In RegisterServlet.java
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("==== [DEBUG] RegisterServlet - doPost() called ====");

        String fullName = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Create a new Account object
        Account account = new Account();
        account.setUsername(email); // Use email as username
        account.setPassword(password);
        account.setFullName(fullName);
        account.setEmail(email);
        account.setPhone(phone);
        account.setAvatar("default.png");
        account.setRole("user");

        // Use the new transactional method
        Account registeredAccount = accountDAO.registerAccount(account, cartDAO);

        if (registeredAccount != null) {
            // Redirect to the login page on successful registration
            response.sendRedirect("login.jsp");
        } else {
            // Send an error back to the registration page
            request.setAttribute("error", "Email này đã có người sử dụng");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}
