qemu-system-x86_64: Dockerfile
	docker build -t qemu-sdl-test .
	$(eval ID := $(shell docker create qemu-sdl-test 2>/dev/null))
	docker cp ${ID}:/usr/src/qemu-8.2.1/build/qemu-system-x86_64 .
	docker cp ${ID}:/usr/src/qemu-8.2.1/pc-bios/bios-256k.bin .
	docker cp ${ID}:/usr/src/qemu-8.2.1/pc-bios/efi-e1000.rom .
	docker cp ${ID}:/usr/src/qemu-8.2.1/pc-bios/kvmvapic.bin .
