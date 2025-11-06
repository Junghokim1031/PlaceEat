package com.placeeat.util;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class MailUtil {

    private static final String SMTP_HOST = "smtp.naver.com";
    private static final int SMTP_PORT = 587;
    private static final String SMTP_USER = "sa4as@naver.com"; // 실제 네이버 계정
    private static final String SMTP_PASS = "ZWVE9MXHZYS1";      // 네이버 앱 비밀번호

    public static void sendMail(String to, String subject, String htmlContent) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SMTP_USER, "PlaceEat 관리자"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        message.setSubject(subject);
        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}
