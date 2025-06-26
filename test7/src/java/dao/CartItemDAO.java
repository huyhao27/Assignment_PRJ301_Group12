package dao;

import java.sql.*;
import java.util.*;
import model.*;
import util.DBContext;

public class CartItemDAO extends DBContext {

    public ArrayList<CartItem> getCartItemsByCartId(int cartId) {
        ArrayList<CartItem> list = new ArrayList<>();
        String sql = "SELECT * FROM CartItems WHERE cartId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new CartItem(
                            rs.getInt("cartId"),
                            rs.getInt("productId"),
                            rs.getInt("quantity")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCartItem(CartItem item) {
        String sql = "INSERT INTO CartItems(cartId, productId, quantity) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getCartId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCartItemQuantity(int cartId, int productId, int quantity) {
        String sql = "UPDATE CartItems SET quantity = ? WHERE cartId = ? AND productId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeCartItem(int cartId, int productId) {
        String sql = "DELETE FROM CartItems WHERE cartId = ? AND productId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addQuantity(int cartId, int productId, int addAmount) {
        String sql = "UPDATE CartItems SET quantity = quantity + ? WHERE cartId = ? AND productId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addAmount);
            ps.setInt(2, cartId);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void syncCartWithInventory(int cartId) {
        ProductDAO productDAO = new ProductDAO();
        ArrayList<CartItem> items = getCartItemsByCartId(cartId);
        for (CartItem item : items) {
            Product p = productDAO.getProductById(item.getProductId());
            if (p == null || p.getQuantity() == 0) {
                removeCartItem(cartId, item.getProductId());
            } else if (item.getQuantity() > p.getQuantity()) {
                updateCartItemQuantity(cartId, item.getProductId(), p.getQuantity());
            }
        }
    }
}
