#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_House_of_Representatives_of_Japan,_2012-14',
  xpath: '//table[.//th[contains(.,"Elected Member")]]//tr//td[2]//a[not(@class="new")][1]/@title',
  as_ids: true,
)

jp_area = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ja.wikipedia.org/wiki/%E5%8F%82%E8%AD%B0%E9%99%A2%E8%AD%B0%E5%93%A1%E4%B8%80%E8%A6%A7',
  after: '//span[@id=".E9.81.B8.E6.8C.99.E5.8C.BA.E9.81.B8.E5.87.BA.E8.AD.B0.E5.93.A1"]',
  before: '//span[@id=".E6.AF.94.E4.BE.8B.E4.BB.A3.E8.A1.A8.E9.81.B8.E5.87.BA.E8.AD.B0.E5.93.A1"]',
  xpath: '//table//tr//td[position() > 1]//a[not(@class="new")][1]/@title',
  as_ids: true,
)

jp_pr = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ja.wikipedia.org/wiki/%E5%8F%82%E8%AD%B0%E9%99%A2%E8%AD%B0%E5%93%A1%E4%B8%80%E8%A6%A7',
  after: '//span[@id=".E6.AF.94.E4.BE.8B.E4.BB.A3.E8.A1.A8.E9.81.B8.E5.87.BA.E8.AD.B0.E5.93.A1"]',
  before: '//span[@id=".E8.84.9A.E6.B3.A8"]',
  xpath: '//table//tr[position() < last()]//td//a[not(@class="new")][1]/@title',
  as_ids: true,
)

# Find all members of (terms that started after 2014)
query = <<EOS
  SELECT DISTINCT ?item WHERE {
    ?item p:P39 [ ps:P39 wd:Q17506823 ; pq:P2937 ?term ] .
    ?term wdt:P571|wdt:P580 ?start
    FILTER (?start >= "2014-01-01T00:00:00Z"^^xsd:dateTime) .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s | en | jp_area | jp_pr)
