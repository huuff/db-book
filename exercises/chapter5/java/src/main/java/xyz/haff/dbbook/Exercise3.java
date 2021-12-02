package xyz.haff.dbbook;

import java.sql.DriverManager;
import java.util.Scanner;

public class Exercise3 {

    public static void main(String... args) throws Exception {
        var connection = DriverManager.getConnection("jdbc:postgresql://db-book/db_book", "postgres", "");

        System.out.println("Enter the ID of the course to check:");
        var courseToCheck = new Scanner(System.in).next();
        System.out.println(courseToCheck);
    }
}
