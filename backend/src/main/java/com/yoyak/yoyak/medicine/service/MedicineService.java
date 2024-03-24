package com.yoyak.yoyak.medicine.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.MEDICINE_NOT_EXIST;

import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicine.domain.MedicineRepository;
import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.dto.MedicineSearchParametersDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
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
            .orElseThrow(() -> new CustomException(MEDICINE_NOT_EXIST));
        return new MedicineDto(medicine.getSeq(), medicine.getImgPath(), medicine.getItemName(),
            medicine.getEntpName());
    }

    public List<MedicineDto> findMedicineByParameters(MedicineSearchParametersDto parameters) {
        log.info("param={}", parameters.getFormCodeName());

        List<MedicineDto> result = medicineRepository.findByParameters(
            parameters.getSearchName(),
            parameters.getDrugShape(),
            parameters.getColorClass(),
            parameters.getFormCodeName(),
            parameters.getLine());

        if (result.isEmpty()) {
            throw new CustomException(CustomExceptionStatus.MEDICINE_NOT_FOUND);
        }

        return medicineRepository.findByParameters(
            parameters.getSearchName(),
            parameters.getDrugShape(),
            parameters.getColorClass(),
            parameters.getFormCodeName(),
            parameters.getLine());
    }
}
