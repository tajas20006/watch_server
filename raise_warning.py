import sys
from logging import INFO, WARNING, StreamHandler, getLogger
from pathlib import Path

from utils.logging_util import ColoredFormatter

VERBOSE = False
if "-v" in sys.argv:
    VERBOSE = True

logger = getLogger(__name__)
handler = StreamHandler()
handler.setFormatter(ColoredFormatter("%(levelname)s: %(message)s"))
logger.addHandler(handler)

if VERBOSE:
    logger.setLevel(INFO)
    handler.setLevel(INFO)
else:
    logger.setLevel(WARNING)
    handler.setLevel(WARNING)


def _format_datetime(result: Path) -> str:
    date, time = result.name.split(".")[0].split("_")
    date_str = date[:4] + "/" + date[4:6] + "/" + date[6:]
    time_str = time[:2] + ":" + time[2:4] + ":" + time[4:]
    datetime_str = date_str + " " + time_str
    return datetime_str


def main(p: Path):
    for result in p.glob("*.csv"):
        with result.open(encoding="utf-8") as f:
            next(f)  # skip header
            data = next(f).strip()
            if data.endswith('"","n/a","n/a","n/a"'):
                # ok
                continue
            if data.endswith('"","n/a","n/a"'):
                # failed once. info
                logger.info("%s: %s", _format_datetime(result), data)
                continue
            if data.endswith('"","n/a"'):
                # failed twice. warning
                logger.warning("%s: %s", _format_datetime(result), data)
                continue
            # failed thrice. error
            logger.error("%s: %s", _format_datetime(result), data)


if __name__ == "__main__":
    p = Path("result")
    main(p)
