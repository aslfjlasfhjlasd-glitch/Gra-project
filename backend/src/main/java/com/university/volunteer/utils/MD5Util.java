package com.university.volunteer.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Util {

    /**
     * MD5加密方法
     * @param plainText 明文密码
     * @return 32位小写密文
     */
    public static String encrypt(String plainText) {
        if (plainText == null || plainText.length() == 0) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(plainText.getBytes());
            byte[] byteDigest = md.digest();
            int i;
            StringBuffer buf = new StringBuffer("");
            for (int offset = 0; offset < byteDigest.length; offset++) {
                i = byteDigest[offset];
                if (i < 0)
                    i += 256;
                if (i < 16)
                    buf.append("0");
                buf.append(Integer.toHexString(i));
            }
            // 返回32位小写
            return buf.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // 测试一下
    public static void main(String[] args) {
        // 答辩演示时，你可以展示：输入的 123456 变成了下面这串字符
        System.out.println(encrypt("123456")); 
        // 输出应该是：e10adc3949ba59abbe56e057f20f883e
    }
}