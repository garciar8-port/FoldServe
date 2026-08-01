"""Smoke test: the package and its submodules import cleanly."""

import importlib

import foldserve


def test_version():
    assert foldserve.__version__


def test_submodules_import():
    for mod in ("data", "models", "training", "serving"):
        importlib.import_module(f"foldserve.{mod}")
