import logging
import os
import time
from logging import Formatter, StreamHandler


def create_logger():
    log_level = os.getenv("LOG_LEVEL", logging.INFO)
    log_format = "[%(asctime)s] [%(levelname)s] %(message)s"
    log_timestamp_format = "%Y-%m-%dT%H:%M:%S%z"

    formatter = Formatter(log_format, log_timestamp_format)
    formatter.converter = time.gmtime

    handler = StreamHandler()
    handler.setFormatter(formatter)

    default_logger = logging.getLogger()
    default_logger.setLevel(log_level)
    default_logger.addHandler(handler)

    return default_logger


logger = create_logger()
