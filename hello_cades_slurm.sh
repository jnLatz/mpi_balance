#!/bin/bash
#SBATCH -J hello_balance
#SBATCH -A ccsd
#SBATCH -p batch
#SBATCH -N 4
#SBATCH --ntasks-per-node 4
#SBATCH --mem=2G
#SBATCH -t 00:00:10
#SBATCH -e ./balance.e
#SBATCH -o ./balance.o
#SBATCH --mail-user=ost@ornl.gov
#SBATCH --mail-type=FAIL

cd ~/mpi_balance
pwd

## module names can vary on different platforms
module purge               # cades condo
module load PE-gnu/3.0     # cades condo
module load R/3.6.0        # cades condo
echo "loaded R"
module list

## prevent warning when fork is used with MPI
export OMPI_MCA_mpi_warn_on_fork=0

# Note that 4 nodes with 32 cores are allocated by PBS above. Their actual
# use is determined by the mpirun command below. Some local cluster policies
# may ignore the nodes request if requested cores can fit in fewer nodes.
#
# An illustration of fine control of R scripts and cores on several nodes
# This runs 4 R sessions on each of 4 nodes (for a total of 16).
#
# Each of the 16 hello_world.R scripts will calculate how many cores are
# available per R session from PBS environment variables and use that many
# in mclapply.
#
# nodes and mapping picked up from slurm by openmpi
mpirun --mca btl tcp,self Rscript hello_balance.R
