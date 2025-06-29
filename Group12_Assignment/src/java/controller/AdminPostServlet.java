package controller;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Post;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "AdminPostServlet", urlPatterns = {"/admin/posts"})
public class AdminPostServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PostDAO dao = new PostDAO();
        ArrayList<Post> postList = dao.getAllPosts();
        request.setAttribute("postList", postList);
        request.getRequestDispatcher("/admin/managePosts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int postId = Integer.parseInt(request.getParameter("postId"));
            new PostDAO().deletePost(postId);
        }
        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }
}