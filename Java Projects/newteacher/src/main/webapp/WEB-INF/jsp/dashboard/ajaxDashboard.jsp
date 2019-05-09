<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>

<c:url var="assignUrl" value="/api/assignLessons/student" />
	<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th><a href="javascript:addSort('name')">Name</a></th>
			<c:forEach items="${headerNames}" var="result" varStatus="current">
				<th><a href="javascript:addSort('${current.index}')">
					<c:out value="${result.lesonName}" /> <fmt:formatDate value="${result.assignmentStart}" type="both" pattern="MM/dd/yyyy"/>
					</a>
				</th>
			</c:forEach>
			<th><a href="javascript:addSort('growth')">Student Growth</a></th>
			<th><a href="javascript:addSort('group')">Group</a></th>
			<th> </th>
			<th> </th>
		</tr>
	</thead>
	<tbody>
	
	<c:forEach items="${dashboardResult}" var="student" varStatus="current">
		<tr id="rowStudentInx${current.index}" class="rowStudentClass"
		<c:if test="${not dashboardBean.cellColor}">
		 style="background-color:<c:if test="${student.color != null}">${student.color}</c:if>"
		 </c:if>
		 >
			<td><c:out value="${student.name}" /></td>
			
			<c:forEach items="${student.correctAnswer}" var="result" varStatus="inx">
				<c:set var="i" value="${inx.index}" />
				
				<c:choose>
					<c:when test="${dashboardBean.cellColor}">
						<td style="background-color:${student.cellColors[i]}">
					</c:when>
					<c:otherwise>
						<td>
					</c:otherwise>
				</c:choose>
				
					<c:if test="${fn:length(dashboardResult) != current.index + 1}">
						<c:if test="${result != null}">
							<a href="answer?studentId=${student.studentId}&assignmentId=${headerNames[i].assignmentId}">
								<c:out value="${result}" /></a></c:if>
					</c:if>
					<c:if test="${fn:length(dashboardResult) == current.index + 1}">
						<c:if test="${result != null}">
							<a href="averageAnswer?classId=${dashboardBean.classId}&assignmentId=${headerNames[i].assignmentId}">
								<c:out value="${result}" /></a></c:if>
					</c:if>
				</td>
			</c:forEach>
			
			<td><c:if test="${student.studentGrowth != -1}"><c:out value="${student.studentGrowth}" /></c:if></td>
			
			<td>
				<c:if test="${fn:length(dashboardResult) != current.index + 1}">
					<select id="groupId" onchange="javascript:saveGroup(this.value, ${student.studentId} );">
					<c:forEach items="${groups}" var="group">
					  <option value="${group.id}" ${group.id == student.group.id ? 'selected' : '' } >${group.name}</option>
					</c:forEach>
					</select>
				</c:if>
			</td>
			
			<td>
				<c:if test="${fn:length(dashboardResult) != current.index + 1}">
					<a id="deleteBtn" href="javascript:deleteRow(${current.index}, ${student.studentId})">
						<img title="Delete Question" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right"  />
					</a>
				</c:if>
			</td>
			
			<td>
				<c:if test="${fn:length(dashboardResult) != current.index + 1}">
					<a href="${assignUrl}?studentId=${student.studentId}&classId=${dashboardBean.classId}&lessonId=${student.lessonId}" class="right button grey small">Assign Lessons</a>
				</c:if>
			</td>			
		</tr>
	</c:forEach>
	</tbody>
	</table>
	
	<c:url var="ajaxSaveGroupDashboardUrl" value="/api/dashboard/saveGroup" />
<script>	
	function deleteRow(q_num, studentId) {
		var numRows = $('.rowStudentClass').length;
		if(numRows < 2) {
			alert("Cannot Delete - at least 1 row required!");
			return;
		} 
		
		$('#rowStudentInx' + q_num).remove();
		
		var saveSt = $('#excludedStudentIds').val();
		$('#excludedStudentIds').val(saveSt + (saveSt ? ',' : '') + studentId);
		
		reloadDashboard();
	}
	function addSort(clolumn) {
		var old = $('#sortByColumn').val();
		$('#sortByColumn').val(clolumn);
		
		if(old != clolumn){
			$('#sortDirection').val('up');
			reloadDashboard();
			return;
		}
		
		var direction = $('#sortDirection').val();
		if(direction == 'up'){
			$('#sortDirection').val('down');
		} else if(direction == 'down'){
			$('#sortDirection').val('up');
		} else {
			$('#sortDirection').val('up');
		}
		reloadDashboard();
	}	
	
	function saveGroup(groupId, studentId) {
		$.ajax({
		    url: '${ajaxSaveGroupDashboardUrl}',
		    type:'POST',
		    data: {groupId:groupId, studentId:studentId},
			dataType: "json",
			complete: function(transport){
				var data = transport.responseText;
		   		
		    }

		  });
	}	
</script>	