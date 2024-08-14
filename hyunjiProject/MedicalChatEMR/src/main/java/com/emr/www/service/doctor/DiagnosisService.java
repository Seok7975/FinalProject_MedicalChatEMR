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

import com.emr.www.entity.doctor.dto.DiagnosisDTO;
import com.emr.www.repository.doctor.DiagnosisRepository;

@Service
public class DiagnosisService {

    private final DiagnosisRepository diagnosisRepository;

    @Value("${api.key}")
    private String apiKey;

    @Value("${api.diagnosis.url}")
    private String apiBaseUrl;

    @Autowired
    public DiagnosisService(DiagnosisRepository diagnosisRepository) {
        this.diagnosisRepository = diagnosisRepository;
    }

    // 검색된 질병명을 기준으로 데이터 가져오기
    public List<DiagnosisDTO> searchDiagnosis(String query) {
        List<DiagnosisDTO> uniqueDiagnosis = new ArrayList<>();
        int pageNo = 1;
        int numOfRows = 100; // 최대 크기로 설정
        boolean morePages = true;

        while (morePages) {
            String rawXmlResponse = callDiagnosisDirectly(query, numOfRows, pageNo);
            List<DiagnosisDTO> diagnosisDTOs = parseXmlToDiagnosisList(rawXmlResponse, query); // query를 전달하여 필터링 수행
            if (diagnosisDTOs.isEmpty()) {
                morePages = false;
            } else {
                uniqueDiagnosis.addAll(diagnosisDTOs);
                pageNo++;
            }
        }

        return uniqueDiagnosis;
    }

    // 진단 API 호출 메서드
    private String callDiagnosisDirectly(String query, int numOfRows, int pageNo) {
        StringBuilder result = new StringBuilder();
        String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8);
        String apiUrl = String.format("%s?serviceKey=%s&numOfRows=%d&pageNo=%d&type=%s&DISEASE_NAME=%s", apiBaseUrl, apiKey, numOfRows, // numOfRows
                pageNo, // pageNo
                "xml", // type
                encodedQuery);
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
            e.printStackTrace();
            System.err.println("Error during API call: " + e.getMessage());
        }
        return result.toString();
    }

    // XML 응답을 DTO 목록으로 변환 (중복 제거 포함)
    private List<DiagnosisDTO> parseXmlToDiagnosisList(String rawXmlResponse, String query) {
        List<DiagnosisDTO> diagnosisList = new ArrayList<>();
        Set<String> seenDiagnosisNames = new HashSet<>();

        if (rawXmlResponse == null || rawXmlResponse.trim().isEmpty()) {
            return diagnosisList;
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

                    String diseaseName = getElementValue(itemElement, "DISEASE_NAME");
                    if (diseaseName != null && diseaseName.contains(query) && seenDiagnosisNames.add(diseaseName)) {
                        // 중복이 아니고 query를 포함하는 항목만 추가
                        DiagnosisDTO diagnosis = new DiagnosisDTO();
                        diagnosis.setDisease_code(getElementValue(itemElement, "DISEASE_CODE"));
                        diagnosis.setDisease_name(diseaseName);

                        diagnosisList.add(diagnosis);
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("Error parsing XML: " + e.getMessage());
            e.printStackTrace();
            return List.of();
        }

        return diagnosisList;
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

}
