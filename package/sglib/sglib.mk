
SGLIB_VERSION = 1.0
SGLIB_SOURCE =
SGLIB_SITE =
SGLIB_SITE_METHOD =
SGLIB_DL_SUBDIR =
SGLIB_OVERRIDE_SRCDIR = $(@D)

SGLIB_FILES = \
    $(TOPDIR)/../sophon_media/buildit/sophon-media-soc_*_aarch64.tar.gz|sophon_media_test \
    $(TOPDIR)/../middleware/v2/modules/isp/cv186x/v4l2_adapter/sophon-soc-libisp_*_arm64.tar.gz|isp_test  \
	$(TOPDIR)/../libsophon/build/libsophon_soc_*_aarch64.tar.gz|libsophon_test

ORI_FLASH_PARTITION_XML = $(TOPDIR)/../build/boards/sophon/edge_buildroot/partition/partition_emmc.xml
DEST_FLASH_PARTITION_XML = $(TOPDIR)/board/sophgo/common/tools/partition_emmc.xml

BOARD_DIR = $(TOPDIR)/board/sophgo/common/overlay/opt/
TOOLS_DIR = $(TOPDIR)/board/sophgo/common/tools/

define SGLIB_BUILD_CMDS

	if [ ! -d $(BOARD_DIR)/sophon ]; then \
        mkdir -p $(BOARD_DIR)/sophon;	\
    fi

	$(foreach entry,$(SGLIB_FILES), \
		$(eval file = $(word 1,$(subst |, ,$(entry)))) \
		$(eval pkg = $(word 2,$(subst |, ,$(entry)))) \
		$(eval dlfile = $(shell ls $(SGLIB_DL_DIR)/$(notdir $(file)) 2>/dev/null)) \

		if [ -z "$(dlfile)" ]; then \
			$(eval onefile = $(shell ls $(file) 2>/dev/null)) \
			if [ -n "$(onefile)" ]; then \
				$(INSTALL) -D -m 0644 $(onefile) $(SGLIB_DL_DIR)/$(notdir $(onefile)); \
			else \
				$(eval tag = $(shell curl -s https://api.github.com/repos/yike2024/$(pkg)/tags | grep name | cut -d'"' -f4 | head -n1)) \
				$(eval url = $(shell curl -s https://api.github.com/repos/yike2024/$(pkg)/releases/tags/$(tag) | grep -oP 'browser_download_url": "\K[^"]+\.tar\.gz')) \
				wget $(url) -P $(SGLIB_DL_DIR); \
			fi \
		fi

		$(TOPDIR)/package/sglib/sglib.sh $(pkg) $(file) $(SGLIB_DL_DIR) $(@D) $(BOARD_DIR)
	)

	if [ ! -f $(ORI_FLASH_PARTITION_XML) ]; then \
		cp $(ORI_FLASH_PARTITION_XML) $(TOOLS_DIR)/; \
	fi

	# Generate S10_automount
	${Q}python3 $(TOOLS_DIR)/create_automount.py $(TOOLS_DIR)/partition_emmc.xml $(TOPDIR)/board/sophgo/common/overlay/etc/init.d/

endef

$(eval $(generic-package))