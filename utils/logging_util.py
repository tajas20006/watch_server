from logging import INFO, Formatter, WARNING, ERROR, DEBUG, CRITICAL


class ColoredFormatter(Formatter):
    """Output logging with color according to the level"""

    GREY = "\x1b[38;20m"
    YELLOW = "\x1b[33;20m"
    RED = "\x1b[31;20m"
    BOLD_RED = "\x1b[31;1m"

    RESET = "\x1b[0m"

    COLORS = {
        DEBUG: GREY,
        INFO: GREY,
        WARNING: YELLOW,
        ERROR: RED,
        CRITICAL: BOLD_RED,
    }

    def __init__(self, fmt="%(message)s"):
        self.__fmt = fmt

    def format(self, record):
        color = self.COLORS.get(record.levelno)
        if not color:
            formatter = Formatter(self.__fmt)
        else:
            formatter = Formatter(color + self.__fmt + self.RESET)
        return formatter.format(record)
