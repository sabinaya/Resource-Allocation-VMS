 pmResource_one = [20,40,80,100];%initializing the resource matrix (6 PMS - CPU utilization%)
 pmResource_two= [60,40,20,100];%initializing the resource matrix (6 PMS - RAM utilization%)
 averagePMTotalResources = (pmResource_one+pmResource_two)/2;  % calculating the skewness factor
 RBF = [0,0,0,0];
 i=1;
 while(i<=4)
   RBF(i) = skewnessRBF(pmResource_one(1,i),pmResource_two(1,i));
   i++;
 endwhile 
 disp(RBF);
 vmResource_one =  [10,20];   %required VM resource CPU
 vmResource_two = [20,30];  %required VM resource RAM (ASSUMPTION: only one VM request)
 %initial population generation
 pmList = [1:length(pmResource_one)];
 disp(pmList);
 permVM = permute_repetitions(pmList,length(vmResource_one));
 %permVM = [1,1;1,2;1,3;1,4;2,1;2,2;2,3;2,4;3,1;3,2;3,3;3,4;4,1;4,2;4,3;4,4];
 disp(permVM);
  permuSize = 1;
  gBest =10;
while(permuSize <= length(permVM))
    vm =1;
    permVMPopulation_sum = 0;
    while(vm<=length(vmResource_one))
    RBF_Allocation = skewnessRBF(pmResource_one(permVM(permuSize,vm))- vmResource_one(vm),pmResource_two(permVM(permuSize,vm))- vmResource_two(vm));
    permVMPopulation(permuSize,vm) = RBF_Allocation; 
    permVMPopulation_sum += RBF_Allocation;
    vm++;
  endwhile
    permVMPopulation_avg(permuSize) = permVMPopulation_sum/(length(vmResource_one));
    if(gBest > permVMPopulation_avg(permuSize))
      gBest = permVMPopulation_avg(permuSize);
    end
    permuSize++;
 endwhile
 disp(permVMPopulation); 
 disp(permVMPopulation_avg);
 
 % Generation of intial population is done..
 % TODO: implement PSO using the generated population.
 velocityMatrix = [0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0;0,0];
 
 %Second population
 permuSize = 1;
 w = 0.7; %inertia
 c1 = 1.5; %constant
 c2 = 1.5; %contant
 r1 = 0.9; %contant
 r2 = 0.9; %contant
while(permuSize <= length(permVM))
    vm =1;
    while(vm<=length(vmResource_one))
      velocityMatrix2(permuSize,vm) =  w*velocityMatrix(permuSize,vm)+ c1*r1*(permVMPopulation(permuSize,vm)-permVMPopulation(permuSize,vm))+c2*r2*(gBest-permVMPopulation(permuSize,vm));
      permVMPopulation2(permuSize,vm) =  permVMPopulation(permuSize,vm)  + velocityMatrix2(permuSize,vm);
    vm++;
  endwhile
    [s,i] = sort(permVMPopulation2(permuSize,:));
    sortedPermVMPopulation2(permuSize,:)=s;
    sortedPermVMPopulationIndex2(permuSize,:)=i;
    permuSize++;
 endwhile

 %disp(velocityMatrix2);
 %disp(gBest);
 %disp(permVMPopulation2);

 disp(sortedPermVMPopulation2);
 disp(sortedPermVMPopulationIndex2);