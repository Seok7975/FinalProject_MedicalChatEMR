package com.emr.www.service.doctor;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.emr.www.entity.doctor.DrugEntity;
import com.emr.www.entity.doctor.dto.DrugDTO;
import com.emr.www.repository.doctor.DrugRepository;

@Service
public class DrugService {

	private final DrugRepository drugRepository;

	@Value("${api.key}")
	private String apiKey;

	@Value("${api.drug.url}")
	private String apiBaseUrl;

	@Autowired
	public DrugService(DrugRepository drugRepository) {
		this.drugRepository = drugRepository;
	}

	//약물 api 호출 메서드
	private String callDrugDirectly(String query, int numOfRows, int pageNo) {
		StringBuilder result = new StringBuilder();
		String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8);
		String apiUrl = String.format("%s?serviceKey=%s&numOfRows=%d&pageNo=%d&type=%s&DRUG_CPNT_KOR_NM=%s", apiBaseUrl, apiKey, numOfRows, // numOfRows
				pageNo, // pageNo
				"xml", // type
				encodedQuery);
		try {
			URL url = new URL(apiUrl);
			HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
			urlConnection.setRequestMethod("GET");
			try (BufferedReader br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"))) {
				String line;
				while ((line = br.readLine()) != null) {
					result.append(line).append("\n");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error during API call: " + e.getMessage());
		}
		return result.toString();
	}

	//검색된 약물명을 기준으로 데이터 가져오기
	public List<DrugDTO> searchDrugs(String query) {
		Set<String> seenDrugNames = new HashSet<>(); // 중복을 확인하기 위한 Set
		List<DrugDTO> uniqueDrugs = new ArrayList<>();
		int pageNo = 1;
		int numOfRows = 100; // 최대 크기로 설정
		boolean morePages = true;

		while (morePages) {
			String rawXmlResponse = callDrugDirectly(query, numOfRows, pageNo);
			List<DrugDTO> drugs = parseXmlToDrugList(rawXmlResponse);
			if (drugs.isEmpty()) {
				morePages = false;
			} else {
				for (DrugDTO drug : drugs) {
					if (seenDrugNames.add(drug.getDrugCpntKorNm())) { // 새로운 약품명일 경우에만 추가
						uniqueDrugs.add(drug);
					}
				}
				pageNo++;
			}
		}

		return uniqueDrugs;
	}

	// XML 응답을 DTO 목록으로 변환
	private List<DrugDTO> parseXmlToDrugList(String rawXmlResponse) {
		List<DrugDTO> prescriptionList = new ArrayList<>();

		if (rawXmlResponse == null || rawXmlResponse.trim().isEmpty()) {
			return prescriptionList;
		}

		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(new InputSource(new StringReader(rawXmlResponse)));

			NodeList itemListNodes = document.getElementsByTagName("item");

			for (int i = 0; i < itemListNodes.getLength(); i++) {
				Node itemListNode = itemListNodes.item(i);

				if (itemListNode.getNodeType() == Node.ELEMENT_NODE) {
					Element itemElement = (Element) itemListNode;

					DrugDTO drug = new DrugDTO();
					drug.setCpntCd(getElementValue(itemElement, "CPNT_CD"));
					drug.setDrugCpntKorNm(getElementValue(itemElement, "DRUG_CPNT_KOR_NM"));
					drug.setFomlNm(getElementValue(itemElement, "FOML_NM"));
					drug.setDosageRouteCode(getElementValue(itemElement, "DOSAGE_ROUTE_CODE"));
					drug.setDayMaxDosgQyUnit(getElementValue(itemElement, "DAY_MAX_DOSG_QY_UNIT"));
					drug.setDayMaxDosgQy(getElementValue(itemElement, "DAY_MAX_DOSG_QY"));

					prescriptionList.add(drug);
				}
			}

		} catch (Exception e) {
			System.err.println("Error parsing XML 파싱 실패: " + e.getMessage());
			e.printStackTrace();
			return List.of();
		}

		return prescriptionList;
	}

	// XML 요소의 값 가져오기
	private String getElementValue(Element element, String tagName) {
		NodeList nodeList = element.getElementsByTagName(tagName);
		if (nodeList.getLength() > 0) {
			Node node = nodeList.item(0);
			return node.getTextContent();
		}
		return null;
	}

	//약물 처방 저장 메소드
	public void saveDrugs(DrugDTO drugDTO) {
		//DTO를 Entity로 변환한 후 데이터베이스에 저장
		DrugEntity drugEntity = new DrugEntity();
		drugEntity.setCpntCd(drugDTO.getCpntCd());
		drugEntity.setDrugCpntKorNm(drugDTO.getDrugCpntKorNm());
		drugEntity.setDayMaxDosgQy(drugDTO.getDayMaxDosgQy());
		drugEntity.setDayMaxDosgQyUnit(drugDTO.getDayMaxDosgQyUnit());
		drugEntity.setDosageRouteCode(drugDTO.getDosageRouteCode());
		drugEntity.setFomlNm(drugDTO.getFomlNm());

	}
	//--------------------------외래키 테이블 생성하면 활성화 ----------------------------------------------
	// DTO를 엔티티로 변환하는 메서드 
	/*
	 * public DrugEntity convertDtoToEntity(DrugDTO drugDTO, MedicalRecord
	 * medicalRecord) { DrugEntity drugEntity = new DrugEntity();
	 * 
	 * drugEntity.setCpntCd(drugDTO.getCpntCd());
	 * drugEntity.setDrugCpntKorNm(drugDTO.getDrugCpntKorNm());
	 * drugEntity.setFomlNm(drugDTO.getFomlNm());
	 * drugEntity.setDosageRouteCode(drugDTO.getDosageRouteCode());
	 * drugEntity.setDayMaxDosgQyUnit(drugDTO.getDayMaxDosgQyUnit());
	 * drugEntity.setDayMaxDosgQy(new BigDecimal(drugDTO.getDayMaxDosgQy()));
	 * 
	 * drugEntity.setMedicalRecord(medicalRecord);
	 * 
	 * return drugEntity; }
	 */

	// 약물 처방 저장 메서드
	/*
	 * public void saveDrug(DrugDTO drugDTO, MedicalRecord medicalRecord) {
	 * DrugEntity drugEntity = convertDtoToEntity(drugDTO, medicalRecord);
	 * drugRepository.save(drugEntity); }
	 */
}
