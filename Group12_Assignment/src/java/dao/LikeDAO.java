package dao;

import java.sql.*;
import java.util.*;
import util.DBContext;

public class LikeDAO extends DBContext {

    public boolean likePost(int userId, int postId) {
        String sql = "INSERT INTO Likes (userId, postId) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean unlikePost(int userId, int postId) {
        String sql = "DELETE FROM Likes WHERE userId = ? AND postId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<Integer> getLikedPostIdsByUser(int userId) {
        ArrayList<Integer> list = new ArrayList<>();
        String sql = "SELECT postId FROM Likes WHERE userId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("postId"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isLikedByUser(int userId, int postId) {
        String sql = "SELECT 1 FROM Likes WHERE userId = ? AND postId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // true nếu có kết quả
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countLikesByPost(int postId) {
        String sql = "SELECT COUNT(*) FROM Likes WHERE postId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean toggleLike(int userId, int postId) {
        if (isLikedByUser(userId, postId)) {
            return unlikePost(userId, postId);
        } else {
            return likePost(userId, postId);
        }
    }
}
