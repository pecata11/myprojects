<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:url var="logoutUrl" value="/api/auth/logout" />

<div class="nav">
  <div class="innerWidth">
    <ul>
      <sec:authorize ifAnyGranted="ROLE_ADMIN,ROLE_USER">

       	<c:url var="dashboardUrl" value="/api/dashboard/" />
       	<li><a href="${dashboardUrl}">Dashboard</a></li>
       	
       	<c:url var="adminUrl" value="/api/admin/" />
       	<li><a href="${adminUrl}">Admin</a></li>
      
       	<c:url var="lessonUrl" value="/api/lesson/" />
       	<li><a href="${lessonUrl}">Lessons</a></li>
   		
   		<c:url var="lessonUrl" value="/api/feedbackForm/feedback/" />
       	<li><a href="${lessonUrl}">Feedback</a></li>

   		<c:url var="goalUrl" value="/api/goal/list/" />
       	<li><a href="${goalUrl}">Goals</a></li>

       	
       	<li><a href="${logoutUrl}">Logout</a></li>
      </sec:authorize>
      
		<sec:authorize ifAnyGranted="ROLE_STUDENT">
			<c:url var="listUrl" value="/api/quizzes/list" />
			<c:url var="studentDashboardUrl" value="/api/students/dashboard" />
			
			<li><a href="${listUrl}">Lessons</a></li>
			<li><a href="${studentDashboardUrl}">Dashboard</a></li>
			<li><a href="${logoutUrl}">Logout</a></li>
		</sec:authorize>
       	
       <!--  <sec:authorize ifAnyGranted="ROLE_USER">
			<c:url var="createQuizUrl" value="/api/lessonEdit/start" />
	        <li><a href="${createQuizUrl}">Create Lesson</a></li>
	        <c:url var="homeUrl" value="/api/quizzes/list" />
	        <li><a href="${homeUrl}">Edit Lessons and Drafts</a></li>
	        <li><a href="${logoutUrl}">Logout</a></li>
		</sec:authorize>
		-->
    </ul>
  </div>
</div>

<div class="header">
  <div class="innerWidth">
   <!-- <div class="logo">Education Project</div>-->
  </div>
</div>
