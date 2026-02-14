import hmac
from hashlib import sha256

WEBHOOK_SECRET = "xxx"


def is_valid_webhook_event(headers: dict[str, str], payload: bytes) -> bool:
    header = headers["stripe-signature"]
    list_items = [i.split("=", 2) for i in header.split(",")]
    timestamp = int(next(i[1] for i in list_items if i[0] == "t"))
    signatures = [i[1] for i in list_items if i[0] == "v1"]
    signed_payload = f"{timestamp}.{payload.decode()}"
    expected_sig = hmac.new(WEBHOOK_SECRET.encode(), signed_payload.encode(), sha256).hexdigest()
    return any(hmac.compare_digest(expected_sig, sig) for sig in signatures)
