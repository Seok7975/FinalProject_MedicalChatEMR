package com.emr.www.config;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.xml.MappingJackson2XmlHttpMessageConverter;
import org.springframework.web.client.RestTemplate;

@Configuration
public class RestConfig {

    @Bean
    public RestTemplate restTemplate() {
    	System.out.println("rest API config 호출");
        RestTemplate restTemplate = new RestTemplate();
        
        // 기존의 HttpMessageConverter를 가져옵니다.
        List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();

        // Jackson을 사용하여 XML 처리
        messageConverters.add(new MappingJackson2XmlHttpMessageConverter()); // Jackson 사용하여 XML 처리

        // String 데이터를 UTF-8로 처리하기 위한 컨버터 추가
        messageConverters.add(new StringHttpMessageConverter(StandardCharsets.UTF_8));

        restTemplate.setMessageConverters(messageConverters);
        return restTemplate;
    }
}
