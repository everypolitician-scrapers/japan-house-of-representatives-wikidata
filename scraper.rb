#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://en.wikipedia.org/wiki/Representatives_elected_in_the_Japanese_general_election,_2012',
  xpath: '//table[.//th[contains(.,"Elected Member")]]//tr//td[2]//a[not(@class="new")][1]/@title',
) 

de = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://de.wikipedia.org/wiki/Liste_der_Mitglieder_des_Sh%C5%ABgiin_(46._Wahlperiode)',
  xpath: '//table[.//th[contains(.,"Name")]]//tr//td[1]//a[not(@class="new")][1]/@title',
) 

jp_constituency = EveryPolitician::Wikidata.wikipedia_xpath( 
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

jp = (jp_constituency + jp_pr).uniq

EveryPolitician::Wikidata.scrape_wikidata(names: { en: en, de: de }, output: false)

# TODO investigate why this errors
# EveryPolitician::Wikidata.scrape_wikidata(names: { en: en, de: de, jp: jp }, output: true)
warn EveryPolitician::Wikidata.notify_rebuilder

