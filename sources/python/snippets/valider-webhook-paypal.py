import base64
import zlib

import requests
from cryptography import x509
from cryptography.exceptions import InvalidSignature
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding

WEBHOOK_ID = "xxx"


def get_certificate(url: str) -> str:
    """Download the PayPal certificate."""
    with requests.get(url, timeout=30) as req:
        return req.text


def is_valid_webhook_event(headers: dict[str, str], payload: bytes) -> bool:
    # Create the validation message
    transmission_id = headers["paypal-transmission-id"]
    timestamp = headers["paypal-transmission-time"]
    crc = zlib.crc32(payload)
    message = f"{transmission_id}|{timestamp}|{WEBHOOK_ID}|{crc}"

    # Decode the base64-encoded signature from the header
    signature = base64.b64decode(headers["paypal-transmission-sig"])

    # Load the certificate and extract the public key
    certificate = get_certificate(headers["paypal-cert-url"])
    cert = x509.load_pem_x509_certificate(certificate.encode(), default_backend())
    public_key = cert.public_key()

    # Validate the message using the signature
    try:
        public_key.verify(signature, message.encode(), padding.PKCS1v15(), hashes.SHA256())
    except InvalidSignature:
        return False
    return True
