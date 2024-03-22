package com.yoyak.yoyak.medicineDetail.service;

import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetailRepository;
import com.yoyak.yoyak.medicineDetail.dto.MedicineDetailDto;
import com.yoyak.yoyak.python.service.PythonService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineDetailService {

    private final MedicineDetailRepository medicineDetailRepository;
    private final PythonService pythonService;

    public MedicineDetailDto findMedicineDetail(Long itemSeq) {

        MedicineDetail medicineDetail = medicineDetailRepository.findBySeq(itemSeq)
            .orElseThrow(() -> new RuntimeException("MedicineDetail not found: " + itemSeq));

        log.info("medicineDetail ={}", medicineDetail.getMedicine().getImgPath());

        String summary = pythonService.getSummary(medicineDetail);

        return MedicineDetailDto.builder()
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
    }
}
