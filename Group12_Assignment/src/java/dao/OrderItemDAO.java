package dao;

import util.DBContext;
import model.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object (DAO) for managing OrderItem entities in the database.
 * This class provides methods to retrieve and add items associated with orders,
 * utilizing the DBContext for database connections.
 */
public class OrderItemDAO {

    private DBContext dbContext;

    /**
     * Constructor for OrderItemDAO. Initializes the DBContext instance.
     */
    public OrderItemDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Retrieves all order items belonging to a specific order ID.
     *
     * @param orderId The ID of the order whose items are to be retrieved.
     * @return An ArrayList containing OrderItem objects, or an empty ArrayList
     * if no items are found for the given order.
     */
    public ArrayList<OrderItem> getOrderItemsByOrderId(int orderId) {
        ArrayList<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT orderId, productId, quantity FROM OrderItems WHERE orderId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int fetchedOrderId = rs.getInt("orderId");
                int productId = rs.getInt("productId");
                int quantity = rs.getInt("quantity");

                OrderItem item = new OrderItem(fetchedOrderId, productId, quantity);
                orderItems.add(item);
            }
        } catch (SQLException e) {
            Logger.getLogger(OrderItemDAO.class.getName()).log(Level.SEVERE, "Error retrieving order items for order ID: " + orderId, e);
        }
        return orderItems; // Return the list of order items
    }

    /**
     * Adds a new order item to the database. This method inserts a new record
     * into the 'OrderItems' table.
     *
     * @param item The OrderItem object containing the orderId, productId, and
     * quantity to be added.
     * @return true if the order item was added successfully, false otherwise
     * (e.g., due to a database error or constraint violation).
     */
    public boolean addOrderItem(OrderItem item) {
        // SQL query to insert a new order item.
        // The primary key (orderId, productId) ensures uniqueness for each item within an order.
        String sql = "INSERT INTO OrderItems (orderId, productId, quantity) VALUES (?, ?, ?)";

        try (Connection conn = dbContext.getConnection(); // Obtain a new connection from DBContext
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, item.getOrderId());    // Set the orderId parameter
            pstmt.setInt(2, item.getProductId());  // Set the productId parameter
            pstmt.setInt(3, item.getQuantity());   // Set the quantity parameter

            int affectedRows = pstmt.executeUpdate(); // Execute the update (insert) operation
            return affectedRows > 0; // Return true if at least one row was affected (successfully inserted)

        } catch (SQLException e) {
            Logger.getLogger(OrderItemDAO.class.getName()).log(Level.SEVERE, "Error adding order item: " + item.toString(), e);
            return false;
        }
    }

    public ArrayList<Product> getProductsByOrderId(int orderId) {
        ArrayList<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM OrderItems oi JOIN Products p ON oi.productId = p.productId WHERE oi.orderId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
