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

import com.emr.www.entity.doctor.dto.DrugDTO;
import com.emr.www.repository.doctor.DrugRepository;

@Service
public class DrugService {

    private final DrugRepository prescriptionRepository;

    @Value("${api.key}")
    private String apiKey;
    
    @Value("${api.drug.url}")
    private String apiBaseUrl;

    @Autowired
    public DrugService(DrugRepository prescriptionRepository) {
        this.prescriptionRepository = prescriptionRepository;
    }

    public String callApiDirectly(String query, int numOfRows, int pageNo) {
        StringBuilder result = new StringBuilder();
        String encodedQuery = URLEncoder.encode(query, StandardCharsets.UTF_8);
        String apiUrl = String.format("%s?serviceKey=%s&numOfRows=%d&pageNo=%d&type=%s&DRUG_CPNT_KOR_NM=%s",
                apiBaseUrl,
                apiKey,
                numOfRows, // numOfRows
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

    public List<DrugDTO> searchPrescriptions(String query) {
        Set<String> seenDrugNames = new HashSet<>();  // 중복을 확인하기 위한 Set
        List<DrugDTO> uniquePrescriptions = new ArrayList<>();
        int pageNo = 1;
        int numOfRows = 100; // 최대 크기로 설정
        boolean morePages = true;

        while (morePages) {
            String rawXmlResponse = callApiDirectly(query, numOfRows, pageNo);
            List<DrugDTO> prescriptions = parseXmlToPrescriptionList(rawXmlResponse);
            if (prescriptions.isEmpty()) {
                morePages = false;
            } else {
                for (DrugDTO prescription : prescriptions) {
                    if (seenDrugNames.add(prescription.getDrugCpntKorNm())) {  // 새로운 약품명일 경우에만 추가
                        uniquePrescriptions.add(prescription);
                    }
                }
                pageNo++;
            }
        }
        
        return uniquePrescriptions;
    }

    private List<DrugDTO> parseXmlToPrescriptionList(String rawXmlResponse) {
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

                    DrugDTO prescription = new DrugDTO();
                    prescription.setCpntCd(getElementValue(itemElement, "CPNT_CD"));
                    prescription.setDrugCpntKorNm(getElementValue(itemElement, "DRUG_CPNT_KOR_NM"));
                    prescription.setFomlNm(getElementValue(itemElement, "FOML_NM"));
                    prescription.setDosageRouteCode(getElementValue(itemElement, "DOSAGE_ROUTE_CODE"));
                    prescription.setDayMaxDosgQyUnit(getElementValue(itemElement, "DAY_MAX_DOSG_QY_UNIT"));
                    prescription.setDayMaxDosgQy(getElementValue(itemElement, "DAY_MAX_DOSG_QY"));

                    prescriptionList.add(prescription);
                }
            }

        } catch (Exception e) {
            System.err.println("Error parsing XML 파싱 실패: " + e.getMessage());
            e.printStackTrace();
            return List.of(); 
        }

        return prescriptionList;
    }

    private String getElementValue(Element element, String tagName) {
        NodeList nodeList = element.getElementsByTagName(tagName);
        if (nodeList.getLength() > 0) {
            Node node = nodeList.item(0);
            return node.getTextContent();
        }
        return null;
    }
}
