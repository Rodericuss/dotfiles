# Lily58 / Vial

`layout.vil` é o export mais recente do layout Vial. Ele preserva os bindings,
mas não contém o firmware nem o código do OLED.

O diretório `firmware-overlay/` contém os arquivos customizados da instalação
atual: `MASTER_LEFT`, Chi-Rho no OLED, sincronização de estado entre as metades,
o keymap Vial e o mapa visual `vial.json`.

Para reconstruir o firmware em outra máquina:

```bash
git clone https://github.com/vial-kb/vial-qmk.git ~/vial_qmk
cp -a ~/dotfiles/keyboard/firmware-overlay/. ~/vial_qmk/
cd ~/vial_qmk
qmk compile -kb lily58/rev1 -km vial
```

O resultado esperado é `lily58_rev1_vial.uf2`. Flash deve ser feito nas duas
metades RP2040, verificando em cada vez que o volume montado é realmente
`RPI-RP2`; não assuma que o caminho `/dev/sdX` permanece igual.
