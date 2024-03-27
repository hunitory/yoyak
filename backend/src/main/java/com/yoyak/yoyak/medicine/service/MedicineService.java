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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineService {

    private final MedicineRepository medicineRepository;

    @Value("${cloud.aws.s3.prefix}")
    private String s3Prefix;

    /**
     * 주어진 고유 번호(seq)를 사용하여 약을 조회하고, 조회된 약의 정보를 반환
     *
     * @param seq
     * @return MedicineDto
     */
    public MedicineDto findMedicine(Long seq) {
        Medicine medicine = medicineRepository.findBySeq(seq)
            .orElseThrow(() -> new CustomException(MEDICINE_NOT_EXIST));
        return new MedicineDto(medicine.getSeq(), s3Prefix + medicine.getImgPath(),
            medicine.getItemName(),
            medicine.getEntpName());
    }

    /**
     * 사용자가 제공한 파라미터를 기반으로 약 목록을 검색하고 결과를 반환하는 메소드
     *
     * @param parameters
     * @return List<MedicineDto>
     */
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

        // s3주소 넣어주기
        result.stream()
            .forEach(dto -> dto.setImgPath(s3Prefix + dto.getImgPath()));

        return result;
    }
}
