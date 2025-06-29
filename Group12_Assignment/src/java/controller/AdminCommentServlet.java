package controller;

import dao.CommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminCommentServlet", urlPatterns = {"/admin/comments"})
public class AdminCommentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CommentDAO dao = new CommentDAO();
        request.setAttribute("commentList", dao.getAllComments());
        request.getRequestDispatcher("/admin/manageComments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int commentId = Integer.parseInt(request.getParameter("commentId"));
        new CommentDAO().deleteComment(commentId);
        response.sendRedirect(request.getContextPath() + "/admin/comments");
    }
}