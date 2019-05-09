<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../css/main.css" />
	<link rel="stylesheet" type="text/css" href="../../css/buttons.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
	<title>Quench</title>
</head>

<c:url var="saveUrl" value="/api/pdfRepo/upload" />
<body>
  <b><c:out value="${result}" /></b><br>

  <c:if test="${result == 'SUCCESS'}">
    SUCCESS: <c:out value="${successCount}" /><br/>
    FAIL: <c:out value="${failCount}" />
  </c:if>
</body>
</html>