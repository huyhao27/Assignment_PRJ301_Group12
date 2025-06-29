package dao;

import java.sql.*;
import java.util.ArrayList;
import model.SystemLog;
import util.DBContext;

public class SystemLogDAO extends DBContext {

    public void addLog(String level, String message, Integer userId) {
        String sql = "INSERT INTO SystemLogs (level, message, userId) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, level);
            ps.setString(2, message);
            if (userId != null) {
                ps.setInt(3, userId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<SystemLog> getAllLogs() {
        ArrayList<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT l.logId, l.level, l.message, l.userId, l.createdAt, a.username " +
                     "FROM SystemLogs l LEFT JOIN Accounts a ON l.userId = a.userId " +
                     "ORDER BY l.createdAt DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SystemLog log = new SystemLog();
                log.setLogId(rs.getInt("logId"));
                log.setLevel(rs.getString("level"));
                log.setMessage(rs.getString("message"));
                log.setUserId(rs.getObject("userId", Integer.class));
                log.setCreatedAt(rs.getTimestamp("createdAt"));
                log.setUsername(rs.getString("username")); // Có thể null nếu userId null
                logs.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }
}