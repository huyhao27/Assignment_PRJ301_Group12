package dao;

import util.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Notification;

public class NotificationDAO {

    private DBContext dbContext;

    public NotificationDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Retrieves all notifications for a specific user.
     *
     * @param userId The ID of the user.
     * @return An ArrayList containing Notification objects, or an empty
     * ArrayList if no notifications are found.
     */
    public ArrayList<Notification> getNotificationsByUser(int userId) {
        ArrayList<Notification> notifications = new ArrayList<>();
        String sql = "SELECT userId, postId, type, createdAt FROM Notifications WHERE userId = ? ORDER BY createdAt DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int notificationUserId = rs.getInt("userId");
                // Check if postId is NULL in the DB
                Integer postId = rs.getObject("postId", Integer.class);
                String type = rs.getString("type");
                Timestamp createdAt = rs.getTimestamp("createdAt");

                Notification notification = new Notification(notificationUserId, postId, type, createdAt);
                notifications.add(notification);
            }
        } catch (SQLException e) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, "Error getting notifications for user " + userId, e);
        }
        return notifications;
    }

    /**
     * Adds a new notification to the database.
     *
     * @param notification The Notification object containing notification
     * information (userId, postId, type).
     * @return true if the notification was added successfully, false if an
     * error occurred.
     */
    public boolean addNotification(Notification notification) {
        // createdAt is set to GETDATE() by default in the DB, so it does not need to be passed here.
        String sql = "INSERT INTO Notifications (userId, postId, type, createdAt) VALUES (?, ?, ?, GETDATE())";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, notification.getUserId());
            // Check if postId is null
            if (notification.getPostId() == null) {
                pstmt.setNull(2, Types.INTEGER);
            } else {
                pstmt.setInt(2, notification.getPostId());
            }
            pstmt.setString(3, notification.getType());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, "Error adding notification", e);
            return false;
        }
    }

    /**
     * Deletes a specific notification based on userId, postId, and type. This
     * method will delete the notification if the postId matches the provided
     * value. If postId can be NULL in the DB and you want to delete
     * notifications with a NULL postId, you will need a separate method or
     * additional logic to handle that (e.g., passing Integer postId). With the
     * current signature (int postId), it will only delete records where postId
     * is not NULL.
     *
     * @param userId The ID of the user receiving the notification.
     * @param postId The ID of the associated post (0 or -1 could be used as
     * sentinel values if postId is NULL in DB, but will not match actual NULL;
     * consider Integer type for postId if NULL matching is desired).
     * @param type The type of notification ('like', 'cmt', 'fl').
     * @return true if the notification was deleted successfully, false if an
     * error occurred or no notification was found to delete.
     */
    public boolean deleteNotification(int userId, int postId, String type) {
        String sql = "DELETE FROM Notifications WHERE userId = ? AND postId = ? AND type = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, postId);
            pstmt.setString(3, type);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, "Error deleting notification", e);
            return false;
        }
    }

    /**
     * Additional method: Deletes notifications where postId is NULL (e.g., for
     * 'fl' type). You can use this method if you need to delete notifications
     * not related to a specific postId.
     *
     * @param userId The ID of the user.
     * @param type The type of notification.
     * @return true if deleted successfully, false if an error occurred.
     */
    public boolean deleteNotificationWherePostIdIsNull(int userId, String type) {
        String sql = "DELETE FROM Notifications WHERE userId = ? AND type = ? AND postId IS NULL";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setString(2, type);

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, "Error deleting notification (postId IS NULL)", e);
            return false;
        }
    }

    public boolean addFollowNotification(int receiverUserId) {
        Notification notification = new Notification(receiverUserId, null, "fl", null);
        return addNotification(notification);
    }
}
