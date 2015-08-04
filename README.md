# Resource-Allocation-for-Virtual-Machines
Application of Particle Swarm Optimization Technique for dynamic resource allocation in a cloud computing environment.

Particle Swarm intelligence is used to efficiently allocate Physical Machine Resources to virtual machine requests. The concept of "skewness factor" or "load balancing factor" is used to measure the unevenness of the resources in each physical machine.

Creating permutations of all possible allocations is taken as the initial population for PSO. The combination which has the minimum skewness is chosen as the best in every population. Thus, using PSO, the Global best(optimal allocation) is arrived avoiding the accumulation of unused resources.
