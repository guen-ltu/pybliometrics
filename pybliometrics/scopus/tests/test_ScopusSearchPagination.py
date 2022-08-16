#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Tests for `scopus.ScopusSearch` module with pagination."""

from nose.tools import assert_equal, raises

from pybliometrics.scopus.utils import SEARCH_MAX_ENTRIES
from pybliometrics.scopus import ScopusSearch
from pybliometrics.scopus.exception import ScopusQueryError


def test_correct_result_size():
    query = 'TITLE-ABS-KEY(("machine learning"))'

    search = ScopusSearch(query, refresh=True, subscriber=False,
                          count=10,
                          start=20,
                          number_of_pages=2)

    assert_equal(len(search.get_eids()), 20)


@raises(ScopusQueryError)
def test_exceeded_search_max_entries_on_pages():
    query = 'TITLE-ABS-KEY(("machine learning"))'
    number_of_pages = 10
    count = SEARCH_MAX_ENTRIES+1 / number_of_pages

    search = ScopusSearch(query, refresh=True, subscriber=False,
                          count=count,
                          start=0,
                          number_of_pages=number_of_pages)


def test_paging_overlaps():
    query = 'TITLE-ABS-KEY(("machine learning"))'

    search = ScopusSearch(query, refresh=True, subscriber=False,
                          count=5,
                          start=0,
                          number_of_pages=1)
    eid_of_first_query = search.get_eids()[-1]

    search = ScopusSearch(query, refresh=True, subscriber=False,
                          count=5,
                          start=3,
                          number_of_pages=1)
    eid_of_second_query = search.get_eids()[1]

    assert_equal(eid_of_first_query, eid_of_second_query)


if __name__ == "__main__":
    test_correct_result_size()
    test_exceeded_search_max_entries_on_pages()
    test_paging_overlaps()
