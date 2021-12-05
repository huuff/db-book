package xyz.haff.dbbook;

import org.junit.jupiter.api.Test;

import java.sql.DriverManager;
import java.util.ArrayList;

public class Exercise2 {

    @Test
    void exercise2() throws Exception {
        try (var connection = DriverManager.getConnection("jdbc:postgresql://db-book/university", "postgres", "")) {

            var stmt = connection.createStatement();
            var resultSet = stmt.executeQuery("SELECT * FROM student");

            var columns = new ArrayList<String>();
            for (int i = 1; i <= resultSet.getMetaData().getColumnCount(); i++) {
                columns.add(resultSet.getMetaData().getColumnName(i));
            }
            System.out.println(String.join("|", columns));
            System.out.println("----------------------------------------");

            while (resultSet.next()) {
                var row = new ArrayList<String>();
                for (int i = 1; i <= resultSet.getMetaData().getColumnCount(); i++) {
                    row.add(resultSet.getString(i));
                }
                System.out.println(String.join("|", row));
            }
        }
    }
}
