#!/bin/sh

installer_path=$PWD

echo "[+] Checking for required dependencies..."
if command -v git >/dev/null 2>&1 ; then
    echo "[-] Git found!"
else
    echo "[-] Git not found! Aborting..."
    echo "[-] Please install git and try again."
fi

if [ -f ~/.gdbinit ] || [ -h ~/.gdbinit ]; then
    echo "[+] backing up gdbinit file"
    cp ~/.gdbinit ~/.gdbinit.back_up
fi

# download pwndbg
if [ -d ~/pwndbg ] || [ -h ~/.pwndbg ]; then
    echo "[-] Pwndbg found"
    read -p "skip download to continue? (enter 'y' or 'n') " skip_pwndbg

    if [ $skip_pwndbg = 'n' ]; then
        rm -rf ~/pwndbg
        git clone https://github.com/pwndbg/pwndbg.git ~/.pwndbg

        cd ~/pwndbg
        ./setup.sh
    else
        echo "Pwndbg skipped"
    fi
else
    echo "[+] Downloading Pwndbg..."
    git clone https://github.com/pwndbg/pwndbg.git ~/.pwndbg

    cd ~/pwndbg
    ./setup.sh
fi

# download gef
echo "[+] Downloading GEF..."
git clone https://github.com/bata24/gef.git ~/.gef

cd $installer_path

echo "[+] Setting .gdbinit..."
cp gdbinit ~/.gdbinit

{
  echo "[+] Creating files..."
    sudo cp pwndbg /usr/bin/pwndbg &&\
    sudo cp gef /usr/bin/gef
} || {
  echo "[-] Permission denied"
    exit
}

{
  echo "[+] Setting permissions..."
    sudo chmod +x /usr/bin/pwndbg &&\
    sudo chmod +x /usr/bin/gef
} || {
  echo "[-] Permission denied"
    exit
}

echo "[+] Done"
