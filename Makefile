MODULE = task
VERSION = 0.4
GEN = gen
BIN = bin
ETC = etc
DIST = ${GEN}/dist
WWW = ${ETC}/www
TAR = ${DIST}/${MODULE}-${VERSION}.tar.gz
RELEASE = ${GEN}/release/${VERSION}
HASH = ${ETC}/sha1
HASH_TAR = ${TAR}.sha1
PUBLISH_WWW = web@mth.io:${MODULE}.mth.io/data
PUBLISH_RELEASE = web@mth.io:${MODULE}.mth.io/data/release/.

.PHONY: clean dist release publish www

default: release

${TAR}: ${DIST}
	mkdir -p ${GEN}/image/${MODULE}-${VERSION}
	cp -r ${BIN} LICENSE COPYING README ${GEN}/image/${MODULE}-${VERSION}
	tar cfz ${TAR} -C ${GEN}/image .

${HASH_TAR}: ${TAR}
	${HASH} ${TAR} > ${HASH_TAR}

dist: clean ${TAR}

www:
	rsync -aH --stats --exclude \*~ ${WWW}/ ${PUBLISH_WWW}

release: dist ${RELEASE} ${HASH_TAR}
	cp ${TAR} ${HASH_TAR} ${RELEASE}

publish: release
	rsync -aH --stats --exclude \*~ ${RELEASE} ${PUBLISH_RELEASE}

${GEN} ${DIST} ${TAR_IMAGE} ${RELEASE}:
	mkdir -p $@

clean:
	rm -rf ${GEN}
	find . -name "*~" -print0 | xargs -0 rm -f
