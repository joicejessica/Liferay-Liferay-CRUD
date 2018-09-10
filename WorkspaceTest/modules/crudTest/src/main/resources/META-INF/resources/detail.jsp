<%@page import="com.lifesysnet.employee.model.Employee"%>
<%@page import="com.lifesysnet.employee.service.EmployeeLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>

<%
int employeeId = ParamUtil.getInteger(request, "empId");
Employee employee = EmployeeLocalServiceUtil.getEmployee(employeeId);
request.setAttribute("employee", employee);
String redirect = ParamUtil.getString(request, "backURL");
%>

<h2>Detail Employee</h2>
<h3>Id : ${employee.empId}</h3>
<h3>Name : ${employee.name}</h3>
<br>

<a href="<%=redirect %>">Back To List Employee</a>