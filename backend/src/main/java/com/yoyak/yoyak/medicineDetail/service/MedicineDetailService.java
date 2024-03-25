package com.yoyak.yoyak.medicineDetail.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.MEDICINE_NOT_EXIST;

import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetailRepository;
import com.yoyak.yoyak.medicineDetail.dto.MedicineDetailDto;
import com.yoyak.yoyak.python.service.PythonService;
import com.yoyak.yoyak.util.exception.CustomException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineDetailService {

    private final MedicineDetailRepository medicineDetailRepository;
    private final PythonService pythonService;

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

        MedicineDetailDto build = MedicineDetailDto.builder()
            .medicineSeq(medicineDetail.getSeq())
            .itemName(medicineDetail.getMedicine().getItemName())
            .entpName(medicineDetail.getMedicine().getEntpName())
            .imagePath(medicineDetail.getMedicine().getImgPath())
            .useMethod(medicineDetail.getUseMethod())
            .depositMethod(medicineDetail.getDepositMethod())
            .atpnWarn(medicineDetail.getAtpnWarn())
            .atpn(medicineDetail.getAtpn())
            .sideEffect(medicineDetail.getSideEffect())
            .summary(summary)
            .build();

        log.info("result={}", build);

        return build;
    }
}
