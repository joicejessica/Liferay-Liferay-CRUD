<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.util.ListUtil"%>
<%@page import="com.lifesysnet.studentservice.model.Student"%>
<%@page import="com.lifesysnet.studentservice.service.StudentLocalServiceUtil"%>
<%@page import="java.util.List"%>
<%@ include file="/init.jsp" %>

<%
String currentUrl = PortalUtil.getCurrentCompleteURL(request);
List<Student> list = (List<Student>)request.getAttribute("list1");
List<Student> searchClassValue = (List<Student>)request.getAttribute("searchClass");
%>

<portlet:actionURL name="search" var="searchURL" />

<aui:form action="<%=searchURL%>" method="Post">
	<aui:input label="Search By Name" name="name" type="text" Placeholder="Input Name"/>
	<aui:input label="Search By Class" name="kelas" type="text" Placeholder="Input Class"/>
	<aui:button type="submit" value="Search"/>
</aui:form>
<br>

<portlet:renderURL var="addStudentURL">
    <portlet:param name="jspPage" value="/addStudent.jsp" /> 
</portlet:renderURL>

<portlet:renderURL var="modaladdURL" windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
    <portlet:param name="jspPage" value="/addModal.jsp" /> 
</portlet:renderURL>

<br>
<aui:button onclick="javascript:responUrl('${modaladdURL}');" value="Add Student"/>

<liferay-ui:search-container total="<%=list.size() %>" delta="10" deltaConfigurable="true">

	<liferay-ui:search-container-results results="<%=ListUtil.subList(list,searchContainer.getStart(),searchContainer.getEnd()) %>" />
	
	<liferay-ui:search-container-row className="com.lifesysnet.studentservice.model.Student" modelVar="aStudentModel" indexVar="indx">
	
		<liferay-ui:search-container-column-text name="Id">${searchContainer.getStart()+indx+1}</liferay-ui:search-container-column-text>
		
		<liferay-ui:search-container-column-text name="Name">${aStudentModel.name}</liferay-ui:search-container-column-text>

		<liferay-ui:search-container-column-text name="Class">${aStudentModel.kelas}</liferay-ui:search-container-column-text>
		
		<liferay-ui:search-container-column-text name="Assignment" property="assignment">${aStudentModel.fileName}</liferay-ui:search-container-column-text>

		<liferay-ui:search-container-column-text name="Created Date"><fmt:formatDate value="${aStudentModel.createdDate}" pattern="dd-MMM-yyyy HH:mm:ss" /></liferay-ui:search-container-column-text>

		<liferay-ui:search-container-column-text name="Created By" property="createdBy">${aStudentModel.createdBy}</liferay-ui:search-container-column-text>

		<liferay-ui:search-container-column-text name="Edited Date"><fmt:formatDate value="${aStudentModel.editedDate}" pattern="dd-MMM-yyyy HH:mm:ss" /></liferay-ui:search-container-column-text>

		<liferay-ui:search-container-column-text name="Edited By" property="editedBy">${aStudentModel.editedBy}</liferay-ui:search-container-column-text>

		<liferay-ui:search-container-column-text name="Action">
			<portlet:resourceURL var="downloadURL" id="downloadURL">
				<portlet:param name="fileId" value="${aStudentModel.stdId}" />
				<portlet:param name="fileName" value="${aStudentModel.assignment}" />
			</portlet:resourceURL>
			
			<portlet:renderURL var="viewURL">
				<portlet:param name="stdId" value="${aStudentModel.stdId}" />
				<portlet:param name="jspPage" value="/detailStudent.jsp" />
				<portlet:param name="backURL" value="<%=currentUrl%>" />
			</portlet:renderURL>

			<portlet:renderURL var="editURL" windowState="<%=LiferayWindowState.EXCLUSIVE.toString()%>">
				<portlet:param name="stdId" value="${aStudentModel.stdId}" />
				<portlet:param name="name" value="${aStudentModel.name}" />
				<portlet:param name="kelas" value="${aStudentModel.kelas}" />
				<portlet:param name="jspPage" value="/addModal.jsp" />
			</portlet:renderURL>

			<portlet:actionURL var="deleteStudent" name="deleteStudent">
				<portlet:param name="stdId" value="${aStudentModel.stdId}" />
				<portlet:param name="backURL" value="<%=currentUrl%>" />
			</portlet:actionURL>

			<%String deleteConfirm = "javascript:confirmDel('" + deleteStudent + "')";%>
			

			<liferay-ui:icon image="download" message="Download" url="${downloadURL}" />
			<liferay-ui:icon image="view" message="View" url="${viewURL}" />
			<liferay-ui:icon image="edit" message="Edit" url="javascript:responUrl('${editURL}');" />
			<liferay-ui:icon image="trash" message="Delete" url="javascript:confirmDel('${deleteStudent}');" />
			
<%-- 			<aui:button onClick="${downloadURL}" value="Download"/>
			<aui:button onClick="${viewURL}" value="View"/>
 			<aui:button onclick="javascript:responUrl('${editURL}');" value="Edit"/>
			<aui:button onClick="javascript:confirmDel('${deleteStudent}');" value="Delete"/>	 --%>			
		</liferay-ui:search-container-column-text>
	</liferay-ui:search-container-row>
	<liferay-ui:search-iterator />
</liferay-ui:search-container>

<script type="text/javascript">
function confirmDel(urlTest){
	msg = "Are you sure want to delete this ?";
	if(confirm(msg)){
		window.location.href=urlTest;
	}else{
		return false;
	}
}
</script>

<aui:script>
AUI().use('aui-base',
		'aui-io-plugin-deprecated',
		'liferay-util-window',
		function(A) {
		var popUpWindow=Liferay.Util.Window.getWindow(
			{
			dialog: {
			centered: true,
			constrain2view: true,
			modal: true,
			resizable: false,
			width: 500
			}
			}
			).plug(
			A.Plugin.IO,
			{
			autoLoad: false
			}).hide();
	
		window.responUrl = function(url){
		popUpWindow.show();
		popUpWindow.io.set('uri',url);
		popUpWindow.io.start();

		};
		
		window.closeDialog = function(){
			popUpWindow.hide();
		}
		});

</aui:script>

