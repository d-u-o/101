All solutions including the accepted one have some issues as stated in their respective comments. The accepted answer by @jonathan-leffler is already quite good but does not take into effect that prerequisites are not necessarily to be built in order (during make -j for example). However simply moving the directories prerequisite from all to program provokes rebuilds on every run AFAICT. The following solution does not have that problem and AFAICS works as intended.

```
MKDIR_P := mkdir -p
OUT_DIR := build

.PHONY: directories all clean

all: $(OUT_DIR)/program

directories: $(OUT_DIR)

$(OUT_DIR):
    ${MKDIR_P} $(OUT_DIR)

$(OUT_DIR)/program: | directories
    touch $(OUT_DIR)/program

clean:
    rm -rf $(OUT_DIR)
```
