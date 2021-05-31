set path=%path%;C:\Program Files (x86)\gettext\bin;C:\Program Files (x86)\Bochs-2.6.2
cat test.bin | dd of=floppyA bs=512 count=2880

bochs "boot:a" "floppya: 1_44=floppyA, status=inserted"