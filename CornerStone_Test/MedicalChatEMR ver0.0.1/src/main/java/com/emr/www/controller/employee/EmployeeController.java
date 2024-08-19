package com.emr.www.controller.employee;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emr.www.service.employee.EmployeeService;

import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
   public EmployeeService employeeService;

    @GetMapping("/searchEmployees")
    @ResponseBody
    public List<Object> searchEmployees(@RequestParam(required = false) String name,
                                        @RequestParam(required = false) String job,
                                        @RequestParam(required = false) String position) {
        return employeeService.searchEmployees(name, job, position);
    }
}
