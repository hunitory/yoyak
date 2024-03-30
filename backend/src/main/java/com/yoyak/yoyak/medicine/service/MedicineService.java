package com.yoyak.yoyak.medicine.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.MEDICINE_NOT_EXIST;

import co.elastic.clients.elasticsearch.core.search.Hit;
import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicine.domain.MedicineRepository;
import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.dto.MedicineFullTextDto;
import com.yoyak.yoyak.medicine.dto.MedicineSearchParametersDto;
import com.yoyak.yoyak.util.elasticsearch.ElasticsearchService;
import com.yoyak.yoyak.util.elasticsearch.SearchParameters;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.exception.CustomExceptionStatus;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@Slf4j
public class MedicineService {

    private final MedicineRepository medicineRepository;
    private final ElasticsearchService elasticsearchService;
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
     * 사용자가 제공한 파라미터에 따라 약 목록을 검색하고 결과를 반환합니다
     *
     * @param parameters 검색에 사용될 파라미터를 담고 있는 MedicineSearchParametersDto 객체
     * @return 검색된 약 목록을 담고 있는 List<MedicineDto>
     * @throws CustomException MEDICINE_NOT_FOUND 예외를 검색 결과가 비어 있을 때 발생
     */
    public List<MedicineDto> findMedicineByParameters(MedicineSearchParametersDto parameters) {
        log.info("param={}", parameters.getFormCodeName());

        List<MedicineDto> result = medicineRepository.findByParameters(
            parameters.getSearchName(),
            parameters.getDrugShape(),
            parameters.getColorClass(),
            parameters.getFormCodeName(),
            parameters.getLine());
        log.info("searchName={}", parameters.getSearchName());

        if (result.isEmpty()) {
            throw new CustomException(CustomExceptionStatus.MEDICINE_NOT_FOUND);
        }

        // s3주소 넣어주기
        result.stream()
            .forEach(dto -> dto.setImgPath(s3Prefix + dto.getImgPath()));

        return result;
    }

    /**
     * 사용자가 제공한 검색 파라미터를 기반으로 엘라스틱서치를 사용하여 약에 대한 전체 텍스트 검색을 수행
     *
     * @param params 사용자로부터 받은 검색 파라미터를 담고 있는 SearchParameters 객체
     * @return 검색 결과에 해당하는 MedicineDto 객체의 리스트. 결과가 없거나 오류가 발생한 경우 빈 리스트 반환.
     */
    public List<MedicineDto> findMedicineByFullText(SearchParameters params) {
        List<MedicineDto> resultList = new ArrayList<>();
        try {
            List<Hit<MedicineFullTextDto>> hits =
                elasticsearchService.regexFullTextSearch(params).hits().hits();

            resultList = hits.stream()
                .map(this::mapToMedicineDto)
                .collect(Collectors.toList());
        } catch (IOException e) {
            log.error("Error executing full text search", e);
        }

        return resultList;
    }

    /**
     * 사용자가 제공한 검색 파라미터를 기반으로 sql에서 약에 대한 전체 텍스트 검색을 수행
     *
     * @param keyword 사용자로부터 받은 검색값
     * @return 검색 결과에 해당하는 MedicineDto 객체의 리스트. 결과가 없거나 오류가 발생한 경우 빈 리스트 반환.
     */
    @Deprecated
    public List<MedicineDto> findMedicineByKeyword(String keyword) {
        return medicineRepository.findByKeyword(keyword);
    }

    /**
     * 엘라스틱서치의 검색 결과인 Hit<MedicineFullTextDto> 객체를 받아, 이를 사용자에게 반환할 MedicineDto 객체로 변환합니다. 변환 과정에서,
     *
     * @param hit 엘라스틱서치에서 검색된 하나의 결과를 나타내는 Hit<MedicineFullTextDto> 객체
     * @return 변환된 MedicineDto 객체(시퀀스 번호, 이미지 경로, 항목 이름, 제조사 이름)
     */
    private MedicineDto mapToMedicineDto(Hit<MedicineFullTextDto> hit) {
        MedicineFullTextDto searchResult = hit.source();
        return MedicineDto.builder()
            .medicineSeq(searchResult.getMedicineSeq())
            .imgPath(s3Prefix + searchResult.getImgPath())
            .itemName(searchResult.getItemName())
            .entpName(searchResult.getEntpName())
            .build();
    }
}
