package com.study.springboot.servlet;

import com.study.springboot.entity.User;
import com.study.springboot.repository.UserRepository;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;

@WebServlet("/signup")
public class RegistrationServlet extends HttpServlet {

	@Autowired
	private UserRepository userRepository;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String licenseKey = request.getParameter("licenseKey");
		String password = request.getParameter("password");


		User user = new User();
		user.setLicenseKey(licenseKey);
		user.setPassword(password);



		userRepository.save(user);
		response.sendRedirect("registration-success");

	}

}
