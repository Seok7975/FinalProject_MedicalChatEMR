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
import com.emr.www.entity.doctor.dto.PrescriptionDTO;
import com.emr.www.service.doctor.DrugService;
import com.emr.www.service.doctor.PrescriptionService;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;

@RestController //open api 서버에서 데이터를 가져오기
@RequestMapping("/api/doctor")
public class DoctorAPIController {

	@Autowired
	private DrugService drugService;
	@Autowired
	private PrescriptionService prescriptionService;

	// 약물 검색을 위한 엔드포인트
	@GetMapping(value = "/drugSearch", produces = "application/xml")
	public ResponseEntity<String> searchDrugs(@RequestParam String query) {

		List<DrugDTO> drugs = drugService.searchDrugs(query);

		try {
			// List<PrescriptionDTO>를 XML 문자열로 변환
			XmlMapper xmlMapper = new XmlMapper();
			String xml = xmlMapper.writeValueAsString(drugs);

			return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/xml").body(xml);
			
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("<error>XML 변환 중 오류 발생</error>");
		}
	}

	//약물 데이터를 저장하기 위한 엔드포인트
	@PostMapping("/drugSave")
	public ResponseEntity<Void> saveDrugs(@RequestBody DrugDTO drugDTO) {
		System.out.println("약물 데이터를 저장하기 위한 컨트롤러 메소드 실행");
		try {
			drugService.saveDrugs(drugDTO);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	// 약품 검색을 위한 엔드포인트
	@GetMapping(value = "/prescriptionsSearch", produces = "application/xml")
	public ResponseEntity<String> searchPrescriptions(@RequestParam String query) {
		
		 List<PrescriptionDTO> prescriptions = prescriptionService.searchPrescriptions(query);

		try {
			// List<PrescriptionDTO>를 XML 문자열로 변환
			   XmlMapper xmlMapper = new XmlMapper();
	            String xml = xmlMapper.writeValueAsString(prescriptions);

			return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/xml").body(xml);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("<error>약품 XML 변환 중 오류 발생</error>");
		}
	}

	//처방 데이터를 저장하기 위한 엔드포인트
	@PostMapping("/prescriptionsSave")
	public ResponseEntity<Void> savePrescription(@RequestBody PrescriptionDTO prescriptionDTO) {
		System.out.println("처방 데이터를 저장하기 위한 컨트롤러 메소드 실행");
		try {
			prescriptionService.savePrescription(prescriptionDTO);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

}
