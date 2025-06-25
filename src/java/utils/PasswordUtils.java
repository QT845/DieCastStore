/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *
 * @author hqthi
 */
public class PasswordUtils {

    public static String encryptSHA256(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte hashByte : hashBytes) {
                String hex = Integer.toHexString(0xff & hashByte);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not available: " + e.getMessage());
            return null;
        } catch (Exception e) {
            System.err.println("Error during SHA-256 encryption: " + e.getMessage());
            return null;
        }
    }
    
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if(plainPassword == null || hashedPassword == null) {
            return false;
        }
        String hash = encryptSHA256(plainPassword);
        return hash.equals(hashedPassword);
    }
//    public static void main(String[] args) {
//        CustomerAccountDAO accountDAO = new CustomerAccountDAO();
//        List<CustomerAccount> list = accountDAO.getAll();
//        for (CustomerAccount a : list) {
//            accountDAO.changePassword(a);
//        }
//    }
}
