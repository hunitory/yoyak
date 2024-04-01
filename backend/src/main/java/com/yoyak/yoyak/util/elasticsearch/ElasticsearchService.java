package com.yoyak.yoyak.util.elasticsearch;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.SourceConfig;
import co.elastic.clients.json.jackson.JacksonJsonpMapper;
import co.elastic.clients.transport.rest_client.RestClientTransport;
import java.io.IOException;
import org.elasticsearch.client.RestClient;
import org.springframework.stereotype.Service;

@Service
public class ElasticsearchService {

    private final RestClient restClient;

    public ElasticsearchService(RestClient restClient) {
        this.restClient = restClient;
    }

    public <T> SearchResponse regexFullTextSearch(SearchParameters<T> parameters)
        throws IOException {
        ElasticsearchClient esClient = new ElasticsearchClient(
            new RestClientTransport(restClient, new JacksonJsonpMapper()));

        SearchRequest searchRequest = SearchRequest.of(s -> s
            .index(parameters.getIndex())
            .from(parameters.getStart())
            .size(parameters.getSize())
            .source(SourceConfig.of(src -> src
                .filter(f -> f
                    .includes(parameters.getSourceIncludes())
                )
            ))
            .query(q -> q
                .bool(b -> {
                    parameters.getFieldsToSearch().forEach(field ->
                        b.should(should -> should.regexp(
                            r -> r.field(field).value(parameters.getKeyword())))
                    );
                    return b.minimumShouldMatch("1");
                })
            )
        );

        return esClient.search(searchRequest, parameters.getTClass());
    }
}
