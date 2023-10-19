process QIIME2_CLASSIFY {
    tag "${repseq},${blast_db}
    label 'process_high'

    container "quay.io/qiime2/core:2022.11"

    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        exit 1, "QIIME2 does not support Conda. Please use Docker / Singularity / Podman instead."
    }

    input:
    path(trained_classifier)
    path(repseq)

    output:
    path("taxonomy.qza"), emit: qza
    path("taxonomy.tsv"), emit: tsv
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    export XDG_CONFIG_HOME="\${PWD}/HOME"

    qiime feature-classifier classify-consensus  \\
        --p-perc-identity 0.97  \\
        --i-reference-reads ${blast_reference_qza}
        --i-reference-taxonomy ${blast_taxonomy_qza} \\
        --i-query ${repseq}  \\
        --o-classification ${blast_db}  \\
        --verbose

    #produce "taxonomy/taxonomy.tsv"
    qiime tools export \\
        --input-path taxonomy.qza  \\
        --output-path taxonomy
    qiime tools export \\
        --input-path taxonomy.qzv  \\
        --output-path taxonomy
    cp taxonomy/blast_consensus_taxonomy.tsv .

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qiime2: \$( qiime --version | sed '1!d;s/.* //' )
    END_VERSIONS
    """
}
