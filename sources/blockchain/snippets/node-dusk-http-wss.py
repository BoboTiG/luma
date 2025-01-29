"""
This was part of Dusk Node Monitoring until commit 832e35ef5b30bc953ea41cf57f279993cedda6a4.
Source: https://github.com/BoboTiG/dusk-monitor
"""

import json

import niquests
import websockets


async def listen_to_accepted_blocks(provisioner: str) -> None:
    ws_url = "wss://nodes.dusk.network/on"
    blocks_accepted_url = "https://nodes.dusk.network/on/blocks/accepted"

    async with websockets.connect(ws_url) as wss:
        # Get a session ID
        session_id = await wss.recv()

        # Subscribe to the accepted blocks topic
        with niquests.get(blocks_accepted_url, headers={"Rusk-Session-Id": session_id}) as req:
            req.raise_for_status()

        while "listening":
            raw = await wss.recv()
            raw = raw[raw.find(b'{"header"') :]
            block = json.loads(raw)
            if block["header"]["generator_bls_pubkey"] == provisioner:
                print(block["header"]["height"])


if __name__ == "__main__":
    import asyncio
    import sys

    asyncio.run(listen_to_accepted_blocks(sys.argv[1]))
