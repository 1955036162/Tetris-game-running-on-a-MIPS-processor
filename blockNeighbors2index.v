module blockNeighbors2index(
    input  [4:0]  index_i, index_j,
    input  [11:0] blockNeighbors,
    output [4:0]  neighbor1_i, neighbor1_j, neighbor2_i, neighbor2_j, 
    output [4:0]  neighbor3_i, neighbor3_j
    );

