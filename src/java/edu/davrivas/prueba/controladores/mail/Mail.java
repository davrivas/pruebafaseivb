/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.davrivas.prueba.controladores.mail;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Properties;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 *
 * @author davrivas
 */
public class Mail {

    private final static String KEY_SMTP_SERVER = "mail.smtp.host";
    private final static String KEY_SMTP_FROM = "mail.smtp.user";
    private final static String KEY_SMTP_PASSWORD = "mail.smtp.password";

    private static Properties props;

    private static void loadConfig() {
        if (props == null) {
            props = new Properties();
            props.put(KEY_SMTP_SERVER, "smtp.gmail.com"); // Servidor SMTP de Google
            props.put(KEY_SMTP_FROM, "simucolombia@gmail.com"); // Correo
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            props.put(KEY_SMTP_PASSWORD, "simuddnj"); // Clave del correo
            props.put("mail.smtp.auth", "true"); // Usar autenticación mediante usuario y clave
            props.put("mail.smtp.starttls.enable", "true"); // Para conectar de manera segura al servidor SMTP
            // Los puertos pueden ser 25, 465 o 587
            props.put("mail.smtp.port", "25"); // El puerto SMTP seguro de Google
        }
    }

    //Solo texto HTML
    public static void sendMail(String destinatario, String asunto, String titulo, String cuerpoHTML) {
        loadConfig();
        Session session = Session.getDefaultInstance(props);
        MimeMessage message = new MimeMessage(session);

        try {
            message.setFrom(new InternetAddress(props.getProperty(KEY_SMTP_FROM)));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
            message.setSubject("[Banco del pueblo] " + asunto);

            Multipart parts = new MimeMultipart();
            BodyPart bodyMail = new MimeBodyPart();
            String html = Mail.template(titulo, cuerpoHTML);
            bodyMail.setContent(html, "text/html");
            parts.addBodyPart(bodyMail);
            message.setContent(parts);

            Transport transport = session.getTransport("smtp");
            transport.connect(props.getProperty(KEY_SMTP_SERVER),
                    props.getProperty(KEY_SMTP_FROM),
                    props.getProperty(KEY_SMTP_PASSWORD));
            transport.sendMessage(message, message.getAllRecipients());
        } catch (MessagingException me) {
            me.printStackTrace();
        }
    }

    // Con archivos adjuntos
    public static void sendMail(String destinatario, String asunto, String titulo, String cuerpoHTML, List<File> archivos) throws IOException {
        loadConfig();
        Session session = Session.getDefaultInstance(props);
        MimeMessage message = new MimeMessage(session);

        try {
            message.setFrom(new InternetAddress(props.getProperty(KEY_SMTP_FROM)));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
            message.setSubject("[Banco del pueblo] " + asunto);

            Multipart parts = new MimeMultipart();
            BodyPart bodyMail = new MimeBodyPart();
            String html = Mail.template(titulo, cuerpoHTML);
            bodyMail.setContent(html, "text/html");
            parts.addBodyPart(bodyMail);

            for (File archivo : archivos) {
                MimeBodyPart attached = new MimeBodyPart();
                attached.attachFile(archivo);
                parts.addBodyPart(attached);
            }

            message.setContent(parts);

            Transport transport = session.getTransport("smtp");
            transport.connect(props.getProperty(KEY_SMTP_SERVER),
                    props.getProperty(KEY_SMTP_FROM),
                    props.getProperty(KEY_SMTP_PASSWORD));
            transport.sendMessage(message, message.getAllRecipients());
        } catch (MessagingException me) {
            me.printStackTrace();
        }
    }

    public static String template(String titulo, String html) {
        String template = "<div style=\"display: flex; flex-direction: row;\">";
        template += "<div style=\"width: 100px; padding: 5px\">";
        template += "<img src=\"https://drive.google.com/uc?export=view&id=1cWgvDh564Tc5yZ3buPut1cRznUILqhtV\" alt=\"image\" width=\"90\" height=\"auto\">";
        template += "<p style=\"color:green; text-align: center; margin: 0;\">Banco del pueblo</p>";
        template += "</div>";
        template += "<div style=\"padding: 5px\">";
        template += "<h1>" + titulo + "</h1>";
        template += html;
        template += "<p><strong>Atentamente:</strong><br>";
        template += "Banco del pueblo";
        template += "</p>";
        template += "</div>";
        template += "</div>";
        return template;
    }
}
