@echo off

net user Bob /add

rem Lui assigner un mot de passe (laisser vide pour aucun)
net user Bob *

rem "administrateurs" est à traduire suivant la langue du système
net localgroup administrateurs Bob /add
