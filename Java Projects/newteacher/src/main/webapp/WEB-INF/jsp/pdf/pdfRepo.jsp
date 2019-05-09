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
	<%@include file="../header.jsp"%>
	<div class="innerWidth">
		<div class="page">
			<h1>
				Upload a PDF file
			</h1>
			<form method="POST" action="${saveUrl}" enctype="multipart/form-data">
				<div class="red mt15">${uploadError}</div>
				<div class="green mt15">${uploadSuccess}</div>
				
				<input type="file" name="file" /> 
				<input type="submit" value="Upload" name="uploadFile"  />
			</form>
			
			<br><br>
			<b>Pdf Files</b><br>

			<br>
			
			<table class="styledTable">
				<thead style="background:#ccc">
					<tr>
						<th>File Name</th>
						<th>Upload Time</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${pdfFiles}" var="pdfFile">
					<tr>
						<td>${pdfFile.fileName}</td>
						<td><fmt:formatDate value="${pdfFile.createTime}" type="both"  dateStyle="medium" timeStyle="medium" /></td>
					</tr>
					</c:forEach>				
				</tbody>
			</table>			

		</div>
		</div>
</body>
</html>