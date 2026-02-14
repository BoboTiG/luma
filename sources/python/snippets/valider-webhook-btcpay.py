import hmac
from hashlib import sha256

WEBHOOK_SECRET = "xxx"


def is_valid_webhook_event(headers: dict[str, str], payload: bytes) -> bool:
    algo, signature = headers["btcpay-sig"].split("=", 1)
    assert algo == "sha256"
    expected_sig = hmac.new(WEBHOOK_SECRET.encode(), payload, sha256).hexdigest()
    return hmac.compare_digest(expected_sig, signature)
