package xyz.haff.dbbook;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;

public class Exercise3 {
    private static final String QUERY = """
                SELECT prereq.prereq_id
                FROM prereq
                WHERE prereq.course_id = ?
                """;

    private static Set<String> recursivePrereq(Set<String> found, String next, Connection connection) throws Exception {
        var stmt = connection.prepareStatement(QUERY);
        stmt.setString(1, next);


        var resultSet = stmt.executeQuery();
        var foundNext = new HashSet<String>();
        while (resultSet.next()) {
            foundNext.add(resultSet.getString(1));
        }
        foundNext.removeAll(found);
        if (foundNext.isEmpty()) {
            return found;
        } else {
            found.addAll(foundNext);
            for (var singeFoundNext : foundNext) {
                found.addAll(recursivePrereq(found, singeFoundNext, connection));
            }
            return found;
        }
    }

    public static void main(String... args) throws Exception {
        try (var connection = DriverManager.getConnection("jdbc:postgresql://db-book/university", "postgres", "")) {

            System.out.println("Enter the ID of the course to check:");
            var courseToCheck = new Scanner(System.in).next();

            var prereqs = recursivePrereq(new HashSet<>(), courseToCheck, connection);
            for (var prereq : prereqs) {
                System.out.println(prereq);
            }
        }
    }
}
