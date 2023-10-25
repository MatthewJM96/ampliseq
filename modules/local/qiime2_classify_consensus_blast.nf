process QIIME2_CLASSIFY_CONSENSUS_BLAST {
    tag "${repseq},${meta.FW_primer}-${meta.RV_primer}"
    label 'process_high'

    container "qiime2/core:2023.7"

    // Exit if running this module with -profile conda / -profile mamba
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        exit 1, "QIIME2 does not support Conda. Please use Docker / Singularity / Podman instead."
    }

    input:
    path(repseq)
    tuple val(meta), path(reference_reads)

    output:
    path("blast_taxonomy.qza"), emit: qza
    path("blast_taxonomy.tsv"), emit: tsv
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    export XDG_CONFIG_HOME="\${PWD}/HOME"

    qiime feature-classifier classify-consensus-blast  \\
        --p-perc-identity 0.97  \\
        --i-reference-reads ${meta.FW_primer}-${meta.RV_primer}-ref-seq.qza \\
        --i-reference-taxonomy ref-taxonomy.qza \\
        --i-query ${repseq}  \\
        --o-classification blast_taxonomy.qza  \\
        --o-search-results blast_hits.qza \\
        --verbose
    qiime metadata tabulate  \\
        --m-input-file blast_taxonomy.qza  \\
        --o-visualization blast_taxonomy.qzv  \\
        --verbose
    #produce "taxonomy/taxonomy.tsv"
    qiime tools export \\
        --input-path blast_taxonomy.qza  \\
        --output-path blast_taxonomy
    qiime tools export \\
        --input-path blast_taxonomy.qzv  \\
        --output-path blast_taxonomy
    cp taxonomy/blast_taxonomy.tsv .

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        qiime2: \$( qiime --version | sed '1!d;s/.* //' )
    END_VERSIONS
    """
}
