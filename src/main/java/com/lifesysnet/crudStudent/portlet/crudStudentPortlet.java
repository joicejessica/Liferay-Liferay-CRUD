package com.lifesysnet.crudStudent.portlet;

import com.lifesysnet.crudStudent.constants.crudStudentPortletKeys;
import com.lifesysnet.studentservice.model.Student;
import com.lifesysnet.studentservice.service.StudentLocalServiceUtil;
import com.liferay.counter.kernel.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.upload.UploadPortletRequest;
import com.liferay.portal.kernel.util.FileUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.PortletMode;
import javax.portlet.PortletModeException;
import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.portlet.WindowState;
import javax.portlet.WindowStateException;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.osgi.service.component.annotations.Component;

/**
 * @author joice
 */
@Component(immediate = true, property = { "com.liferay.portlet.display-category=Student",
		"com.liferay.portlet.instanceable=true", "javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp", "javax.portlet.name=" + crudStudentPortletKeys.crudStudent,
		"javax.portlet.resource-bundle=content.Language", "com.liferay.portlet.ajaxable=true",
		"javax.portlet.security-role-ref=power-user,user" }, service = Portlet.class)
public class crudStudentPortlet extends MVCPortlet {
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat simpleDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat fullMonthFormat = new SimpleDateFormat("dd MMMM yyyy", Locale.US);
	DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private final static String baseDir = "/student/assignment/";
	private final static String fileInputName = "fileupload";
	Boolean isSearch = false;

	@Override
	public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
			throws IOException, PortletException {
		List<Student> list = new ArrayList<Student>();
		List<Student> searchClass = new ArrayList<Student>();
		String name = ParamUtil.getString(renderRequest, "name");
		String kelas = ParamUtil.getString(renderRequest, "kelas");
		if (isSearch && !name.isEmpty()) {

			list = StudentLocalServiceUtil.findByName(name);
			searchClass = StudentLocalServiceUtil.findByClass(kelas);
			isSearch = false;
		} else {
			list = StudentLocalServiceUtil.getStudents(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
			searchClass = StudentLocalServiceUtil.getStudents(QueryUtil.ALL_POS, QueryUtil.ALL_POS);
		}
		renderRequest.setAttribute("list1", list);
		renderRequest.setAttribute("searchClass", searchClass);
		super.doView(renderRequest, renderResponse);
	}

	public void search(ActionRequest request, ActionResponse response)
			throws IOException, PortletException, PortalException {
		this.isSearch = true;
		redirectAfterSubmit(request, response);
	}

	public void studentSubmit(ActionRequest request, ActionResponse response) throws Exception {
		int stdId = ParamUtil.getInteger(request, "stdId");
		String name = ParamUtil.getString(request, "name");
		String kelas = ParamUtil.getString(request, "kelas");
		String screenName = "";
		this.formatter.setTimeZone(TimeZone.getTimeZone("Asia/Jakarta"));
		Date indoDate = this.simpleDateTimeFormat.parse(formatter.format(new Date()));
		User user = PortalUtil.getUser(request);
		screenName = user.getScreenName();
		String increment = String.valueOf(CounterLocalServiceUtil.increment());

		if (stdId != 0) {
			UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(request);
			Student student = StudentLocalServiceUtil.getStudent(stdId);
			if (uploadRequest.getSize(fileInputName) == 0) {

			} else {
				File outputFile = new File(baseDir + student.getStdId() + "-" + student.getAssignment());
				if (!outputFile.isDirectory())
					outputFile.delete();
				File uploadedFile = uploadRequest.getFile(fileInputName);
				String sourceFileName = uploadRequest.getFileName(fileInputName);
				File folder = new File(baseDir);
				student.setAssignment(sourceFileName);
				File filePath = new File(
						folder.getAbsolutePath() + File.separator + student.getStdId() + "-" + sourceFileName);
				FileUtil.copyFile(uploadedFile, filePath);
			}

			student.setName(name);
			student.setKelas(kelas);
			student.setEditedBy(screenName);
			student.setEditedDate(indoDate);
			StudentLocalServiceUtil.updateStudent(student);

		} else {
			UploadPortletRequest uploadRequest = PortalUtil.getUploadPortletRequest(request);
			if (uploadRequest.getSize(fileInputName) == 0) {
				throw new Exception("Received file is 0 bytes!");
			}

			File uploadedFile = uploadRequest.getFile(fileInputName);
			String sourceFileName = uploadRequest.getFileName(fileInputName);
			File folder = new File(baseDir);
			File filePath = new File(folder.getAbsolutePath() + File.separator + increment + "-" + sourceFileName);

			Student student = StudentLocalServiceUtil.createStudent(Integer.parseInt(increment));
			student.setName(name);
			student.setKelas(kelas);
			student.setAssignment(sourceFileName);
			student.setCreatedBy(screenName);
			student.setCreatedDate(indoDate);
			StudentLocalServiceUtil.addStudent(student);
			FileUtil.copyFile(uploadedFile, filePath);
		}
		redirectAfterSubmit(request, response);

	}

	public void deleteStudent(ActionRequest actionRequest, ActionResponse actionResponse)
			throws IOException, PortletException {
		int studentId = ParamUtil.getInteger(actionRequest, "stdId");
		String backURL = ParamUtil.getString(actionRequest, "backURL");

		try {
			StudentLocalServiceUtil.deleteStudent(studentId);
			System.out.println("Student deleted Successfully with id " + studentId);
			actionResponse.sendRedirect(backURL);
		} catch (PortalException e) {
			e.printStackTrace();
		}
		redirectAfterSubmit(actionRequest, actionResponse);
	}

	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws IOException, PortletException {

		String resourceId = resourceRequest.getResourceID();

		if (resourceId.equals("downloadURL")) {
			String fileName = ParamUtil.getString(resourceRequest, "fileName");
			String fileId = ParamUtil.getString(resourceRequest, "fileId");
			String fileType = FilenameUtils.getExtension(fileName).toLowerCase();
			String type = "";
			switch (fileType) {
			case "pdf":
				type = "application/pdf";
				break;

			default:
				break;
			}

			File outputFile = new File(baseDir + fileId + '-' + fileName);
			resourceResponse.setContentType(type);
			resourceResponse.setProperty("content-disposition", "attachment; fileName=" + fileName);
			OutputStream out = resourceResponse.getPortletOutputStream();
			InputStream in = new FileInputStream(outputFile);
			IOUtils.copy(in, out);
			out.flush();
		}
		super.serveResource(resourceRequest, resourceResponse);
	}

	public void redirectAfterSubmit(ActionRequest request, ActionResponse response)
			throws PortletModeException, WindowStateException, IOException {
		ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		PortletURL redirect = PortletURLFactoryUtil.create(PortalUtil.getHttpServletRequest(request),
				this.getPortletName(), themeDisplay.getLayout().getPlid(), PortletRequest.RENDER_PHASE);
		redirect.setPortletMode(PortletMode.VIEW);
		redirect.setWindowState(WindowState.NORMAL);
		response.sendRedirect(redirect.toString());
	}

	/*
	 * public void studentSubmit(ActionRequest request, ActionResponse response)
	 * throws Exception { int stdId = ParamUtil.getInteger(request, "stdId"); String
	 * name = ParamUtil.getString(request, "name"); String kelas =
	 * ParamUtil.getString(request, "kelas");
	 * 
	 * if (stdId == 0) { // addStudent Student student =
	 * StudentLocalServiceUtil.createStudent(stdId); student.setName(name);
	 * student.setKelas(kelas); StudentLocalServiceUtil.addStudent(student);
	 * System.out.println("Successfully Add Student " + name); } else { // edit
	 * Student student = StudentLocalServiceUtil.getStudent(stdId);
	 * student.setName(name); student.setKelas(kelas);
	 * StudentLocalServiceUtil.updateStudent(student);
	 * System.out.println("Successfully Update Student" + name); } }
	 */

}