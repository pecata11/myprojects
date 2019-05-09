<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<form:form modelAttribute="assignBean" method="POST" action="${saveUrl}" class="niceForm" id="idForm">	
	<div id="loadedContent" class="tableScrollerWrapper">
		<table class="styledTable">
		<tbody>
		<c:forEach items="${lessons}" var="al" varStatus="current">
			<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
				<td><form:checkbox path="lessonIds" value="${al.id}" /></td>
				<td><c:out value="${al.name}" /></td>
				<td>
				<c:if test="${al.grade != null && al.grade != '-1'}">
					<c:out value="${al.grade}" />
				</c:if>
				<c:if test="${al.subject != null && al.subject != '-1'}">
					/<c:out value="${al.subject}" />
				</c:if>
				<c:if test="${al.strand != null && al.strand != '-1'}">
					/<c:out value="${al.strand}" />
				</c:if>
				<c:if test="${al.objective != null && al.objective != '-1'}">
					/<c:out value="${al.objective}" />
				</c:if>
				</td>
			</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>
</form:form>