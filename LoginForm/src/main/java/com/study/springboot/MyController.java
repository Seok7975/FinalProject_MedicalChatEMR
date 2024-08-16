package com.study.springboot;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyController {

    @RequestMapping("/")
    public @ResponseBody String root() throws Exception{
        return "JSP in Gradle";
    }
 
    @RequestMapping("/login")
    public String login() {
        return "login";
    }
    
    @RequestMapping("/findPassword")
    public String findPassword() {
        return "findPassword";
    }
     
    @RequestMapping("/registration_form")    
    public String registration() {
        return "registration_form";     
    }
    
}