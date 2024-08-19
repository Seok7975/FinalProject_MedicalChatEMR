package com.emr.www.service.doctor;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Element;

import com.emr.www.entity.doctor.PrescriptionEntity;
import com.emr.www.entity.doctor.dto.PrescriptionDTO;
import com.emr.www.repository.doctor.api.PrescriptionRepository;

@Service
public class PrescriptionService extends AbstractApiService<PrescriptionDTO> {

	private final PrescriptionRepository prescriptionRepository;
	
    public PrescriptionService(@Value("${api.key}") String apiKey, @Value("${api.prescription.url}") String apiBaseUrl,  PrescriptionRepository prescriptionRepository) {
        super(apiKey, apiBaseUrl);
        this.prescriptionRepository = prescriptionRepository;
    }

    @Override
    protected String createApiUrl(String query, Map<String, String> parameters) {
    	  parameters.put("itemName", query); // 검색 단어 비교 url
    	  return buildBaseApiUrl(parameters);
    }

    @Override
    protected PrescriptionDTO parseElementToItem(Element element, String query) {
        PrescriptionDTO prescription = new PrescriptionDTO();
        prescription.setEntpName(getElementValue(element, "entpName"));
        prescription.setItemSeq(getElementValue(element, "itemSeq"));
        prescription.setItemName(getElementValue(element, "itemName"));
        prescription.setUseMethodQesitm(getElementValue(element, "useMethodQesitm"));
        return prescription;
    }

    @Override
    protected String getComparisonTagName() {
        return "itemName";
    }
    
    public void saveAllPrescriptions(List<PrescriptionDTO> prescriptionDTOs) {
		List<PrescriptionEntity> entities = prescriptionDTOs.stream()
				.map(dto -> new PrescriptionEntity(dto.getItemSeq(), dto.getEntpName(), dto.getItemName(),
						dto.getUseMethodQesitm()))
				.toList();
		prescriptionRepository.saveAll(entities);
	}
}
