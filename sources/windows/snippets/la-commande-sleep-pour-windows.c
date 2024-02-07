/* Le premier ping, celui nous obligeant à utiliser N+1 */
Ping();

/* Et la boucle : délai 1 sec + N ping */
i = 1;
while (i < PingCount)
{
    Sleep(1000);
    Ping();

    if (!PingForever)
        i++;
}
