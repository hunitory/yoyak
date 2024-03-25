package com.yoyak.yoyak.medicine.service;

import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicine.domain.MedicineRepository;
import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.dto.MedicineSearchParametersDto;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineService {

    private final MedicineRepository medicineRepository;

    public MedicineDto findMedicine(Long seq) {
        Medicine medicine = medicineRepository.findBySeq(seq)
            .orElseThrow(() -> new IllegalArgumentException("해당 약이 없습니다. seq=" + seq));
        return new MedicineDto(medicine.getSeq(), medicine.getImgPath(), medicine.getItemName(),
            medicine.getEntpName());
    }

    public List<MedicineDto> findMedicineByParameters(MedicineSearchParametersDto parameters) {
        log.info("param={}", parameters.getFormCodeName());
        return medicineRepository.findByParameters(
            parameters.getSearchName(),
            parameters.getDrugShape(),
            parameters.getColorClass(),
            parameters.getFormCodeName(),
            parameters.getLine());
    }
}
