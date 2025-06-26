package dao;

import java.sql.*;
import model.*;
import util.DBContext;

public class CartDAO extends DBContext {

    public Cart getCartByUserId(int userId) {
        String sql = "SELECT TOP 1 * FROM Carts WHERE userId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Cart(
                        rs.getInt("cartId"),
                        rs.getInt("userId")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createCart(int userId) {
        String sql = "INSERT INTO Carts(userId) VALUES(?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
