<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	
	<div style="color:#ff0000; padding: 5px 0 0 10px">${emptyAssignmentsError}</div>
	<div style="color:#ff0000; padding: 5px 0 0 10px">${emptyClassError}</div>	
	<c:if test="${fn:length(goal.assignments) > 0}">
		<c:url var="deleteGoalAssignmentUrl" value="/api/goalAssignment/delete" />
		<table id="assignmentsTable" class="styledTable">
			<thead style="background:#ccc">
				<tr>
					<th>Class</th>
					<th>Group</th>
					<th>Student</th>
					<th>Auto Assign</th>
	 				<th></th> 
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${goal.assignments}" var="ass" varStatus="status">
				<tr id="ass_${status.index}">
					<form:hidden path="assignments[${status.index}].id"/>
					<td>
						<form:hidden path="assignments[${status.index}].classId"/>
						<form:hidden path="assignments[${status.index}].className"/>
						${ass.className}
					</td>
					<td>
						<form:hidden path="assignments[${status.index}].groupId"/>
						<form:hidden path="assignments[${status.index}].groupName"/>
						${ass.groupName}
					</td>
					<td>
						<form:hidden path="assignments[${status.index}].studentId"/>
						<form:hidden path="assignments[${status.index}].studentName"/>
						${ass.studentName}
					</td>
					<td>
						<form:hidden path="assignments[${status.index}].auto"/>
						${ass.auto}
					</td>
 					<td>
						<a id="deleteBtn" onClick="javascript:deleteAss(${status.index})">
			 			<img title="Delete Goal Assignment" src="../../../images/delete.png" height="12px" style="margin-top:5px"  /></a>
					</td>
				</tr>
				</c:forEach>				
			</tbody>
		</table>						
	</c:if>		
		
<script>
function deleteAss(index) {
	if(confirm('Delete Goal Assignment?')) {
		$('#ass_' + index).remove();
	}
}
</script>