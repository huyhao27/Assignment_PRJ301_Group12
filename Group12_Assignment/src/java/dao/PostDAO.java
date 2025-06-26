/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import model.*;
import util.DBContext;

/**
 *
 * @author LENOVO
 */
public class PostDAO extends DBContext {

    /**
     * Retrieves all posts from the database.
     *
     * @return An ArrayList of all Post objects.
     */
    public ArrayList<Post> getAllPosts() {
        ArrayList<Post> list = new ArrayList<>();
        String sql = "SELECT postId, userId, content, image, createdAt FROM Posts ORDER BY createdAt DESC";
        try (Connection conn = getConnection(); // Corrected: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Post p = new Post();
                p.setPostId(rs.getInt("postId"));
                p.setUserId(rs.getInt("userId"));
                p.setContent(rs.getString("content"));
                p.setImage(rs.getString("image"));
                p.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a list of posts by a specific user.
     *
     * @param userId The ID of the user whose posts are to be retrieved.
     * @return An ArrayList of Post objects belonging to the specified user.
     */
    public ArrayList<Post> getPostsByUser(int userId) {
        ArrayList<Post> list = new ArrayList<>();
        String sql = "SELECT postId, userId, content, image, createdAt FROM Posts WHERE userId = ?";
        try (Connection conn = getConnection(); // Corrected: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setPostId(rs.getInt("postId"));
                    p.setUserId(rs.getInt("userId"));
                    p.setContent(rs.getString("content"));
                    p.setImage(rs.getString("image"));
                    p.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single post by its postId.
     *
     * @param postId The ID of the post to retrieve.
     * @return The Post object if found, null otherwise.
     */
    public Post getPostById(int postId) {
        String sql = "SELECT postId, userId, content, image, createdAt FROM Posts WHERE postId = ?";
        try (Connection conn = getConnection(); // Corrected: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Post p = new Post();
                    p.setPostId(rs.getInt("postId"));
                    p.setUserId(rs.getInt("userId"));
                    p.setContent(rs.getString("content"));
                    p.setImage(rs.getString("image"));
                    p.setCreatedAt(rs.getTimestamp("createdAt"));
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Adds a new post to the database.
     *
     * @param post The Post object containing details of the new post.
     * @return true if the post was successfully added, false otherwise.
     */
    public boolean addPost(Post post) {
        String sql = "INSERT INTO Posts(userId, image, content) VALUES(?,?,?)";
        try (Connection conn = getConnection(); // Corrected: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getImage());
            ps.setString(3, post.getContent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a post by its postId.
     *
     * @param postId The ID of the post to delete.
     * @return true if the post was successfully deleted, false otherwise.
     */
    public boolean deletePost(int postId) {
        String sql = "DELETE FROM Posts WHERE postId = ?";
        try (Connection conn = getConnection(); // Corrected: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ArrayList<Post> getAllPostsByUserAndFollowing(int userId) {
        ArrayList<Post> list = new ArrayList<>();
        String sql = "SELECT p.postId, p.userId, p.content, p.image, p.createdAt "
                + "FROM Posts p "
                + "WHERE p.userId = ? OR p.userId IN ("
                + "SELECT followingId FROM Follows WHERE followerId = ?"
                + ") ORDER BY p.createdAt DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post();
                    p.setPostId(rs.getInt("postId"));
                    p.setUserId(rs.getInt("userId"));
                    p.setContent(rs.getString("content"));
                    p.setImage(rs.getString("image"));
                    p.setCreatedAt(rs.getTimestamp("createdAt"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Updates an existing post in the database.
     *
     * @param post The Post object with updated content and image.
     * @return true if update was successful, false otherwise.
     */
    public boolean updatePost(Post post) {
        String sql = "UPDATE Posts SET content = ?, image = ? WHERE postId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getContent());
            ps.setString(2, post.getImage());
            ps.setInt(3, post.getPostId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
