#!/bin/bash
# 日本語環境のインストールツールです。

echo "ようこそ。WSL2の日本語設定を行います。"

# パッケージのアップデート
sudo apt update && sudo apt upgrade -y
sudo apt -y install language-pack-ja fcitx-mozc dbus-x11 fonts-noto-cjk x11-utils xdg-utils x11-xkb-utils x11-apps
sudo localectl set-locale ja_JP.UTF-8

# システムフォントの認識
cat << 'EOS' | sudo tee /etc/fonts/local.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/mnt/c/Windows/Fonts</dir>
</fontconfig>
EOS

# FcitxとMozcのセットアップ
sudo sh -c "dbus-uuidgen > /var/lib/dbus/machine-id"
cat << 'EOS' | tee -a ~/.profile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export DefaultIMModule=fcitx
if ! pgrep -x fcitx >/dev/null; then
    fcitx > /dev/null 2>&1
fi
EOS

mkdir ~/.config/environment.d
touch ~/.config/environment.d/japanese.conf
cat << 'EOS' | tee -a ~/.config/environment.d/japanese.conf
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS="@im=fcitx"
INPUT_METHOD=fcitx
DefaultIMModule=fcitx
EOS

echo "
Windowsのコマンドラインで「wsl.exe --shutdown」と入力してWSL2を再起動してください。
再起動後、「fcitx-config-gtk3 &」を入力して現在の入力メソッドを以下のようにしてください。
- キーボード - 日本語
- Mozc
表示されない場合は、「.profile」に以下のコードをコピペしてください。

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export DefaultIMModule=fcitx
if ! pgrep -x fcitx >/dev/null; then
    fcitx > /dev/null 2>&1
fi

今現在fcitx5-mozcはバグが多いのでfcitxを推奨いたします。
LinuxのGUIアプリを使う時、日本語の入力切り替えはCtrl+Spaceのほうが安全に切り替えられます。
全角半角ではすぐに入力しないとキーリピートが発生するので注意してください。
ちなみに'xset -r 49'は試してもだめでした。
Happy WSL Hacking!
"