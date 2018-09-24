<%@page import="com.lifesysnet.studentservice.service.StudentLocalServiceUtil"%>
<%@page import="com.lifesysnet.studentservice.model.Student"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="/init.jsp" %>

<%
int studentId = ParamUtil.getInteger(request, "stdId");
Student student = StudentLocalServiceUtil.getStudent(studentId);
request.setAttribute("student", student);
String redirect = ParamUtil.getString(request, "backURL");
%>

<h3>Detail Student</h3>

<p>Id : ${student.stdId}</p>
<p>Name : ${student.name}</p>
<p>Kelas : ${student.kelas}</p>
<p>Assignment : ${student.assignment}</p>
<br>
<a href="<%=redirect %>">Back To Student List</a>