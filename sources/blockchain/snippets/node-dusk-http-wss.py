"""
This was part of Dusk Node Monitoring until commit 832e35ef5b30bc953ea41cf57f279993cedda6a4.
Source: https://github.com/BoboTiG/dusk-monitor
"""

import json

import requests
import websockets

# Provisioner public key
PROVISIONER = "0123456789abcdef..."


async def listen_to_accepted_blocks() -> None:
    url = "wss://nodes.dusk.network/on"

    async with websockets.connect(url) as wss:
        # Get a session ID
        session_id = await wss.recv()

        # Subscribe to the accepted blocks topic
        with requests.get(  # noqa: ASYNC210
            "https://nodes.dusk.network/on/blocks/accepted",
            headers={"Rusk-Session-Id": session_id},
            timeout=10,
        ) as req:
            req.raise_for_status()

        while "listening":
            raw_block = await wss.recv()
            raw_block = raw_block[raw_block.find(b'{"header"') :]
            block = json.loads(raw_block)
            if block["header"]["generator_bls_pubkey"] == PROVISIONER:
                print(block["header"]["height"])


if __name__ == "__main__":
    import asyncio

    asyncio.run(listen_to_accepted_blocks())
