#!/bin/bash
# jailhouse buddy setup latest buildroot, kernel, jailhouse in qemu

green='\e[0;32m'
nc='\e[0m'

WORK="$HOME"

set -eux

buildroot_setup()
{
	echo -e "${green}${FUNCNAME[0]}${nc}"
	cd "$WORK" || die "Failed to cd $WORK"
	BUILDROOT="$WORK/buildroot"
	if [ ! -d "$BUILDROOT/.git" ] 
	then
		echo -e "${green}cloning buildroot...${nc}"
		git clone git://git.buildroot.net/buildroot.git
	else
		cd "$BUILDROOT" || die "Failed to cd $BUILDROOT"
		echo -e "${green}pulling buildroot...${nc}"
		#git reset --hard
		#git remote update origin
	fi
	make qemu_"$DEFCONFIG"
	#make jailhouse-dirclean
	#make jailhouse
	make
}

qemu_x86_setup()
{
	echo -e "${green}${FUNCNAME[0]}${nc}"
	#working configuration
	qemu-system-x86_64 -machine q35,kernel_irqchip=split -m 1G -enable-kvm \
		-smp 4 -device intel-iommu,intremap=on,x-buggy-eim=on \
		-cpu kvm64,-kvm_pv_eoi,-kvm_steal_time,-kvm_asyncpf,-kvmclock,+vmx \
		-kernel "$BUILDROOT"/output/images/bzImage \
		-drive file="$BUILDROOT"/output/images/rootfs.ext2,format=raw,if=virtio \
		-nographic -append 'root=/dev/vda memmap=66M$0x3b000000' \
		-net nic,model=virtio -net user
}

qemu_aarch64_setup()
{
	echo -e "${green}${FUNCNAME[0]}${nc}"
	echo -e "${green}FIXME${nc}"
}

ARCH="${1-x86}"
DEFCONFIG="${2:-x86_64_defconfig}"

buildroot_setup "$ARCH" "$DEFCONFIG"
qemu_"${ARCH}"_setup
