#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_members_of_the_House_of_Representatives_of_Japan,_2012-14',
  xpath: '//table[.//th[contains(.,"Elected Member")]]//tr//td[2]//a[not(@class="new")][1]/@title',
)

de = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://de.wikipedia.org/wiki/Liste_der_Mitglieder_des_Sh%C5%ABgiin_(46._Wahlperiode)',
  xpath: '//table[.//th[contains(.,"Name")]]//tr//td[1]//a[not(@class="new")][1]/@title',
)

jp_area = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ja.wikipedia.org/wiki/参議院議員一覧',
  after: '//span[@id=".E9.81.B8.E6.8C.99.E5.8C.BA.E9.81.B8.E5.87.BA.E8.AD.B0.E5.93.A1"]',
  before: '//span[@id=".E6.AF.94.E4.BE.8B.E4.BB.A3.E8.A1.A8.E9.81.B8.E5.87.BA.E8.AD.B0.E5.93.A1"]',
  xpath: '//table//tr//td[position() > 1]//a[not(@class="new")][1]/@title',
)

jp_pr = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ja.wikipedia.org/wiki/参議院議員一覧',
  after: '//span[@id=".E6.AF.94.E4.BE.8B.E4.BB.A3.E8.A1.A8.E9.81.B8.E5.87.BA.E8.AD.B0.E5.93.A1"]',
  before: '//span[@id=".E8.84.9A.E6.B3.A8"]',
  xpath: '//table//tr[position() < last()]//td//a[not(@class="new")][1]/@title',
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

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { en: en, de: de, ja: jp_area | jp_pr })

