#!/bin/bash
# 日本語環境のインストールツールです。

echo "ようこそ。WSL2の日本語設定を行います。"

# パッケージのアップデート
sudo apt update && sudo apt upgrade -y
sudo apt -y install language-pack-ja fcitx5-mozc dbus-x11 fonts-noto-cjk x11-utils xdg-utils x11-xkb-utils x11-apps
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
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
export INPUT_METHOD=fcitx5
export DefaultIMModule=fcitx5
if [ $SHLVL = 1 ] ; then
  (fcitx5 --disable=wayland -d --verbose '*'=0 &)
fi
EOS

mkdir ~/.config/environment.d
touch ~/.config/environment.d/japanese.conf
cat << 'EOS' | tee -a ~/.config/environment.d/japanese.conf
GTK_IM_MODULE=fcitx5
QT_IM_MODULE=fcitx5
XMODIFIERS="@im=fcitx5"
INPUT_METHOD=fcitx5
DefaultIMModule=fcitx5
EOS

echo "
Windowsのコマンドラインで「wsl.exe --shutdown」と入力してWSL2を再起動してください。
再起動後、「fcitx5-config-qt &」を入力して現在の入力メソッドを以下のようにしてください。
- キーボード - 日本語
- Mozc

LinuxのGUIアプリを使う時、日本語の入力切り替えはCtrl+Spaceのほうが安全に切り替えられます。
全角半角ではすぐに入力しないとキーリピートが発生するので注意。
ちなみに'xset -r 49'は試してもだめでした。
Happy WSL Hacking!
"