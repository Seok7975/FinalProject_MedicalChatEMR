package com.emr.www.service.doctor;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

public abstract class AbstractApiService<T> {

	protected final String apiKey;
	protected final String apiBaseUrl;

	public AbstractApiService(String apiKey, String apiBaseUrl) {
		this.apiKey = apiKey;
		this.apiBaseUrl = apiBaseUrl;
	}
	
	//검색 요청 처리 및 결과 리스트 반환
	public List<T> search(String query, Map<String, String> additionalParams) {
		List<T> results = new ArrayList<>();
		 Set<String> seenItems = new HashSet<>();  // 중복된 항목을 추적할 Set
		 
		int pageNo = 1;
		int numOfRows = 80;
		boolean morePages = true;

		// 기본 페이지 번호와 행 수 설정
		additionalParams.putIfAbsent("pageNo", String.valueOf(pageNo));
		additionalParams.putIfAbsent("numOfRows", String.valueOf(numOfRows));

		while (morePages) {
			
			// 각 서비스가 오버라이드한 createApiUrl 호출
			
			String apiUrl = createApiUrl(query, additionalParams);
			// API 호출
			String rawXmlResponse = callApiDirectly(apiUrl);
			
			// XML 응답을 리스트로 변환 + 중복 체크
			 List<T> items = parseXmlToList(rawXmlResponse, query, seenItems); 

			// API 응답이 비어 있거나 데이터가 더 이상 없을 경우 반복 종료
			if (items.isEmpty() || rawXmlResponse.contains("<totalCount>0</totalCount>")) {
				morePages = false;
			} else {
				results.addAll(items);
				additionalParams.put("pageNo", String.valueOf(++pageNo)); // 페이지 번호 증가
			}
		}
		return results;
	}

	// XML 응답을 리스트로 변환
	protected List<T> parseXmlToList(String rawXmlResponse, String query, Set<String> seenItems) {
		List<T> itemList = new ArrayList<>();
		
		if (rawXmlResponse == null || rawXmlResponse.trim().isEmpty()) {
			return itemList;
		}

		try {
			// XML 파싱을 위한 설정
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document document = builder.parse(new InputSource(new StringReader(rawXmlResponse)));

			// item 태그를 가진 노드들을 가져옴
			NodeList itemListNodes = document.getElementsByTagName("item");

			// 각 item 노드를 순회하면서 데이터를 추출
			for (int i = 0; i < itemListNodes.getLength(); i++) {
				Node itemListNode = itemListNodes.item(i);

				if (itemListNode.getNodeType() == Node.ELEMENT_NODE) {
					Element itemElement = (Element) itemListNode;
					
					// 태그 값 가져오기 및 검색어와 비교
					String tagValue = getElementValue(itemElement, getComparisonTagName());
					
					 // 중복되지 않는 값만 리스트에 추가
                    if (tagValue != null && tagValue.contains(query) && seenItems.add(tagValue)) {
                        T item = parseElementToItem(itemElement, query);
                        if (item != null) {
                            itemList.add(item);
                        }
                    }
				}
			}
		} catch (Exception e) {
			System.err.println("Error parsing XML: " + e.getMessage());
			e.printStackTrace();
		}

		return itemList;
	}

	 // API 호출 메서드
    private String callApiDirectly(String apiUrl) {
        StringBuilder result = new StringBuilder();
        try {
        	URI uri = URI.create(apiUrl);
        	URL url = uri.toURL();
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.setRequestMethod("GET");

            try (BufferedReader br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    result.append(line).append("\n");
                }
            }
        } catch (Exception e) {
            System.err.println("Error during API call: " + e.getMessage());
            e.printStackTrace();
        }
        return result.toString();
    }

	// 추상 메서드, 각 서비스에서 구현
	protected abstract String createApiUrl(String query, Map<String, String> parameters);
	
	//xml 응답을 dto 목록으로 변환
	protected abstract T parseElementToItem(Element element, String query);

	//해당 태그의 데이터로 중복 체크
	protected abstract String getComparisonTagName();

	 // XML 태그 값 가져오기
	protected String getElementValue(Element element, String tagName) {
		NodeList nodeList = element.getElementsByTagName(tagName);
		if (nodeList.getLength() > 0) {
			Node node = nodeList.item(0);
			return node.getTextContent();
		}
		return null;
	}

	// 공통 URL 빌드 메서드
	protected String buildBaseApiUrl(Map<String, String> parameters) {
		StringBuilder urlBuilder = new StringBuilder(apiBaseUrl);
		urlBuilder.append("?serviceKey=").append(apiKey);

		parameters.forEach((key, value) -> {
			urlBuilder.append("&").append(key).append("=").append(encodeURIComponent(value));
		});

		return urlBuilder.toString();
	}

	// 유틸리티 함수: URL 인코딩
	private String encodeURIComponent(String value) {
		try {
			return URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e.getMessage(), e);
		}
	}
}