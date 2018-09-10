<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@ include file="/init.jsp" %>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.lifesysnet.employee.service.EmployeeLocalServiceUtil"%>
<%@page import="com.lifesysnet.employee.model.Employee"%>
<%@page import="java.util.List"%>
<%@taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<portlet:defineObjects />

<%
String currentUrl = PortalUtil.getCurrentCompleteURL(request);
List<Employee>list = EmployeeLocalServiceUtil.getEmployees(0, EmployeeLocalServiceUtil.getEmployeesCount());
%>

<portlet:renderURL var="addEntryURL">
    <portlet:param name="jspPage" value="/add.jsp" />
</portlet:renderURL>

<aui:button onClick="${addEntryURL}" value="Add"></aui:button>

<liferay-ui:search-container total="<%=list.size() %>" delta="5" deltaConfigurable="true">

	<liferay-ui:search-container-results results="<%=ListUtil.subList(list,searchContainer.getStart(),searchContainer.getEnd()) %>"/>
	
	<liferay-ui:search-container-row className="com.lifesysnet.employee.model.EmployeeModel" modelVar="aEmployeeModel" indexVar="indx">

		<portlet:renderURL var="rowURL">
			<portlet:param name="empId" value="${aEmployeeModel.empId}"/>
			<portlet:param name="jspPage" value="/detail.jsp"/>
			<portlet:param name="backURL" value="<%=currentUrl %>"/>
		</portlet:renderURL>

		<portlet:renderURL var="editURL">
			<portlet:param name="empId" value="${aEmployeeModel.empId}"/>
			<portlet:param name="name" value="${aEmployeeModel.name}"/>
			<portlet:param name="jspPage" value="/add.jsp"/>
		</portlet:renderURL>
		
<%-- 		<liferay-ui:search-container-column-text property="empId" name="Id"/>
 --%>
		<liferay-ui:search-container-column-text name="Id">${searchContainer.getStart()+indx+1}</liferay-ui:search-container-column-text>
		<liferay-ui:search-container-column-text name="Employee Name" href="${rowURL}">${aEmployeeModel.name}</liferay-ui:search-container-column-text>
		
 		<liferay-ui:search-container-column-text href="${rowURL}" name="Detail" value="View"/>
 		
 		<liferay-ui:search-container-column-text href="${editURL}" name="Update" value="Edit"/>
 		
 		<portlet:actionURL var="deleteEmployee" name="deleteEmployee">
 			<portlet:param name="empId" value="${aEmployeeModel.empId}"/>
  			<portlet:param name="backURL" value="<%=currentUrl %>"/>
  		</portlet:actionURL>
  		
 		<%
 			String deleteConfirm = "javascript:confirmDel('"+deleteEmployee+"')";
 		%>
 		<liferay-ui:search-container-column-text href="<%=deleteConfirm%>" name="Delete" value="Delete" />

	</liferay-ui:search-container-row>

	<liferay-ui:search-iterator />
</liferay-ui:search-container>

<script type="text/javascript">
function confirmDel(urlTest){
	msg = "Are you sure wanto delete this ?";
	if(confirm(msg)){
		window.location.href=urlTest;
	}else{
		return false;
	}
}
</script>