package com.xentio.eteacher.controller;

import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.FeedbackFormBean;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/feedbackForm")
public class FeedbackController {

	@Autowired
	private StudentService studentService;

	@Resource(name = "myProperties")
	private Properties myProperties;

	@RequestMapping(value = "/feedback", method = RequestMethod.GET)
	public String getFeedback(Model model) {

		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());

		FeedbackFormBean feedbackBean = new FeedbackFormBean();
		feedbackBean.setUserName(user.getFirstName());

		model.addAttribute("feedbackBean", feedbackBean);

		return "feedbackForm/feedbackForm";
	}

	@RequestMapping(value = "/feedback", method = RequestMethod.POST)
	public String postFeedback(
			@ModelAttribute("feedbackBean") FeedbackFormBean feedbackBean,
			Model model) {

		String from = feedbackBean.getUserEmail();
		String text = feedbackBean.getFeedback();
		
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		//User user = studentService.searchByUsername(userDetails.getUsername());
		feedbackBean.setUserName(userDetails.getUsername());
		
		EmailValidator emailValidator = new EmailValidator();
		boolean validEmailFrom = emailValidator.validate(from);
		model.addAttribute("validEmailFrom", validEmailFrom);

		boolean result = this.sendEmail(from, text);
		model.addAttribute("result", result);

		return "feedbackForm/feedbackForm";
	}

	private boolean sendEmail(String from, String text) {

		String host = myProperties.getProperty("smtp.host");
		String port = myProperties.getProperty("smtp.port");
		String to = myProperties.getProperty("recipientEmail");
		String authentication = myProperties.getProperty("useAuthentication");
		String emailSubject = myProperties.getProperty("emailSubject");
		// set mail properties.
		Properties props = new Properties();
		props.setProperty("mail.smtp.host", host);
		props.setProperty("mail.smtp.port", port);
		Session mailSession;
		//if we use authentication against mail server.
		if (authentication.equalsIgnoreCase("yes")) {
			String username = myProperties.getProperty("username");
			String password = myProperties.getProperty("password");
			Authenticator authenticator = new Authenticator(username, password);
			props.setProperty("mail.smtp.submitter", authenticator
					.getPasswordAuthentication().getUserName());
			props.setProperty("mail.smtp.auth", "true");
			mailSession = Session.getDefaultInstance(props, authenticator);
		} else {
			mailSession = Session.getDefaultInstance(props);
		}
		Message simpleMessage = new MimeMessage(mailSession);

		InternetAddress fromAddress = null;
		InternetAddress toAddress = null;
		boolean success = false;
		try {
			fromAddress = new InternetAddress(from);
			toAddress = new InternetAddress(to);
			simpleMessage.setFrom(fromAddress);
			simpleMessage.setRecipient(RecipientType.TO, toAddress);
			simpleMessage.setSubject(emailSubject);
			simpleMessage.setText(text);
			Transport.send(simpleMessage);
			success = true;

		} catch (AddressException e) {
			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		}
		return success;
	}

	private class Authenticator extends javax.mail.Authenticator {

		private PasswordAuthentication authentication;

		public Authenticator(String username, String password) {
			authentication = new PasswordAuthentication(username, password);
		}

		protected PasswordAuthentication getPasswordAuthentication() {
			return authentication;
		}
	}

	private class EmailValidator {

		private Pattern pattern;
		private Matcher matcher;

		private static final String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
				+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";

		public EmailValidator() {
			pattern = Pattern.compile(EMAIL_PATTERN);
		}

		public boolean validate(final String hex) {

			matcher = pattern.matcher(hex);
			return matcher.matches();
		}
	}
}