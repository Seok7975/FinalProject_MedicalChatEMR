package com.emr.www.service.doctor;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Element;

import com.emr.www.dto.doctor.DiagnosisDTO;
import com.emr.www.entity.doctor.DiagnosisEntity;
import com.emr.www.repository.doctor.DiagnosisRepository;

@Service
public class DiagnosisService extends AbstractApiService<DiagnosisDTO> {

	private final DiagnosisRepository diagnosisRepository;

	public DiagnosisService(@Value("${emr.api.key}") String apiKey, @Value("${emr.api.diagnosis.url}") String apiBaseUrl,
			DiagnosisRepository diagnosisRepository) {
		super(apiKey, apiBaseUrl);
		this.diagnosisRepository = diagnosisRepository;
	}

	@Override
	protected String createApiUrl(String query, Map<String, String> parameters) {
		parameters.put("sickType", "1"); // 고정된 값
		parameters.put("medTp", "1"); // 고정된 값
		parameters.put("searchText", query); // searchText 사용
		return buildBaseApiUrl(parameters);
	}

	// API에서 반환된 XML Element를 DiagnosisDTO 객체로 변환
	@Override
	protected DiagnosisDTO parseElementToItem(Element element, String query) {
		DiagnosisDTO diagnosis = new DiagnosisDTO();
		diagnosis.setDiseaseCode(getElementValue(element, "sickCd"));
		diagnosis.setDiseaseName(getElementValue(element, "sickNm"));
		return diagnosis;
	}

	@Override
	protected String getComparisonTagName() {
		return "sickNm";
	}

	public void saveAllDiagnosis(List<DiagnosisDTO> diagnosisDTOs) {
	        List<DiagnosisEntity> entities = diagnosisDTOs.stream()
	                .map(dto -> new DiagnosisEntity(dto.getDiseaseCode(), dto.getDiseaseName()))
	                .toList();
	        diagnosisRepository.saveAll(entities);
	    }
}
