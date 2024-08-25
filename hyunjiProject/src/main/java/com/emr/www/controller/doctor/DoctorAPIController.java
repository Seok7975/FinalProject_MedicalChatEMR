package com.emr.www.controller.doctor;

import java.util.HashMap;
import java.util.List;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.emr.www.dto.doctor.DiagnosisDTO;
import com.emr.www.dto.doctor.DrugDTO;
import com.emr.www.dto.doctor.PrescriptionDTO;
import com.emr.www.service.doctor.ChatGPTDiagnosisService;
import com.emr.www.service.doctor.DiagnosisService;
import com.emr.www.service.doctor.DrugService;
import com.emr.www.service.doctor.PrescriptionService;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;

@RestController
@RequestMapping("/api/doctor")
public class DoctorAPIController {

	private final DrugService drugService;
	private final PrescriptionService prescriptionService;
	private final DiagnosisService diagnosisService;

	private final ChatGPTDiagnosisService chatGPTDiagnosisService;

	public DoctorAPIController(DrugService drugService, PrescriptionService prescriptionService, DiagnosisService diagnosisService,
			ChatGPTDiagnosisService chatGPTDiagnosisService) {
		this.drugService = drugService;
		this.prescriptionService = prescriptionService;
		this.diagnosisService = diagnosisService;
		this.chatGPTDiagnosisService = chatGPTDiagnosisService;
	}

	@GetMapping(value = "/drugSearch", produces = "application/xml")
	public ResponseEntity<String> searchDrugs(@RequestParam String query) {
		try {
			List<DrugDTO> drugs = drugService.search(query, new HashMap<>());
			XmlMapper xmlMapper = new XmlMapper();
			String xml = xmlMapper.writeValueAsString(drugs);
			return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/xml").body(xml);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("<error>XML 변환 중 오류 발생</error>");
		}
	}

	@GetMapping(value = "/prescriptionsSearch", produces = "application/xml")
	public ResponseEntity<String> searchPrescriptions(@RequestParam String query) {
		try {
			List<PrescriptionDTO> prescriptions = prescriptionService.search(query, new HashMap<>());
			XmlMapper xmlMapper = new XmlMapper();
			String xml = xmlMapper.writeValueAsString(prescriptions);
			return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/xml").body(xml);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("<error>XML 변환 중 오류 발생</error>");
		}
	}

	@GetMapping(value = "/diagnosisSearch", produces = "application/xml")
	public ResponseEntity<String> searchDiagnosis(@RequestParam String query) {
		try {
			List<DiagnosisDTO> diagnosisList = diagnosisService.search(query, new HashMap<>());
			XmlMapper xmlMapper = new XmlMapper();
			String xml = xmlMapper.writeValueAsString(diagnosisList);
			return ResponseEntity.ok().header(HttpHeaders.CONTENT_TYPE, "application/xml").body(xml);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("<error>XML 변환 중 오류 발생</error>");
		}
	}

	//챗 지피티 연동
	@GetMapping("/chatgpt")
	public ResponseEntity<String> getChatGPTResponse(@RequestParam String prompt) {
		try {
			String response = chatGPTDiagnosisService.getChatGPTResponse(prompt);
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("ChatGPT 응답 중 오류 발생");
		}
	}

}
