package com.yoyak.yoyak.python.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import com.yoyak.yoyak.medicineDetail.dto.SummaryRequestDto;
import java.io.IOException;
import lombok.extern.slf4j.Slf4j;
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
@Slf4j
public class PythonService {

    @Value("${fastapi.url}")
    private String fastApiUrl;


    public JsonNode getRecognitionResponse(ByteArrayResource fileResource) throws IOException {
        log.info("fastapiUrl = {}", fastApiUrl);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("image", fileResource);

        String url = fastApiUrl + "/python/upload";

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        RestTemplate restTemplate = new RestTemplate();

        String response = restTemplate.postForObject(url, requestEntity, String.class);

        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode node = objectMapper.readTree(response);
        log.info("node = {}", node);

        return node;

    }
}
