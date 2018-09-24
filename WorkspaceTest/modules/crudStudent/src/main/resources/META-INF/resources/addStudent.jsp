<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="/init.jsp" %>

<%
long studentId = ParamUtil.getInteger(request, "stdId");
String name = ParamUtil.getString(request, "name");
%>

<h3>Student Form</h3>

<portlet:actionURL name="studentSubmit" var="studentSubmit" />

<aui:form action="<%=studentSubmit%>" method="Post">
	<aui:input label="Id" name="stdId" value="<%=studentId %>" type="hidden"></aui:input>
    <aui:input label="Name" name="name" type="text" ><aui:validator name="required" /></aui:input>
    <aui:input label="Kelas" name="kelas" type="text" ><aui:validator name="required" /></aui:input>
    <aui:button type="submit" />
</aui:form>