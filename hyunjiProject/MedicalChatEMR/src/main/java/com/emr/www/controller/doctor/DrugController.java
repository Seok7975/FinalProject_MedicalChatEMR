package com.emr.www.controller.doctor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.emr.www.entity.doctor.dto.DrugDTO;
import com.emr.www.service.doctor.DrugService;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;

@RestController //open api 서버에서 데이터를 가져오기
@RequestMapping("/api/prescriptions")
public class DrugController {

	 @Autowired
	    private DrugService prescriptionService;

	 // 약품 검색을 위한 엔드포인트
	    @GetMapping(value = "/search", produces = "application/xml")
	    public ResponseEntity<String> searchPrescriptions(@RequestParam String query) {
	        
	        List<DrugDTO> prescriptions = prescriptionService.searchPrescriptions(query);

	        try {
	            // List<PrescriptionDTO>를 XML 문자열로 변환
	            XmlMapper xmlMapper = new XmlMapper();
	            String xml = xmlMapper.writeValueAsString(prescriptions);

	            return ResponseEntity.ok()
	                .header(HttpHeaders.CONTENT_TYPE, "application/xml")
	                .body(xml);
	        } catch (Exception e) {
	            e.printStackTrace();
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                .body("<error>XML 변환 중 오류 발생</error>");
	        }
	    }

    // 처방 데이터를 저장하기 위한 엔드포인트
//    @PostMapping("/save")
//    public void savePrescription(@RequestBody PrescriptionDTO prescriptionDTO) {
//    	System.out.println("처방 데이터를 저장하기 위한 컨트롤러 메소드 실행");
//        prescriptionService.savePrescription(prescriptionDTO);
//    }

}
