package dao;

import java.sql.*;
import java.util.*;
import model.*;
import util.DBContext;

public class ProductDAO extends DBContext {

    public ArrayList<Product> getAllProducts() {
        ArrayList<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("productId"), rs.getInt("sellerId"), rs.getString("productName"),
                        rs.getString("image"), rs.getString("description"), rs.getDouble("price"),
                        rs.getInt("quantity"), rs.getInt("categoryId"), rs.getTimestamp("createdAt")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<Product> getProductsBySeller(int sellerId) {
        ArrayList<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE sellerId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Product(
                            rs.getInt("productId"), rs.getInt("sellerId"), rs.getString("productName"),
                            rs.getString("image"), rs.getString("description"), rs.getDouble("price"),
                            rs.getInt("quantity"), rs.getInt("categoryId"), rs.getTimestamp("createdAt")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT * FROM Products WHERE productId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                            rs.getInt("productId"), rs.getInt("sellerId"), rs.getString("productName"),
                            rs.getString("image"), rs.getString("description"), rs.getDouble("price"),
                            rs.getInt("quantity"), rs.getInt("categoryId"), rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Products(sellerId, productName, image, description, price, quantity, categoryId) VALUES(?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, product.getSellerId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getImage());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setInt(6, product.getQuantity());
            ps.setInt(7, product.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE Products SET productName=?, image=?, description=?, price=?, quantity=?, categoryId=? WHERE productId=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setInt(5, product.getQuantity());
            ps.setInt(6, product.getCategoryId());
            ps.setInt(7, product.getProductId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE productId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ArrayList<Product> getBestSellingProducts(int limit) {
        ArrayList<Product> list = new ArrayList<>();
        try (Connection conn = getConnection();){ // Using try-with-resources for connection
            String sql = "SELECT TOP (?) p.productId, p.productName, p.image, p.price, p.sellerId, p.description, p.quantity, p.categoryId, p.createdAt " // <-- ADDED ALL COLUMNS
                        + "FROM Products p "
                        + "LEFT JOIN OrderItems oi ON p.productId = oi.productId " // Changed to LEFT JOIN in case a product has no sales yet
                        + "LEFT JOIN Orders o ON oi.orderId = o.orderId AND o.status = 'Completed' " // Filter by completed status here
                        + "GROUP BY p.productId, p.productName, p.image, p.price, p.sellerId, p.description, p.quantity, p.categoryId, p.createdAt " // <-- ADDED ALL COLUMNS to GROUP BY
                        + "ORDER BY SUM(CASE WHEN o.status = 'Completed' THEN oi.quantity ELSE 0 END) DESC, p.productId ASC"; // Order by completed quantity, then productId for tie-breaking

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Populate all fields for the Product constructor
                list.add(new Product(
                        rs.getInt("productId"),
                        rs.getInt("sellerId"),
                        rs.getString("productName"),
                        rs.getString("image"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("quantity"),
                        rs.getInt("categoryId"),
                        rs.getTimestamp("createdAt")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


}
