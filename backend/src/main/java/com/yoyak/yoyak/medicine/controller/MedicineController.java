package com.yoyak.yoyak.medicine.controller;

import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.dto.MedicineSearchParametersDto;
import com.yoyak.yoyak.medicine.service.MedicineService;
import com.yoyak.yoyak.util.dto.BasicResponseDto;
import com.yoyak.yoyak.util.elasticsearch.SearchParameters;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/medicine")
@RequiredArgsConstructor
@Slf4j
public class MedicineController {

    private final MedicineService medicineService;

    /**
     * 사용자로부터 받은 파라미터를 사용하여 약을 검색하고, 결과를 반환하는 메소드
     *
     * @param parameters
     * @return ResponseEntity<BasicResponseDto>
     */
    @GetMapping("/filter")
    public ResponseEntity<BasicResponseDto> medicineList(
        @ModelAttribute MedicineSearchParametersDto parameters) {

        log.info("[{}.{}] parmeters = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), parameters);

        List<MedicineDto> medicineList = medicineService.findMedicineByParameters(parameters);

        log.info("[{}.{}] medicineList = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), medicineList);

        return ResponseEntity
            .status(HttpStatus.OK)
            .body(BasicResponseDto.builder()
                .count(medicineList.size())
                .result(medicineList)
                .build());
    }

    @GetMapping("/full-text")
    public ResponseEntity<BasicResponseDto> productList(
        @RequestParam(name = "keyword") String keyword,
        @RequestParam(name = "page", defaultValue = "1") int page
    ) {

        log.info("[{}.{}] parmeters = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(),
            "keyword: " + keyword + " page: " + page);

        List<MedicineDto> medicineDtoList =
            medicineService.findMedicineByFullText(
                SearchParameters.createMedicineSearchParameters(page, keyword));

        log.info("[{}.{}] medicineList = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), medicineDtoList);

        return ResponseEntity.status(HttpStatus.OK)
            .body(BasicResponseDto.builder()
                .count(medicineDtoList.size())
                .result(medicineDtoList)
                .build());
    }

    @GetMapping("/search-keyword")
    public ResponseEntity<BasicResponseDto> findkeyword(
        @RequestParam(name = "keyword") String keyword) {

        log.info("[{}.{}] parmeters = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(),
            "keyword: " + keyword);

        List<MedicineDto> medicineDtoList = medicineService.findMedicineByKeyword(keyword);
        return ResponseEntity.status(HttpStatus.OK)
            .body(BasicResponseDto.builder()
                .count(medicineDtoList.size())
                .result(medicineDtoList)
                .build());
    }
}
