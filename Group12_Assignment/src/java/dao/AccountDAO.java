/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
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
public class AccountDAO extends DBContext { // Changed: AccountDAO now extends DBContext

    /**
     * Retrieves all accounts from the database.
     *
     * @return A list of all Account objects.
     */
    public ArrayList<Account> getAllAccounts() {
        ArrayList<Account> list = new ArrayList<>();
        String sql = "SELECT userId, username, password, fullName, email, phone, avatar, role, createdAt FROM Accounts";
        try (Connection conn = getConnection(); // Changed: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Account a = new Account();
                a.setUserId(rs.getInt("userId"));
                a.setUsername(rs.getString("username"));
                a.setPassword(rs.getString("password"));
                a.setFullName(rs.getString("fullName"));
                a.setEmail(rs.getString("email"));
                a.setPhone(rs.getString("phone"));
                a.setAvatar(rs.getString("avatar"));
                a.setRole(rs.getString("role"));
                a.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Deletes an account by its userId.
     *
     * @param userId The ID of the user account to delete.
     * @return true if the account was successfully deleted, false otherwise.
     */
    public boolean deleteAccount(int userId) {
        String sql = "DELETE FROM Accounts WHERE userId = ?";
        try (Connection conn = getConnection(); // Changed: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Registers a new account in the database.
     *
     * @param account The Account object containing details of the new account.
     * @return true if the account was successfully registered, false otherwise.
     */
    // In AccountDAO.java
    public Account registerAccount(Account account, CartDAO cartDAO) {
        String sql = "INSERT INTO Accounts (username, password, fullName, email, phone, avatar, role, createdAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            // Start a transaction
            conn.setAutoCommit(false);

            // Prepare the statement to return generated keys
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            Timestamp now = new Timestamp(System.currentTimeMillis());

            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getFullName());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setString(6, account.getAvatar());
            ps.setString(7, account.getRole());
            ps.setTimestamp(8, now);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Get the generated userId
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);
                    account.setUserId(userId);

                    // Create the cart within the same transaction
                    if (cartDAO.createCart(conn, userId)) { // Pass the connection to the cartDAO
                        // If everything is successful, commit the transaction
                        conn.commit();
                        System.out.println("[DEBUG] Account and Cart created successfully for userId: " + userId);
                        return account; // Return the full account object
                    }
                }
            }

            // If anything fails, rollback the transaction
            conn.rollback();
            return null;

        } catch (SQLException e) {
            System.err.println("[ERROR] Lỗi khi đăng ký account:");
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return null;
        } finally {
            // Clean up resources
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset autocommit
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Retrieves an account by its username.
     *
     * @param username The username of the account to retrieve.
     * @return The Account object if found, null otherwise.
     */
    public Account getAccountByUsername(String username) {
        String sql = "SELECT userId, username, password, fullName, email, phone, avatar, role, createdAt FROM Accounts WHERE username = ?";
        try (Connection conn = getConnection(); // Changed: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account a = new Account();
                    a.setUserId(rs.getInt("userId"));
                    a.setUsername(rs.getString("username"));
                    a.setPassword(rs.getString("password"));
                    a.setFullName(rs.getString("fullName"));
                    a.setEmail(rs.getString("email"));
                    a.setPhone(rs.getString("phone"));
                    a.setAvatar(rs.getString("avatar"));
                    a.setRole(rs.getString("role"));
                    a.setCreatedAt(rs.getTimestamp("createdAt"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves an account by its userId.
     *
     * @param userId The ID of the account to retrieve.
     * @return The Account object if found, null otherwise.
     */
    public Account getAccountById(int userId) {
        String sql = "SELECT userId, username, password, fullName, email, phone, avatar, role, createdAt FROM Accounts WHERE userId = ?";
        try (Connection conn = getConnection(); // Changed: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Account a = new Account();
                    a.setUserId(rs.getInt("userId"));
                    a.setUsername(rs.getString("username"));
                    a.setPassword(rs.getString("password"));
                    a.setFullName(rs.getString("fullName"));
                    a.setEmail(rs.getString("email"));
                    a.setPhone(rs.getString("phone"));
                    a.setAvatar(rs.getString("avatar"));
                    a.setRole(rs.getString("role"));
                    a.setCreatedAt(rs.getTimestamp("createdAt"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Updates an existing account's information.
     *
     * @param account The Account object with updated details.
     * @return true if the account was successfully updated, false otherwise.
     */
    public boolean updateAccount(Account account) {
        String sql = "UPDATE Accounts SET username=?, password=?, fullName=?, email=?, phone=?, avatar=?, role=? WHERE userId=?";
        try (Connection conn = getConnection(); // Changed: Directly calling inherited getConnection()
                 PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getFullName());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setString(6, account.getAvatar());
            ps.setString(7, account.getRole());
            ps.setInt(8, account.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Changes the password of an account if the old password matches.
     *
     * @param userId The ID of the account to change the password for.
     * @param oldPassword The current password of the account.
     * @param newPassword The new password to set.
     * @return true if the password was changed successfully, false otherwise.
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        String checkSql = "SELECT password FROM Accounts WHERE userId = ?";
        String updateSql = "UPDATE Accounts SET password = ? WHERE userId = ?";

        try (Connection conn = getConnection(); PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setInt(1, userId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    String currentPassword = rs.getString("password");

                    // So sánh mật khẩu cũ
                    if (!currentPassword.equals(oldPassword)) {
                        return false; // Sai mật khẩu
                    }

                    // Mật khẩu đúng -> cập nhật mật khẩu mới
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setString(1, newPassword);
                        updateStmt.setInt(2, userId);
                        int rowsAffected = updateStmt.executeUpdate();
                        return rowsAffected > 0;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getUserIdByEmail(String email) {
        String sql = "SELECT userId FROM Accounts WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("userId");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

}
