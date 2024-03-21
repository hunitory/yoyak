package com.yoyak.yoyak.recognition.controller;


import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.service.MedicineService;
import com.yoyak.yoyak.recognition.dto.RecognitionResponseDto;
import com.yoyak.yoyak.util.exception.CustomException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

/**
 * 이미지에서 약을 인식해서 약의 기본 정보를 리턴해주는 컨트롤러
 */
@RestController
@Slf4j
@RequestMapping("/api/recognition")
@RequiredArgsConstructor
public class RecognitionController {

    @Value("${fastapi.url}")
    private String fastApiUrl;


    private final MedicineService medicineService;

    @GetMapping("/test")
    public ResponseEntity<Object> test() {
        return ResponseEntity.ok("TEST Success");
    }
    @PostMapping("/upload")
    public ResponseEntity<Object> uploadImage(@RequestParam("image") MultipartFile file) {
        log.info("file = {}", file.getOriginalFilename());
        try{
            byte[] fileBytes = file.getBytes();
            ByteArrayResource fileResource = new ByteArrayResource(fileBytes){
                @Override
                public String getFilename(){
                    return file.getOriginalFilename();
                }
            };

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("image", fileResource);

            String url = fastApiUrl + "/python/upload";

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
            RestTemplate restTemplate = new RestTemplate();
            String response = restTemplate.postForObject(url, requestEntity, String.class);

            log.info("response = {}", response);

            ObjectMapper objectMapper = new ObjectMapper();

            JsonNode jsonNode = objectMapper.readTree(response);

            int count = jsonNode.get("count").asInt();

            JsonNode medicineList = jsonNode.get("medicineList");
            log.info("medicineList = {}", medicineList.size());
            List<MedicineDto> medicineDtos = new ArrayList<>();
            for(JsonNode medicine : medicineList){
                Long medicineCode = medicine.get("medicineCode").asLong();
                String medicineName = medicine.get("medicineName").asText();
                try{
                    MedicineDto dto = medicineService.findMedicine(medicineCode);
                    medicineDtos.add(dto);
                }catch(IllegalArgumentException e){
                    MedicineDto dto = MedicineDto.builder().medicineSeq(medicineCode).itemName(medicineName).build();
                    medicineDtos.add(dto);
                }

            }

            RecognitionResponseDto responseDto = RecognitionResponseDto.builder()
                .count(count)
                .medicineList(medicineDtos)
                .build();


            return ResponseEntity.ok().body(responseDto);

        }catch(CustomException | IOException e){

            return ResponseEntity.internalServerError().body(e.getMessage());
        }
    }

}
