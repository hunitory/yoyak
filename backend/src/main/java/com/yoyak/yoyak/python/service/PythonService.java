package com.yoyak.yoyak.python.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import com.yoyak.yoyak.medicineDetail.dto.SummaryRequestDto;
import java.io.IOException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class PythonService {

    @Value("${fastapi.url}")
    private String fastApiUrl;

    public String getSummary(MedicineDetail medicineDetail) {
        SummaryRequestDto summaryRequestDto = SummaryRequestDto.builder()
            .itemName(medicineDetail.getMedicine().getItemName())
            .atpn(medicineDetail.getAtpn())
            .efficacy(medicineDetail.getEfficacy())
            .useMethod(medicineDetail.getUseMethod())
            .depositMethod(medicineDetail.getDepositMethod())
            .sideEffect(medicineDetail.getSideEffect())
            .build();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json");
        String url = fastApiUrl + "/python/summary";

        HttpEntity<SummaryRequestDto> request = new HttpEntity<>(summaryRequestDto, headers);
        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.postForObject(url, request, String.class);

        ObjectMapper objectMapper = new ObjectMapper();

        try {
            JsonNode jsonNode = objectMapper.readTree(response);
            return jsonNode.get("summary").asText();

        } catch (IOException e) {
            return "요약정보를 제공하지 못했습니다";
        }

    }

    public JsonNode getRecognitionResponse(ByteArrayResource fileResource) throws IOException {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("image", fileResource);

        String url = fastApiUrl + "/python/upload";

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.postForObject(url, requestEntity, String.class);

        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readTree(response);

    }
}
