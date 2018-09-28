<%@page import="com.liferay.portal.kernel.util.ParamUtil"%>
<%@ include file="/init.jsp" %>

<portlet:actionURL name="studentSubmit" var="studentSubmit" />

<div>
	<div>
		<h3 style="text-align: center;"><%=ParamUtil.getInteger(request, "stdId") == 0 ? "Add" : "Edit"%>
			Student Form 
		</h3>
	</div>
	
	<div>
		<aui:form action="<%=studentSubmit%>" method="post" name="studentForm" id="studentForm" enctype="multipart/form-data">
			<aui:input label="Id" name="stdId" id="stdId" type="hidden" value="<%=ParamUtil.getInteger(request, "stdId") == 0 ? "0" : ParamUtil.getInteger(request, "stdId")%>">
			</aui:input>
			
    		<aui:input label="Student Name" id="name" name="name" type="text">
    			<aui:validator name="required" />
    			<aui:validator name="alpha" />
    		</aui:input>
    		
    		<aui:input label="Student Class" id="kelas" name="kelas" type="text">
    			<aui:validator name="required" />
    			<aui:validator name="number" />
    		</aui:input>
    		
    		<div>
    			<aui:input label="Upload File" id="fileupload" name="fileupload" type="file">
    				<%
					if (ParamUtil.getInteger(request, "stdId") == 0) {
					%>
    					<aui:validator name="required" />
    					<aui:validator name="acceptFiles">'pdf'</aui:validator>
    				<%
    					} 
    				%>
    			</aui:input>
    			<%
					if (ParamUtil.getInteger(request, "stdId") != 0) {
				%>
				
				<small class="text-danger">*Kosongkan bila tidak diganti</small>
				
				<%
					}
				%>
    		</div>
			<div>
				<div class="col-md-12 pull-right" style="text-align: right;">
					<aui:button type="submit" />
					<aui:button type="reset" onclick="javascript:closeDialog();" value="Cancel"/>
				</div>
			</div>
		</aui:form>
	</div>
</div>

<!-- <aui:script>
	AUI().use('aui-base','liferay-form',function(A){
		Liferay.Form.student(
				{
					id:'<portlet:namespace/>studentForm',
					fieldRules: [
						{
							body:'',
							custom: false,
							errorMessage:'this field is required',
							fieldName: '<portlet:namespace/>name',
							validatorName:'required'
						},
						{
							body:'',
							custom: false,
							errorMessage:'this field is required',
							fieldName: '<portlet:namespace/>name',
							validatorName:'alpha'
						},
						{
							body:'',
							custom: false,
							errorMessage:'this field is required',
							fieldName: '<portlet:namespace/>kelas',
							validatorName:'required'
						},
						{
							body:'',
							custom: false,
							errorMessage:'this field is required',
							fieldName: '<portlet:namespace/>kelas',
							validatorName:'number'
						},
						{
							body:'',
							custom: false,
							errorMessage:'this field is required',
							fieldName: '<portlet:namespace/>fileupload',
							validatorName:'required'
						},
					]
				});
	});
</aui:script> -->