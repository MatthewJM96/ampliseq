process QIIME2_INTREE {
    tag "${meta.id}:${meta.model}"
    label 'process_low'

    container "qiime2/core:2023.7"

    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        exit 1, "QIIME2 does not support Conda. Please use Docker / Singularity / Podman instead."
    }

    input:
    tuple val(meta), path(tree)

    output:
    path("tree.qza")   , emit: qza
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    qiime tools import \\
        --type 'Phylogeny[Rooted]' \\
        --input-path $tree \\
        --output-path tree.qza

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qiime2: \$( qiime --version | sed '1!d;s/.* //' )
    END_VERSIONS
    """
}
