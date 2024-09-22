SHELL := /bin/bash

DPDK_URL = https://fast.dpdk.org/rel/dpdk-24.07.tar.xz
DPDK_TAR = dpdk-24.07.tar.xz
DPDK_DIR = dpdk-24.07
DPDK_MD5 = 48151b1bd545cd95447979fa033199bb
CFLAGS += -Wall -Wextra -Wstrict-prototypes -Wmissing-declarations -Wdeclaration-after-statement -Werror -msse4.2 
LDFLAGS += -lrte_hash -lrte_eal


HUGE_PAGES = 1024
all:
	sudo sysctl -w vm.nr_hugepages=$(HUGE_PAGES)
	sudo mkdir ./hpm
	sudo mount -t hugetlbfs pagesize=2M ./hpm
	wget $(DPDK_URL)
	ACTUAL_MD5="$$(md5sum $(DPDK_TAR) | awk '{print $$1}')" && \
	if [ "$$ACTUAL_MD5" != '$(DPDK_MD5)' ]; then echo "хэш не совпадает"; \
		exit 1; \
	fi
	tar xf $(DPDK_TAR)
	cd $(DPDK_DIR);\
	meson setup -Dprefix=/opt/dpdk-install/ build && cd build && ninja && sudo meson install && sudo ldconfig

	@$(CC) $(CFLAGS) -o test test.c $(LDFLAGS)

run:
	@sudo ./test

clean:
	@sudo umount ./hpm
	@rm -f $(DPDK_TAR)
	@rm -rf $(DPDK_DIR)
	@rm -rf ./hpm
	@rm -f test
