def add_linkflag_dependency(name, link_flags):
    native.prebuilt_cxx_library(
        name = name,
        header_namespace = '',
        header_only = True,
        exported_linker_flags = link_flags,
        visibility = [
            'PUBLIC',
        ],
    )

def add_pkgconf_dependency(target_name, pkg_name):
    pkg_config = native.read_config('pkg_config', 'path', 'pkg-config')

    native.genrule(
        name = target_name + '-preprocessor-flags',
        out = 'out.txt',
        cmd = pkg_config + ' ' + pkg_name + ' --cflags > $OUT',
    )

    native.genrule(
        name = target_name + '-linker-flags',
        out = 'out.txt',
        cmd = pkg_config + ' ' + pkg_name + ' --libs > $OUT',
    )

    native.prebuilt_cxx_library(
        name = target_name,
        header_namespace = '',
        header_only = True,
        exported_preprocessor_flags = [
            '@$(location :{}-preprocessor-flags)'.format(target_name),
        ],
        exported_linker_flags = [
            '@$(location :{}-linker-flags)'.format(target_name),
        ],
        visibility = [
            'PUBLIC',
        ],
    )
