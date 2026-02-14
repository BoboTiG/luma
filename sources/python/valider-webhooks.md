# Valider la signature d’un webhook

Dans les morceaux de code suivants, une fonction `is_valid_webhook_event(headers, payload)` est définie : elle accepte les entêtes et le corps de la requête HTTP du webhook.

Examples d’utilisation :

`````{tabs}

````{tab} Bottle
```{code-block} python
from bottle import request


@app.post(ROUTE_API_WEBHOOK)
def api_webhook():
    headers = request.headers
    payload = request.body.read()
    if is_valid_webhook_event(headers, payload):
        ...
```
````

````{tab} Falcon
```{code-block} python
import falcon


class ApiWebhook:
    def on_post(self, req: falcon.Request, resp: falcon.Response) -> None:
        headers = req.headers_lower
        payload = req.body
        if is_valid_webhook_event(headers, payload):
            ...


app.add_route(ROUTE_API_WEBHOOK, ApiWebhook())
````

````{tab} Flask
```{code-block} python
from flask import request


@app.route(ROUTE_API_WEBHOOK, methods=["POST"])
def api_webhook():
    headers = request.headers
    payload = request.get_data()
    if is_valid_webhook_event(headers, payload):
        ...
````

`````


## BTCPay Server

```{literalinclude} snippets/valider-webhook-btcpay.py
:language: python
```

## PayPal

Requirements: [cryptography](https://pypi.org/project/cryptography/), [requests](https://pypi.org/project/requests/).

```{literalinclude} snippets/valider-webhook-paypal.py
:language: python
```

## Stripe

```{literalinclude} snippets/valider-webhook-stripe.py
:language: python
```

## 📜 Historique

2026-02-14
: Premier jet.
