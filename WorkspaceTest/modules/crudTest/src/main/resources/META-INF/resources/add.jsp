<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="/init.jsp" %>

<%
long employeeId = ParamUtil.getInteger(request, "empId");
String name = ParamUtil.getString(request, "name");
%>

<h3>Employee Form</h3>

<portlet:actionURL name="employeeSubmit" var="employeeSubmit" />

<aui:form action="<%=employeeSubmit%>" method="Post">
	<aui:input label="Id" name="empId" value="<%=employeeId %>" type="hidden"></aui:input>
    <aui:input label="Name" name="name" type="text" />
    <aui:button type="submit" />
</aui:form>