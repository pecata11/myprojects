<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>

<c:choose>
<c:when test="${empty dashboardResult}">
	There are no goals for the selected Class / Subject / Group.
</c:when>
<c:otherwise>

<c:url var="assignUrl" value="/api/assignLessons/student" />
	<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th><a href="javascript:addSort('name')">Name</a></th>
			<c:forEach items="${headerNames}" var="result" varStatus="current">
				<th><a href="javascript:addSort('${current.index}')">
					<c:out value="${result.name}" />
					</a>
				</th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>

	<c:forEach items="${dashboardResult}" var="student" varStatus="current">
		<tr id="rowStudentInx${current.index}" class="rowStudentClass">
			<td><c:out value="${student.name}" /></td>
      <c:forEach items="${student.results}" var="studentResult" varStatus="inx">
        <c:choose>
          <c:when test="${studentResult.hasResult}">
            <td style="background-color:${studentResult.color}">
              <a href="averageLessonByGoal?studentId=${student.studentId}&goalId=${studentResult.goal.id}">
                <c:out value="${studentResult.result}"/>%
              </a>
            </td>
          </c:when>
          <c:otherwise>
            <td><c:out value="${studentResult.result}"/></td>
          </c:otherwise>
        </c:choose>
      </c:forEach>
    </tr>      
  </c:forEach>
  </tbody>
	</table>
<script>

	function addSort(clolumn) {

	}	
</script>	
</c:otherwise>
</c:choose>