<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<script>
  if (document.URL.indexOf("195.34.105.196") !== -1) {
    if (!(document.URL.indexOf("staging=true") !== -1)) {
      window.location = 'http://www.sparkmylearning.com';
    } else {
      alert('This is the staging enviroment!\nIF YOU SEE THIS MESSAGE PLEASE CONTACT YOUR TEACHER IMMEDIATELY!');
    }
  }
</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Quench</title>
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
</head>
<body class="smallWidth">

<c:url var="registerUrl" value="/api/signup" />

<div class="nav">
  <div class="innerWidth">
    <ul>
     <!-- <li class="right"><a href="${registerUrl}">Sign up</a></li>-->
    </ul>
  </div>
</div>

<div class="header">
  <div class="innerWidth">
    <!--  <div class="logo">Education Project</div>-->
  </div>
</div>

<div class="innerWidth">


<div class="page">

<h1>Sign in</h1>

	
	<form action="../../j_spring_security_check" method="post" class="niceForm" >
	
		<label for="j_username">Username</label>
		<input id="j_username" name="j_username" type="text" class="fullWidth" />
	
	
		<label for="j_username">Password</label>
        <input id="j_password" name="j_password" value="" type="password" class="fullWidth" />
      
      <c:if test="${error != ''}">
        <div class="red mt15" id="login-error">${error}</div>
      </c:if>
      
      <div class="controls">
        <input  type="submit" value="Sign in" class="button blue right"/>
	 </div>
	</form>

</div>
</div>

<script>
$(document).ready(function() {
	localStorage.removeItem('dashboardInitParams');
});
</script>

</body>
</html>