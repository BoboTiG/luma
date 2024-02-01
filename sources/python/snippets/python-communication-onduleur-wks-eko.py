import serial


def init_serial(port: str) -> serial.Serial:
    return serial.Serial(
        port=port,
        baudrate=2400,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
    )


def compute_crc(value: str) -> str:
    """
    >>> compute_crc("96332309100452")
    '?xf3'
    """
    crc = 0
    for ch in value:
        if not ch:
            break
        crc ^= ord(ch) << 8
        for _ in range(8):
            crc = crc << 1 if (crc & 0x8000) == 0 else (crc << 1) ^ 0x1021
        crc &= 0xFFFF
    return crc.to_bytes(2, "big").decode(encoding="latin1")


def send_command(conn: serial.Serial, command: str) -> bool:
    full_command = f"{command}{compute_crc(command)}\r"
    return conn.write(serial.to_bytes(ord(c) for c in full_command)) == len(full_command)


def get_response(conn: serial.Serial) -> str:
    response = conn.read_until(expected=b"\r")

    # Remove leading parenthesis, and trailing CRC + CR
    response = response[1:-3]
    return response.decode(encoding="latin1")


def example() -> None:
    """
    >>> conn = init_serial("/dev/ttyUSB0")
    >>> send_command(conn, "QID")
    True
    >>> get_response(conn)
    '96332309100452'
    """


def module() -> None:
    """
    >>> from inverter_com import Inverter
    >>> inverter = Inverter("/dev/ttyUSB0")
    >>> inverter.send("QID")
    '96332309100452'
    """
