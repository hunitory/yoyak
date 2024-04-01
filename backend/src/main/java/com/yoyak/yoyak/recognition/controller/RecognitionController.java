package com.yoyak.yoyak.recognition.controller;


import com.fasterxml.jackson.databind.JsonNode;
import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.service.MedicineService;
import com.yoyak.yoyak.python.service.PythonService;
import com.yoyak.yoyak.recognition.dto.RecognitionResponseDto;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 이미지에서 약을 인식해서 약의 기본 정보를 리턴해주는 컨트롤러
 */
@RestController
@Slf4j
@RequestMapping("/api/recognition")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = "*")
public class RecognitionController {

    @Value("${fastapi.url}")
    private String fastApiUrl;


    private final MedicineService medicineService;
    private final PythonService pythonService;

    @GetMapping("/test")
    public ResponseEntity<Object> test() {
        return ResponseEntity.ok("TEST Success");
    }

    @PostMapping("/upload")
    public ResponseEntity<Object> recognition(@RequestParam("image") MultipartFile file) {
        log.info("file = {}", file.getOriginalFilename());
        try {
            byte[] fileBytes = file.getBytes();
            ByteArrayResource fileResource = new ByteArrayResource(fileBytes) {
                @Override
                public String getFilename() {
                    return file.getOriginalFilename();
                }
            };


            JsonNode jsonNode = pythonService.getRecognitionResponse(fileResource);

            int count = jsonNode.get("count").asInt();

            JsonNode medicineList = jsonNode.get("medicineList");
            log.info("medicineList = {}", medicineList.size());
            if(medicineList.size() == 0){
                throw new CustomException(CustomExceptionStatus.MEDICINE_NO_RECOGNITION);
            }
            List<MedicineDto> medicineDtos = new ArrayList<>();
            for (JsonNode medicine : medicineList) {
                Long medicineCode = medicine.get("medicineCode").asLong();
                String medicineName = medicine.get("medicineName").asText();
                try {
                    MedicineDto dto = medicineService.findMedicine(medicineCode);
                    medicineDtos.add(dto);
                } catch (IllegalArgumentException e) {
                    MedicineDto dto = MedicineDto.builder().medicineSeq(medicineCode)
                        .itemName(medicineName).build();
                    medicineDtos.add(dto);
                }
            }

            RecognitionResponseDto responseDto = RecognitionResponseDto.builder()
                .count(count)
                .medicineList(medicineDtos)
                .build();

            return ResponseEntity.ok().body(responseDto);

        } catch (IOException e) {

            return ResponseEntity.internalServerError().body(e.getMessage());
        }catch (CustomException e){
            StatusResponseDto statusResponseDto = StatusResponseDto.builder()
                .code(e.getStatus().getCode())
                .message(e.getStatus().getMessage())
                .build();
            return ResponseEntity.badRequest().body(statusResponseDto);
        }
    }

}
