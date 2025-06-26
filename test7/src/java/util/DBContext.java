package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    private static final String USERNAME_DB = "sa";  
    private static final String PASSWORD_DB = "123";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=SecondUniDB;encrypt=false;trustServerCertificate=true";

    public DBContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "SQL Server JDBC Driver not found!", ex);
            throw new RuntimeException("Failed to load JDBC driver", ex);
        }
    }

    /**
     * Provides a new Connection object each time it is called.
     * This ensures each DAO operation has its own connection and can be safely closed.
     * @return An open Connection object.
     * @throws SQLException If there is an error connecting to the database.
     */
    public Connection getConnection() throws SQLException {
        Connection conn = DriverManager.getConnection(URL, USERNAME_DB, PASSWORD_DB);
        // This line can be removed in a production environment to avoid excessive logging
        System.out.println("Connected successfully!");
        return conn;
    }
}