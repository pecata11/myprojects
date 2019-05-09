package com.xentio.eteacher.service;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.session.SessionDestroyedEvent;
import org.springframework.stereotype.Service;

import com.xentio.eteacher.controller.StudentController;
import com.xentio.eteacher.domain.StudentActivity;
import com.xentio.eteacher.domain.User;

@Service
public class StudentTrackListener implements ApplicationListener<ApplicationEvent> {
	protected static Logger logger = Logger.getLogger(StudentController.class);
	
	@Autowired
	private StudentService studentService;

	static Map<String, Long> loggedInMap = new HashMap<String, Long>();

	@Override
	public void onApplicationEvent(ApplicationEvent event) {
		if (event instanceof AuthenticationSuccessEvent) {
			Authentication auth = ((AuthenticationSuccessEvent) event).getAuthentication();
			boolean isAdmin = auth.getAuthorities().contains(new GrantedAuthorityImpl("ROLE_ADMIN"));
			if (isAdmin) {
				return;
			}

			String name = auth.getName();
			loggedInMap.put(auth.getName(), System.currentTimeMillis());
			logger.warn("STUDENT LOGGED IN: " + name);
		} else if (event instanceof SessionDestroyedEvent
				&& ((SessionDestroyedEvent) event).getSecurityContexts() != null
				&& !((SessionDestroyedEvent) event).getSecurityContexts().isEmpty()) {
			Authentication auth = ((SessionDestroyedEvent) event).getSecurityContexts().get(0).getAuthentication();
			boolean isAdmin = auth.getAuthorities().contains(new GrantedAuthorityImpl("ROLE_ADMIN"));
			if (isAdmin) {
				return;
			}

			String name = auth.getName();
			Long timeLoggedIn = loggedInMap.get(name);
			if (timeLoggedIn != null) {
				loggedInMap.remove(name);
				long timeSpent = System.currentTimeMillis() - timeLoggedIn;
				
				User loggedInUser = studentService.searchByUsername(name);
				StudentActivity studentActivity = new StudentActivity();
				studentActivity.setStudentId(loggedInUser.getId().longValue());
				studentActivity.setTimeSpentMlls(timeSpent);
				studentActivity.setWeekOfYear(Calendar.getInstance().get(Calendar.WEEK_OF_YEAR));
				
				studentService.appendTimeSpent(studentActivity);
			}

			logger.warn("STUDENT LOGGED OUT: " + name);
		}
	}
}