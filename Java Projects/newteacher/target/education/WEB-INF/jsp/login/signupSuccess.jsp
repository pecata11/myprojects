<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<title>Quench</title>
</head>
<body>
<c:url var="registerUrl" value="/api/signup" />
<div class="nav">
  <div class="innerWidth">
    <ul>
      <li class="right"><a href="${registerUrl}">Sign up</a></li>
    </ul>
  </div>
</div>

<div class="header">
  <div class="innerWidth">
    <div class="logo">Education Project</div>
  </div>
</div>

<div class="innerWidth">


	<c:url var="loginUrl" value="/api/auth/login" />
	
	<div class="page">

		<h1>Successful Registration</h1>

		<p>
			Return to <a href="${loginUrl}">Login Page</a>
		</p>
	</div>
  
  </div>
</body>
</html>