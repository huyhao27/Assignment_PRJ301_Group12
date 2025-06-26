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
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
    public boolean registerAccount(Account account) {
        String sql = "INSERT INTO Accounts(username, password, fullName, email, phone, avatar, role) VALUES(?,?,?,?,?,?,?)";
        try (Connection conn = getConnection(); // Changed: Directly calling inherited getConnection()
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getFullName());
            ps.setString(4, account.getEmail());
            ps.setString(5, account.getPhone());
            ps.setString(6, account.getAvatar());
            ps.setString(7, account.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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
}