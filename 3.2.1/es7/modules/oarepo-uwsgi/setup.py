#!/usr/bin/env python

from setuptools import setup, find_packages

setup(name='oarepo-uwsgi',
      version='0.0.1',
      description='OArepository uwsgi module',
      author='Miroslav Bauer @ CESNET',
      author_email='Miroslav.Bauer@cesnet.cz',
      url='https://github.com/oarepo/oarepo-base',
      packages=find_packages(),
      use_2to3=False,
      )
