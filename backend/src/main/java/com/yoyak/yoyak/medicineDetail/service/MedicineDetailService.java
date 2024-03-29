package com.yoyak.yoyak.medicineDetail.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.MEDICINE_NOT_EXIST;

import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetailRepository;
import com.yoyak.yoyak.medicineDetail.dto.MedicineDetailDto;
import com.yoyak.yoyak.python.service.PythonService;
import com.yoyak.yoyak.util.exception.CustomException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineDetailService {

    private final MedicineDetailRepository medicineDetailRepository;
    private final PythonService pythonService;

    @Value("${cloud.aws.s3.prefix}")
    private String s3Prefix;

    /**
     * 주어진 seq를 통해 약의 상세 정보를 조회하고, 그 정보를 반환
     *
     * @param itemSeq
     * @return MedicineDetailDto
     */
    public MedicineDetailDto findMedicineDetail(Long itemSeq) {

        MedicineDetail medicineDetail = medicineDetailRepository.findBySeq(itemSeq)
            .orElseThrow(() -> new CustomException(MEDICINE_NOT_EXIST));

        log.info("medicineDetail ={}", medicineDetail.getMedicine().getImgPath());

        String summary = pythonService.getSummary(medicineDetail);
        String keyword = mapKeywords(medicineDetail.getAtpnWarn() + medicineDetail.getAtpn());

        MedicineDetailDto build = MedicineDetailDto.builder()
            .medicineSeq(medicineDetail.getSeq())
            .itemName(medicineDetail.getMedicine().getItemName())
            .entpName(medicineDetail.getMedicine().getEntpName())
            .imagePath(s3Prefix + medicineDetail.getMedicine().getImgPath())
            .efficacy(medicineDetail.getEfficacy())
            .useMethod(medicineDetail.getUseMethod())
            .depositMethod(medicineDetail.getDepositMethod())
            .atpnWarn(medicineDetail.getAtpnWarn())
            .atpn(medicineDetail.getAtpn())
            .sideEffect(medicineDetail.getSideEffect())
            .summary(summary)
            .keyword(keyword)
            .build();

        log.info("result={}", build);

        return build;
    }

    private String mapKeywords(String text) {
        Map<String, String[]> keywordMap = new HashMap<>();
        keywordMap.put("임산부", new String[]{"임부", "임신하고", "임신", "임산부"});
        keywordMap.put("아이", new String[]{"소아", "유아", "어린이", "미숙아", "영아", "젖먹이", "갓난아기", "신생아"});
        keywordMap.put("고령자", new String[]{"고령자", "노인"});
        keywordMap.put("졸음", new String[]{"졸음"});
        keywordMap.put("어지러움", new String[]{"어지러움", "현기증"});

        // 매칭된 키워드 찾기를 스트림으로 처리
        String matchedKeywords = keywordMap.entrySet().stream()
            .filter(entry -> Arrays.stream(entry.getValue()).anyMatch(text::contains))
            .map(Map.Entry::getKey)
            .collect(Collectors.joining(", "));

        return matchedKeywords.isEmpty() ? null : matchedKeywords + " 주의";
    }
}
