#!/usr/bin/env bash
#SBATCH -t 0-4
#SBATCH -N1 -n8 --mem=32G

date

# prepare module environment
module load edgeml
export PYTHONPATH=${SLURM_SUBMIT_DIR}:${PYTHONPATH}
module -l list

# activate conda environment
. /fusion/projects/diagnostics/bes/smithdr/miniconda3/etc/profile.d/conda.sh
conda activate py38
conda info -e

# prepare work area in local scratch
job_label="job_${SLURM_JOB_ID}"
mkdir /local-scratch/${job_label}
cd /local-scratch/${job_label}
pwd -P

# do work
python -c "import elms; elms.package_metadata()" &> python.txt
python_exit=$?
echo "Python exit status: ${python_exit}"

# move work from local scratch to submission area
mkdir -p ${SLURM_SUBMIT_DIR}/data
cd ${SLURM_SUBMIT_DIR}/data
pwd -P
mv /local-scratch/${job_label} ./metadata-${job_label}

date

exit $python_exit
