package model;

import java.sql.Timestamp;

public class SystemLog {
    private int logId;
    private String level; // INFO, WARN, ERROR
    private String message;
    private Integer userId; 
    private String username; 
    private Timestamp createdAt;

    public SystemLog() {}

    public SystemLog(int logId, String level, String message, Integer userId, Timestamp createdAt) {
        this.logId = logId;
        this.level = level;
        this.message = message;
        this.userId = userId;
        this.createdAt = createdAt;
    }

    public int getLogId() { return logId; }
    public void setLogId(int logId) { this.logId = logId; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}