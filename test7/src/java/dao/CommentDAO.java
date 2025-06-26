package dao;

import java.sql.*;
import java.util.*;
import model.Comment;
import util.DBContext;

public class CommentDAO extends DBContext {

    public ArrayList<Comment> getCommentsByPost(int postId) {
        ArrayList<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM Comments WHERE postId = ? ORDER BY createdAt ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Comment(
                            rs.getInt("commentId"),
                            rs.getInt("postId"),
                            rs.getInt("userId"),
                            rs.getString("content"),
                            rs.getTimestamp("createdAt")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addComment(int postId, int userId, String content) {
        String sql = "INSERT INTO Comments (postId, userId, content) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            System.out.println(">> postId = " + postId + ", userId = " + userId + ", content = " + content);

            ps.setInt(1, postId);
            ps.setInt(2, userId);
            ps.setString(3, content);

            int result = ps.executeUpdate();
            System.out.println(">> Insert result: " + result);
            return result > 0;
        } catch (Exception e) {
            System.err.println(">> ERROR inserting comment:");
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM Comments WHERE commentId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Comment getCommentById(int commentId) {
        String sql = "SELECT * FROM Comments WHERE commentId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Comment(
                            rs.getInt("commentId"),
                            rs.getInt("postId"),
                            rs.getInt("userId"),
                            rs.getString("content"),
                            rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
