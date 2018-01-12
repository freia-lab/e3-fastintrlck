program copy_PMD

float pmd_buf[300000];
float pmds [16][300000];
int i, N=300000;
int startCp;
int sPMDon, sIndx, cIndx;
int cmdGet;

short working=0,  channel = 0;
short cChanSel;

assign startCp to "{p1}:PMD:cStartCp";
// assign cChanSel to "{p1}:PMD:cChanSel";
assign pmd_buf to "{p1}:PMD:sRdV";
assign pmds[0] to "{p1}:PMD-0";
assign pmds[1] to "{p1}:PMD-1";
assign pmds[2] to "{p1}:PMD-2";
assign pmds[3] to "{p1}:PMD-3";
assign pmds[4] to "{p1}:PMD-4";
assign pmds[5] to "{p1}:PMD-5";
assign pmds[6] to "{p1}:PMD-6";
assign pmds[7] to "{p1}:PMD-7";
assign pmds[8] to "{p1}:PMD-8";
assign pmds[9] to "{p1}:PMD-9";
assign pmds[10] to "{p1}:PMD-10";
assign pmds[11] to "{p1}:PMD-11";
assign pmds[12] to "{p1}:PMD-12";
assign pmds[13] to "{p1}:PMD-13";
assign pmds[14] to "{p1}:PMD-14";
assign pmds[15] to "{p1}:PMD-15";
assign sPMDon to "{p1}:PMD:sOn";
assign sIndx to "{p1}:PMD:sChan";
assign cIndx to "{p1}:PMD:cChan";
assign cmdGet to "{p1}:PMD:cmdGet";

monitor sIndx;
monitor sPMDon;
monitor cmdGet;
monitor startCp;

ss volt_check {
  state init {
//    printf ("In state init\n");
    when (pvConnectCount() == pvAssignCount()) {
      printf ("In state init - all pvs connected\n");
    } state blocked
    when (delay(5) || (pvConnectCount() != pvAssignCount())) {
    } state connect_timeout
  }

  state connect_timeout {
//    printf ("In state connect_timeout\n");
    when (delay (5)) {
      printf ("Leaving state connect_timeout\n");
    } state init
  }

  state iddle {
    entry { 
      printf ("Iddle...\n");
    }
    when (pvConnectCount() != pvAssignCount()) {} state init
    when (sPMDon) {} state blocked
    when (startCp || working) {} state next_channel
  }

  state blocked {
    entry { 
      printf ("PMD active\n");
    }
    when (!sPMDon) {
      printf ("PMD not active\n");
    } state iddle
  }

  state copy_data {
    entry {
      printf("Entered copy_data channel=%d, sIndx=%d\n", channel, sIndx);
//   x   pvGet(cChanSel, SYNC);
//   x   if (cChanSel & (1 << channel)) {
        pvGet(pmd_buf, SYNC);
        printf("Returned form pvGet in copy_data\n");
//   x   }
    }
//  x  when ((cChanSel & (1 << channel)) == 0) {} state next_channel
    when (channel == sIndx) {
    	for (i = 0; i < N; i++) pmds[channel][i] = pmd_buf[i];
        pvPut(pmds[channel]);
	startCp = 0;
	pvPut (startCp, SYNC);
        printf ("Copied buffer to pmds[%d]\n", channel);
    } state next_channel
  }

  state next_channel {
    entry {
      printf("Entered next_channel (%d)\n", channel);
      if (working) channel++;
      if (channel < 16) {
        working = 1;
      } else {
        working = 0;
	channel = 0;
      }
      cIndx = channel;
      pvPut(cIndx, SYNC);
      printf("Set new channel %d\n", channel);
      pvGet(cIndx);
    }
    when (pvConnectCount() != pvAssignCount()) {
      working = 0;
    } state init
    when (sPMDon || (working == 0)) {
      working = 0;
    } state blocked
// The delay is needed here, otherwice cRIO system hangs
    when ((channel == cIndx) && (working != 0) && delay(0.2))  {
      printf ("Going to get_buffer channel %d\n", cIndx);
    } state get_buffer
  }

  state get_buffer {
    entry {
      printf("Entered get_buffer (%d)\n", channel);
      cmdGet = 1;
      pvPut(cmdGet, SYNC);
      printf("Sent cmdGet for channel %d\n", channel);
   }
    when (pvConnectCount() != pvAssignCount()) {
      working = 0;
    } state init
    when (sPMDon || (working == 0)) {
      working = 0;
    } state blocked
    when ((channel == sIndx) && (cmdGet == 0) && (working != 0))  {
      printf ("Going to copy_data channel %d\n", sIndx);
    } state copy_data
  }
}
