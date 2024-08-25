package com.emr.www.service.doctor;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Element;

import com.emr.www.dto.doctor.DrugDTO;
import com.emr.www.entity.doctor.DrugEntity;
import com.emr.www.repository.doctor.DrugRepository;

@Service
public class DrugService extends AbstractApiService<DrugDTO> {

	private final DrugRepository drugRepository;
	
	 public DrugService(@Value("${emr.api.key}") String apiKey, @Value("${emr.api.drug.url}") String apiBaseUrl, DrugRepository drugRepository) {
	        super(apiKey, apiBaseUrl);
	        this.drugRepository = drugRepository;
	    }

	 @Override
	    protected String createApiUrl(String query, Map<String, String> parameters) {
		 parameters.put("DRUG_CPNT_KOR_NM",query); // 검색 단어 비교 url
	        return buildBaseApiUrl(parameters);
	    }
	 
    @Override
    protected DrugDTO parseElementToItem(Element element, String query) {
        DrugDTO drug = new DrugDTO();
        drug.setCpntCd(getElementValue(element, "CPNT_CD"));
        drug.setIngdNameKor(getElementValue(element, "DRUG_CPNT_KOR_NM"));
        drug.setFomlNm(getElementValue(element, "FOML_NM"));
        drug.setDosageRouteCode(getElementValue(element, "DOSAGE_ROUTE_CODE"));
        drug.setDayMaxDosgQyUnit(getElementValue(element, "DAY_MAX_DOSG_QY_UNIT"));
        drug.setDayMaxDosgQy(getElementValue(element, "DAY_MAX_DOSG_QY"));
        return drug;
    }


    @Override
    protected String getComparisonTagName() {
        return "DRUG_CPNT_KOR_NM";
    }
    
    public void saveAllDrugs(List<DrugDTO> drugDTOs) {
		List<DrugEntity> entities = drugDTOs.stream()
				.map(dto -> new DrugEntity(dto.getCpntCd(), dto.getIngdNameKor(), dto.getFomlNm(),
						dto.getDosageRouteCode(), dto.getDayMaxDosgQyUnit(), dto.getDayMaxDosgQy()))
				.toList();
		drugRepository.saveAll(entities);
	}
}
