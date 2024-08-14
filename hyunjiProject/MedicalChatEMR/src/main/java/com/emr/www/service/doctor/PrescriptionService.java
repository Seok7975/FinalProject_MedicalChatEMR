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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.emr.www.entity.doctor.PrescriptionEntity;
import com.emr.www.entity.doctor.dto.PrescriptionDTO;

@Service
public class PrescriptionService {

	@Value("${api.key}")
	private String apiKey;

	@Value("${api.prescription.url}")
	private String apiBaseUrl;

	// 검색 결과를 반환하는 메서드
	public List<PrescriptionDTO> searchPrescriptions(String query) {
		List<PrescriptionDTO> uniquePrescriptions = new ArrayList<>();

		int pageNo = 1;
		int numOfRows = 100; // 페이지당 결과 수를 원하는 대로 조정
		String type = "xml";
		boolean morePages = true;

		   while (morePages) {
		        String xmlResponse = callPrescriptionDirectly(query, pageNo, numOfRows, type);
		        List<PrescriptionDTO> prescriptions = parseXmlToPrescriptionList(xmlResponse, query);
		        if (prescriptions.isEmpty()) {
		            morePages = false;
		        } else {
		            uniquePrescriptions.addAll(prescriptions);
		            pageNo++;
		        }
		    }

		    return uniquePrescriptions;
	}

	//약품 API 호출 메서드
	private String callPrescriptionDirectly(String query, int pageNo, int numOfRows, String type) {
		StringBuilder result = new StringBuilder();
		String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8);
		String apiUrl = String.format("%s?serviceKey=%s&itemName=%s&pageNo=%s&numOfRows=%s&type=%s", apiBaseUrl, apiKey, encodedQuery, pageNo,
				numOfRows, type);

		try {
			URL url = new URL(apiUrl);
			HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
			urlConnection.setRequestMethod("GET");
			try (BufferedReader br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), "UTF-8"))) {
				String line;
				while ((line = br.readLine()) != null) {
					result.append(line).append("\n");
				}
			}
		} catch (Exception e) {
			System.out.println("Error during API call" + e.getMessage());
		}
		return result.toString();
	}

	//XML 응답을  DTO 목록으로 변환
	private List<PrescriptionDTO> parseXmlToPrescriptionList(String rawXmlResponse, String query) {
		List<PrescriptionDTO> prescriptionList = new ArrayList<>();

		if (rawXmlResponse == null || rawXmlResponse.trim().isEmpty()) {
			return prescriptionList;
		}

		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(new InputSource(new StringReader(rawXmlResponse)));

			NodeList items = document.getElementsByTagName("item");

			for (int i = 0; i < items.getLength(); i++) {
				Node item = items.item(i);
				if (item.getNodeType() == Node.ELEMENT_NODE) {
					Element element = (Element) item;

					 String itemName = getElementValue(element, "itemName");

		                // 검색어가 포함된 항목만 필터링
		                if (itemName != null && itemName.contains(query)) {
		                    PrescriptionDTO prescription = new PrescriptionDTO();
		                    prescription.setEntpName(getElementValue(element, "entpName"));
		                    prescription.setItemSeq(getElementValue(element, "itemSeq"));
		                    prescription.setItemName(itemName);
		                    prescription.setUseMethodQesitm(getElementValue(element, "useMethodQesitm"));

		                    prescriptionList.add(prescription);
		                }
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
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

	//처방전에 등록된 데이터 저장
	public void savePrescription(PrescriptionDTO prescriptionDTO) {
		//DTO를 Entity로 변환한 후 데이터베이스에 저장
		PrescriptionEntity prescriptionEntity = new PrescriptionEntity();

		prescriptionEntity.setEntpName(prescriptionDTO.getEntpName());
		prescriptionEntity.setItemName(prescriptionDTO.getItemName());
		prescriptionEntity.setItemSeq(prescriptionDTO.getItemSeq());
		prescriptionEntity.setUseMethodQesitm(prescriptionDTO.getUseMethodQesitm());

		// 예: prescriptionRepository.save(prescriptionEntity); > dao에 저장

	}
}
