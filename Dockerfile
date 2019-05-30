
FROM mcr.microsoft.com/windows:1903-amd64

LABEL Description="GoCD Agent" Version="2019.05"

# Install chocolatey
RUN  powershell.exe -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install gocd agent
RUN powershell.exe -Command \
    choco install -y gocdagent --version 19.3.0 --ia '/START_AGENT=NO /D=C:\GoAgent'


COPY docker-entrypoint.ps1 c:/docker-entrypoint.ps1
COPY docker-entrypoint.bat c:/docker-entrypoint.bat


ENTRYPOINT ["c:\\docker-entrypoint.bat"]
