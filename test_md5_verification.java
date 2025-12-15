// 临时测试文件 - 验证MD5加密
public class test_md5_verification {
    public static void main(String[] args) {
        String password = "240910132201Cyh";
        String expectedMD5 = "6222728271a396263056093557004505";
        
        // 使用我们的MD5Util加密
        String actualMD5 = MD5Util.encrypt(password);
        
        System.out.println("输入密码: " + password);
        System.out.println("数据库MD5: " + expectedMD5);
        System.out.println("计算MD5: " + actualMD5);
        System.out.println("是否匹配: " + actualMD5.equals(expectedMD5));
    }
}