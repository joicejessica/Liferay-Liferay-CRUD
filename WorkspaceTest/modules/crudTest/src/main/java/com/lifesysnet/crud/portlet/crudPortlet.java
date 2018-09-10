package com.lifesysnet.crud.portlet;

import com.lifesysnet.crud.constants.crudPortletKeys;
import com.lifesysnet.employee.model.Employee;
import com.lifesysnet.employee.service.EmployeeLocalServiceUtil;
import com.liferay.counter.kernel.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.util.ParamUtil;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.ProcessAction;

import org.osgi.service.component.annotations.Component;

/**
 * @author joice
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=CrudLiferay",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + crudPortletKeys.crud,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user",
		"com.liferay.portlet.requires-namespaced-parameters=false",
		"com.liferay.portlet.ajaxable=true"
	},
	service = Portlet.class
)

public class crudPortlet extends MVCPortlet 
{
	public void deleteEmployee(ActionRequest actionRequest, ActionResponse actionResponse) throws IOException, PortletException{
		int employeeId = ParamUtil.getInteger(actionRequest, "empId");
		String backURL = ParamUtil.getString(actionRequest, "backURL");
		try {
			EmployeeLocalServiceUtil.deleteEmployee(employeeId);
			System.out.println("Employee deleted syccessfully with id "+employeeId);
			actionResponse.sendRedirect(backURL);
		} catch (PortalException e) {
			e.printStackTrace();
		}
	}
	
	public void employeeSubmit(ActionRequest request,ActionResponse response) throws IOException, PortletException, PortalException {
		long empId = ParamUtil.getLong(request, "empId");
		String name = ParamUtil.getString(request, "name");
		
		if(empId == 0){
			Long inc = CounterLocalServiceUtil.increment();
			Employee employee = EmployeeLocalServiceUtil.createEmployee(inc);
			employee.setName(name);
			EmployeeLocalServiceUtil.addEmployee(employee);
			System.out.println("Successfully Add "+name);
		}else {
			Employee employee = EmployeeLocalServiceUtil.getEmployee(empId);
			employee.setName(name);
			EmployeeLocalServiceUtil.updateEmployee(employee);
			System.out.println("Successfully Update "+name);
		}
	}
	
	
}
