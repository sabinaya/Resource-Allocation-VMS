physicalMachineResources_1 = [20,100,10,50,70,70,40,30,44,1];
physicalMachineResources_2 = [60,40,40,100,0,3,70,1,5,64];

virtualMachineResources_1 = [10,20,0];   
virtualMachineResources_2 = [20,30,10]; 

number_of_physical_machines = length(physicalMachineResources_1);
number_of_virtual_machines = length(virtualMachineResources_2);

pmNumerList = [1:number_of_physical_machines];

allocation_matrix_1 = (permute_repetitions(pmNumerList,number_of_virtual_machines));

row_count = 1;
global_best_1 = 10;

while(row_count <= length(allocation_matrix_1))
   allocation_sum_cpu = 0;
   allocation_sum_ram = 0;
   column_count =1;
   rbf_matrix_sum_1 = 0;
   while(column_count <= number_of_virtual_machines)
      %disp("allcoation");
      %disp(row_count);
      %disp(column_count);
      if(column_count == 1)
        allocation_sum_cpu += physicalMachineResources_1(allocation_matrix_1(row_count,column_count));
        allocation_sum_ram += physicalMachineResources_2(allocation_matrix_1(row_count,column_count));
      end
      rbf_value = skewnessRBF(physicalMachineResources_1(allocation_matrix_1(row_count,column_count)) + virtualMachineResources_1(column_count),physicalMachineResources_2(allocation_matrix_1(row_count,column_count)) + virtualMachineResources_2(column_count));
      rbf_matrix_1(row_count,column_count) = rbf_value; 
      rbf_matrix_sum_1 += rbf_value;
      
      allocation_sum_cpu += virtualMachineResources_1(column_count);
      allocation_sum_ram += virtualMachineResources_2(column_count);
      %disp("ram sum");
      %disp(allocation_sum_cpu);
      %disp("cpu sum");
      %disp(allocation_sum_ram);
      column_count++;
   endwhile
   allocation_matrix_row_avg_1(row_count) = rbf_matrix_sum_1/number_of_virtual_machines;
   if(allocation_sum_cpu > 100 || allocation_sum_ram > 100)
          allocation_matrix_row_avg_1(row_count) =  100;
   end
   if(global_best_1 > allocation_matrix_row_avg_1(row_count))
      global_best_1 = allocation_matrix_row_avg_1(row_count);
      finalAllocation = allocation_matrix_1(row_count,:);
   end
   row_count++;
endwhile

velocity_matrix_1 = (permute_repetitions([0,0,0,0,0,0,0,0,0,0],3));

%disp("Allocation Matrix");
%disp(allocation_matrix_1);

%disp("RBF Matrix");
%disp(rbf_matrix_1);

%disp("Initial Global Best");
%disp(global_best_1);



%|-----------------------------------------------------Population II Generation ------------------------------------------------------------|%
%|Implementation of Particle Swarm Optimization to get the best allocation of Virtual machine Resources in Physical Machine-----------------|%
%|------------------------------------------------------------------------------------------------------------------------------------------|%
sorted_position_matrix_final = (permute_repetitions([0,0,0,0,0,0,0,0,0,0],3));
sorted_position_matrix_index_final = (permute_repetitions([0,0,0,0,0,0,0,0,0,0],3));
sorted_position_matrix_2 = [];
sorted_position_matrix_index_2 = [];
velocity_matrix_2 = [];
row_count = 1;
w = 0.7;  %inertia
c1 = 1.5; %constant
c2 = 1.5; %constant
r1 = 0.9; %constant
r2 = 0.9; %constant

while(row_count <= length(allocation_matrix_1))
   column_count =1;
   while(column_count <= number_of_virtual_machines)
      velocity_matrix_2(row_count,column_count) =  w*velocity_matrix_1(row_count,column_count)+ c1*r1*(rbf_matrix_1(row_count,column_count)-rbf_matrix_1(row_count,column_count))+c2*r2*(global_best_1-rbf_matrix_1(row_count,column_count));
      position_matrix_2(row_count,column_count) =  rbf_matrix_1(row_count,column_count)  + velocity_matrix_2(row_count,column_count);
    column_count++;
   endwhile
   [s,i] = sort(position_matrix_2(row_count,:));
   sorted_position_matrix_2(row_count,:) = s;
   sorted_position_matrix_index_2(row_count,:) = i;
   row_count++;
endwhile

%disp("Velocity Matrix 2");
%disp(velocity_matrix_2);

%disp("Position Matrix 2");
%disp(position_matrix_2);

row_count=1;
global_best_2 = global_best_1;
while(row_count <= length(allocation_matrix_1))
   allocation_sum_cpu = 0;
   allocation_sum_ram = 0;
   column_count=1;
   rbf_matrix_sum_2=0;
   while(column_count<=number_of_virtual_machines)
      allocation_matrix_2(row_count,column_count) = allocation_matrix_1(row_count,(sorted_position_matrix_index_2(row_count,column_count)));
      if(column_count == 1)
        allocation_sum_cpu += physicalMachineResources_1(allocation_matrix_2(row_count,column_count));
        allocation_sum_ram += physicalMachineResources_2(allocation_matrix_2(row_count,column_count));
      end
      rbf_value = skewnessRBF(physicalMachineResources_1(allocation_matrix_2(row_count,column_count)) + virtualMachineResources_1(column_count),physicalMachineResources_2(allocation_matrix_2(row_count,column_count)) + virtualMachineResources_2(column_count));
      rbf_matrix_2(row_count,column_count) = rbf_value; 
      rbf_matrix_sum_2 += rbf_value;
      allocation_sum_cpu += virtualMachineResources_1(column_count);
      allocation_sum_ram += virtualMachineResources_2(column_count);
      column_count++;
   endwhile
   rbf_matrix_average_2(row_count) = rbf_matrix_sum_2/(number_of_virtual_machines);
   if(allocation_sum_cpu > 100 || allocation_sum_ram > 100)
          allocation_matrix_row_avg_1(row_count) =  100;
   end
   if(global_best_2 > rbf_matrix_average_2(row_count))
      global_best_2 = rbf_matrix_average_2(row_count);
      finalAllocation = allocation_matrix_2(row_count,:);
   end
   row_count++;
endwhile

%disp("RBF Matrix 2");
%disp(rbf_matrix_2);

%disp("Global Best Value 2");
%disp(global_best_2);

%disp("Allocation Matrix After Shuffle");
%disp(allocation_matrix_2);


%|-----------------------------------------------------Population III -n Generation ---------------------------------------------------------|%
%|Automation of Particle Swarm Optimization to get the best allocation of Virtual machine Resources in Physical Machine----------------------|%
%|------------------------------------------------------------------------------------------------------------------------------------------|%


current_population_number = 3;
allocation_matrix_final = allocation_matrix_2;
position_matrix_final = position_matrix_2;
velocity_matrix_final = velocity_matrix_2;
rbf_matrix_final = rbf_matrix_2;
global_best_final = global_best_2;

total_population = 10

while(current_population_number <= total_population)

   rbf_matrix_sum_final = 0;
   rbf_value_final = 0; 
   % velocity matrix generation
   row_count = 1;
   while(row_count <= length(allocation_matrix_final))
      column_count = 1;
      while(column_count <= number_of_virtual_machines)
         velocity_matrix_final(row_count,column_count) =  w*velocity_matrix_final(row_count,column_count)+ c1*r1*(position_matrix_final(row_count,column_count)-position_matrix_final(row_count,column_count))+c2*r2*(global_best_final-position_matrix_final(row_count,column_count));
         position_matrix_final(row_count,column_count) =  rbf_matrix_final(row_count,column_count)  + velocity_matrix_final(row_count,column_count);
         column_count++;
      endwhile
      [s,i] = sort(position_matrix_final(row_count,:));
      sorted_position_matrix_final(row_count,:) = s;
      sorted_position_matrix_index_final(row_count,:)=i;
      row_count++;
   endwhile
   %velocity generation ends here
   row_count = 1;
   while(row_count <= length(allocation_matrix_final))
     column_count = 1;
     rbf_matrix_sum_final = 0;
     allocation_sum_cpu = 0;
     allocation_sum_ram = 0;
     while(column_count <= number_of_virtual_machines)
          
       sorted_position_matrix_index_final(row_count,column_count) = allocation_matrix_final(row_count,(sorted_position_matrix_index_final(row_count,column_count)));
       if(column_count == 1)
        allocation_sum_cpu += physicalMachineResources_1(sorted_position_matrix_index_final(row_count,column_count));
        allocation_sum_ram += physicalMachineResources_2(sorted_position_matrix_index_final(row_count,column_count));
       end    
       rbf_value_final = skewnessRBF(physicalMachineResources_1(sorted_position_matrix_index_final(row_count,column_count)) + virtualMachineResources_1(column_count),physicalMachineResources_2(sorted_position_matrix_index_final(row_count,column_count)) + virtualMachineResources_2(column_count)); 
       rbf_matrix_final(row_count,column_count) = rbf_value_final; 
       rbf_matrix_sum_final += rbf_value_final;
       allocation_sum_cpu += virtualMachineResources_1(column_count);
       allocation_sum_ram += virtualMachineResources_2(column_count);
       column_count++;
     endwhile
     rbf_matrix_average_final(row_count) =  rbf_matrix_sum_final/number_of_virtual_machines;  
     if(allocation_sum_cpu > 100 || allocation_sum_ram > 100)
        allocation_matrix_row_avg_1(row_count) =  100;
     end  
     if( global_best_final > rbf_matrix_average_final(row_count))
      global_best_final = rbf_matrix_average_final(row_count);
      finalAllocation = allocation_matrix_final(row_count,:);
     end
     row_count++;
   endwhile
   current_population_number++;
endwhile 

disp("Global Best");
disp(global_best_final);

disp("Final Allocation");
disp(finalAllocation);
 