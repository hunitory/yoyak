package com.yoyak.yoyak.util.elasticsearch;

import com.yoyak.yoyak.medicine.dto.MedicineFullTextDto;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder(access = AccessLevel.PRIVATE)
@ToString
public class SearchParameters<T> {

    private static final int DEFAULT_SIZE = 10;

    private String index;
    private String keyword;
    private int start;
    private int size;
    private List<String> fieldsToSearch;
    private Class<T> tClass;
    private List<String> sourceIncludes;


    private static final String DEFAULT_MEDICINE_INDEX = "medicine";
    private static final Class DEFAULT_MEDICINE_CLASS = MedicineFullTextDto.class;
    private static final List<String> DEFAULT_MEDICINE_FIELDS =
        Arrays.asList("item_name", "atpn", "atpn_warn", "class_name", "efficacy", "side_effect");
    private static final List<String> DEFAULT_MEDICINE_SOURCE_FIELDS =
        Arrays.asList("seq", "img_path", "item_name", "entp_name");

    /**
     * 약품 검색을 위한 검색 파라미터를 생성합니다. 페이지네이션과 검색 키워드를 포함합니다.
     *
     * @param page    페이지 번호입니다. 페이지네이션에 사용됩니다.
     * @param keyword 검색할 키워드입니다.
     * @return 약품 검색을 위해 구성된 SearchParameters 인스턴스를 반환합니다.
     */
    public static SearchParameters createRegexSearchParameters(
        int page, String keyword) {

        int start = (page - 1) * DEFAULT_SIZE;

        return SearchParameters.builder()
            .index(DEFAULT_MEDICINE_INDEX)
            .keyword(".*" + keyword.toLowerCase() + ".*")
            .start(start)
            .size(DEFAULT_SIZE)
            .fieldsToSearch(DEFAULT_MEDICINE_FIELDS)
            .tClass(DEFAULT_MEDICINE_CLASS)
            .sourceIncludes(DEFAULT_MEDICINE_SOURCE_FIELDS) // SourceConfig에 포함할 필드 설정
            .build();
    }


    /**
     * 풀 텍스트 검색을 위한 검색 파라미터를 생성합니다.
     *
     * @param page    페이지 번호입니다.
     * @param keyword 검색할 키워드입니다.
     * @return 풀 텍스트 검색을 위해 구성된 SearchParameters 인스턴스를 반환합니다.
     */
    public static SearchParameters createMedicineFullTextSearchParameters(
        int page, String keyword) {
        int start = (page - 1) * DEFAULT_SIZE;

        List<String> nGramFields = DEFAULT_MEDICINE_FIELDS.stream()
            .map(field -> field + ".ngram")  // 각 필드명에 .ngram을 추가
            .collect(Collectors.toList());

        return SearchParameters.<MedicineFullTextDto>builder()
            .index(DEFAULT_MEDICINE_INDEX)
            .keyword(keyword)
            .start(start)
            .size(DEFAULT_SIZE)
            .fieldsToSearch(nGramFields)  // 여기서는 기본 필드를 사용
            .tClass(DEFAULT_MEDICINE_CLASS)
            .sourceIncludes(DEFAULT_MEDICINE_SOURCE_FIELDS)
            .build();
    }
}
