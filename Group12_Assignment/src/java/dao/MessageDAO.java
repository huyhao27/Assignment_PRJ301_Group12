package dao;

import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.*;

public class MessageDAO extends DBContext {

    /**
     * Retrieves all messages between two specific users (senderId and
     * receiverId) in both directions.
     *
     * @param senderId The ID of the sender.
     * @param receiverId The ID of the receiver.
     * @return An ArrayList containing Message objects, or an empty ArrayList if
     * no messages are found.
     */
    public ArrayList<Message> getMessagesBetweenUsers(int senderId, int receiverId) {
        ArrayList<Message> messages = new ArrayList<>();
        // SQL query to retrieve messages between two users (A sent to B or B sent to A), ordered by sent time
        String sql = "SELECT messageId, senderId, receiverId, content, sentAt FROM Messages "
                + "WHERE (senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?) "
                + "ORDER BY sentAt ASC";

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, senderId);
            pstmt.setInt(2, receiverId);
            pstmt.setInt(3, receiverId);
            pstmt.setInt(4, senderId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int messageId = rs.getInt("messageId");
                int msgSenderId = rs.getInt("senderId");
                int msgReceiverId = rs.getInt("receiverId");
                String content = rs.getString("content");
                // Convert Timestamp from SQL to Java 8+ LocalDateTime
                Timestamp sentAt = rs.getTimestamp("sentAt");

                Message msg = new Message(messageId, msgSenderId, msgReceiverId, content, sentAt);
                messages.add(msg);
            }
        } catch (SQLException e) {
            Logger.getLogger(MessageDAO.class.getName()).log(Level.SEVERE, "Error retrieving messages between users", e);
        }
        return messages;
    }

    public boolean sendMessage(int senderId, int receiverId, String content) {
        String sql = "INSERT INTO Messages (senderId, receiverId, content, sentAt) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setString(3, content);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Retrieves all messages related to a specific user (where the user is
     * either the sender or the receiver). This can be used to display a user's
     * inbox or all their conversations.
     *
     * @param userId The ID of the user.
     * @return An ArrayList containing Message objects, or an empty ArrayList if
     * no messages are found.
     */
    public ArrayList<Message> getInboxByUser(int userId) {
        ArrayList<Message> messages = new ArrayList<>();
        // SQL query to retrieve messages where the user is either the sender or receiver, ordered by time
        String sql = "SELECT messageId, senderId, receiverId, content, sentAt FROM Messages "
                + "WHERE senderId = ? OR receiverId = ? "
                + "ORDER BY sentAt DESC"; // Order in descending order for most recent messages first

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int messageId = rs.getInt("messageId");
                int msgSenderId = rs.getInt("senderId");
                int msgReceiverId = rs.getInt("receiverId");
                String content = rs.getString("content");
                Timestamp sentAt = rs.getTimestamp("sentAt");

                Message msg = new Message(messageId, msgSenderId, msgReceiverId, content, sentAt);
                messages.add(msg);
            }
        } catch (SQLException e) {
            Logger.getLogger(MessageDAO.class.getName()).log(Level.SEVERE, "Error retrieving user inbox", e);
        }
        return messages;
    }

    public ArrayList<Integer> getContactsForUser(int userId) {
        ArrayList<Integer> contacts = new ArrayList<>();
        String sql = "SELECT DISTINCT CASE WHEN senderId = ? THEN receiverId ELSE senderId END AS contactId "
                + "FROM Messages WHERE senderId = ? OR receiverId = ?";

        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    contacts.add(rs.getInt("contactId"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(MessageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return contacts;
    }

}
