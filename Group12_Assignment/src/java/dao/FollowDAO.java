package dao;

import util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FollowDAO {

    private DBContext dbContext;

    public FollowDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Performs the action of following a user. Adds a new record to the Follows
     * table.
     *
     * @param followerId The ID of the follower (the user performing the follow
     * action).
     * @param followingId The ID of the user being followed.
     * @return true if the follow action was successful, false if there was an
     * error or already following.
     */
    public boolean followUser(int followerId, int followingId) {
        String sql = "INSERT INTO Follows (followerId, followingId, followedAt) VALUES (?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, followerId);
            pstmt.setInt(2, followingId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            Logger.getLogger(FollowDAO.class.getName()).log(Level.SEVERE, "Error following user " + followingId + " by " + followerId, e);
            return false;
        }
    }

    /**
     * Performs the action of unfollowing a user. Deletes a record from the
     * Follows table.
     *
     * @param followerId The ID of the user unfollowing.
     * @param followingId The ID of the user being unfollowed.
     * @return true if the unfollow action was successful, false if there was an
     * error or no record to delete.
     */
    public boolean unfollowUser(int followerId, int followingId) {
        String sql = "DELETE FROM Follows WHERE followerId = ? AND followingId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, followerId);
            pstmt.setInt(2, followingId);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0; // Returns true if at least one row was affected (deleted)

        } catch (SQLException e) {
            Logger.getLogger(FollowDAO.class.getName()).log(Level.SEVERE, "Error unfollowing user " + followingId + " by " + followerId, e);
            return false;
        }
    }

    /**
     * Retrieves a list of IDs of users who are following a specific user
     * (followers).
     *
     * @param userId The ID of the user for whom to retrieve the list of
     * followers.
     * @return An ArrayList containing the IDs of followers, or an empty
     * ArrayList if there are none.
     */
    public ArrayList<Integer> getFollowers(int userId) {
        ArrayList<Integer> followers = new ArrayList<>();
        String sql = "SELECT followerId FROM Follows WHERE followingId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                followers.add(rs.getInt("followerId"));
            }
        } catch (SQLException e) {
            Logger.getLogger(FollowDAO.class.getName()).log(Level.SEVERE, "Error getting followers for user " + userId, e);
        }
        return followers;
    }

    /**
     * Retrieves a list of IDs of users that a specific user is following.
     *
     * @param userId The ID of the user for whom to retrieve the list of users
     * being followed.
     * @return An ArrayList containing the IDs of users being followed, or an
     * empty ArrayList if there are none.
     */
    public ArrayList<Integer> getFollowing(int userId) {
        ArrayList<Integer> following = new ArrayList<>();
        String sql = "SELECT followingId FROM Follows WHERE followerId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                following.add(rs.getInt("followingId"));
            }
        } catch (SQLException e) {
            Logger.getLogger(FollowDAO.class.getName()).log(Level.SEVERE, "Error getting following for user " + userId, e);
        }
        return following;
    }

    public boolean isFollowing(int followerId, int followingId) {
        String sql = "SELECT 1 FROM Follows WHERE followerId = ? AND followingId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, followerId);
            pstmt.setInt(2, followingId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            Logger.getLogger(FollowDAO.class.getName()).log(Level.SEVERE, "Error checking follow status", e);
        }
        return false;
    }
}
