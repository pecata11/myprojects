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
<body class="smallWidth">

	<%@include file="../header.jsp"%>
  
  <div class="innerWidth">

	<div class="page">
  
    <h1>Admin Created</h1>

		<p>${addedAdmin}</p>

		<c:url var="mainUrl" value="/api/quizzes/list" />
		<p>
			Return to <a href="${mainUrl}">quizzes list</a>
		</p>
	</div>
  
  </div>
</body>
</html>