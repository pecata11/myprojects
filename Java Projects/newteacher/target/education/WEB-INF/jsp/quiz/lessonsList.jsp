<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<c:url var="startUrl" value="/api/perform/start" />
	<c:url var="editUrl" value="/api/lessonEdit/edit" />
	<c:url var="deleteUrl" value="/api/quizzes/delete" />
	<c:url var="assignUrl" value="/api/quizzes/assign" />

		<h1>Lessons</h1>
			<c:forEach items="${quizzes}" var="quiz">
              <div class="row quizRow">
                <div class="left quizName">
  					<a href="${startUrl}?id=${quiz.id}<c:if test="${quiz.assignmentId != null}">&assignmentId=${quiz.assignmentId}</c:if>">${quiz.name}</a>
				</div>
        
                <c:if test="${student != null && student.access == 1}">
				  
				  <a id="deleteBtn" href="${deleteUrl}?id=${quiz.id}" onClick="return confirm('Do you want to delete?');">
				 	<img title="Delete Quiz" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right; margin-top:5px"  />
				  </a>
				  
				</c:if>
				<c:if test="${student != null && student.access == 1}">
						
					<a href="${assignUrl}?id=${quiz.id}" class="right button grey small">Assign</a>
					<c:if test="${not hideEdit}">				  
				 		<a href="${editUrl}?id=${quiz.id}" class="right button grey small">Edit Lesson</a>
				  	</c:if>
				</c:if>
              </div>
			</c:forEach>
		<br></br>
		<a href="javascript:findOther();" class="button grey small">Find Other Lessons To Edit</a>