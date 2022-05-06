program copy_PMD

float pmd_buf[300000];
float pmds [16][300000];
float pmds_dec [16][30000];
int i, N=300000, decim=10;
int startCp;
int sPMDon, sIndx, cIndx;
int cmdGet;
string seq_state;

short working=0,  channel = 0, busy = 0, trigSrc = 0;
short cSelChan;
short adcMask_1[16], adcMask_2[16], adcMask_3[16], adcMask_4[16];
short adcStat_1[16], adcStat_2[16], adcStat_3[16], adcStat_4[16];

assign busy to "{p1}:PMD:sBusy";
assign trigSrc to "{p1}:PMD:sTrigSrc";
assign seq_state to "{p1}:PMD:sCopySeq";
assign startCp to "{p1}:PMD:cStartCp";
assign cSelChan to "{p1}:PMD:cSelChan";
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

assign pmds_dec[0] to "{p1}:PMD-0:DEC";
assign pmds_dec[1] to "{p1}:PMD-1:DEC";
assign pmds_dec[2] to "{p1}:PMD-2:DEC";
assign pmds_dec[3] to "{p1}:PMD-3:DEC";
assign pmds_dec[4] to "{p1}:PMD-4:DEC";
assign pmds_dec[5] to "{p1}:PMD-5:DEC";
assign pmds_dec[6] to "{p1}:PMD-6:DEC";
assign pmds_dec[7] to "{p1}:PMD-7:DEC";
assign pmds_dec[8] to "{p1}:PMD-8:DEC";
assign pmds_dec[9] to "{p1}:PMD-9:DEC";
assign pmds_dec[10] to "{p1}:PMD-10:DEC";
assign pmds_dec[11] to "{p1}:PMD-11:DEC";
assign pmds_dec[12] to "{p1}:PMD-12:DEC";
assign pmds_dec[13] to "{p1}:PMD-13:DEC";
assign pmds_dec[14] to "{p1}:PMD-14:DEC";
assign pmds_dec[15] to "{p1}:PMD-15:DEC";

assign sPMDon to "{p1}:PMD:sOn";
assign sIndx to "{p1}:PMD:sChan";
assign cIndx to "{p1}:PMD:cChan";
assign cmdGet to "{p1}:PMD:cmdGet";
assign adcMask_1 to "{p1}:ADC:cMask-1";
assign adcStat_1 to "{p1}:ADC:sStatus-1";
assign adcMask_2 to "{p1}:ADC:cMask-2";
assign adcStat_2 to "{p1}:ADC:sStatus-2";
assign adcMask_3 to "{p1}:ADC:cMask-3";
assign adcStat_3 to "{p1}:ADC:sStatus-3";
assign adcMask_4 to "{p1}:ADC:cMask-4";
assign adcStat_4 to "{p1}:ADC:sStatus-4";

monitor sIndx;
monitor sPMDon;
monitor cmdGet;
monitor startCp;
monitor cSelChan;

ss cp_PMD {
  state init {
    entry {
      working = 0;
      channel = 0;
      sprintf (seq_state, "Init");
      pvPut (seq_state);
    }
    when (pvConnectCount() == pvAssignCount()) {
      printf ("In state init - all pvs connected\n");
    } state blocked
    when (delay(5) || (pvConnectCount() != pvAssignCount())) {
      cSelChan = 0;
    } state connect_timeout
  }

  state connect_timeout {
    entry {
      sprintf (seq_state, "Connect time-out");
      pvPut (seq_state);
      busy = FALSE;
      pvPut (busy);
    }
    when (pvConnectCount() == pvAssignCount()) {} state blocked
    when (delay (3600)) {
      printf ("Leaving state connect_timeout\n");
    } state init
  }

  state iddle {
    entry { 
      sprintf (seq_state, "Iddle");
      pvPut (seq_state);
      printf ("Iddle...\n");
    }
    when (pvConnectCount() != pvAssignCount()) {} state connect_timeout
    when (sPMDon) {} state blocked
    when (startCp || working) {
      if (working == 0) {
        startCp = 0;
        pvPut (startCp);
     	busy = TRUE;
      	pvPut (busy);
	pvGet (adcMask_1);
	pvGet (adcStat_1);
	pvGet (adcMask_2);
	pvGet (adcStat_2);
	pvGet (adcMask_3);
	pvGet (adcStat_3);
	pvGet (adcMask_4);
	pvGet (adcStat_4);
	trigSrc = 0;
	for (i=0; i < 16; i++) {
	  if (adcMask_1[i] & adcStat_1[i]) {
	    trigSrc = 1;
	    break;
	  }
	  else if (adcMask_2[i] & adcStat_2[i]) {
	    trigSrc = 2;
 	    break;
	  }
	  else if (adcMask_3[i] & adcStat_3[i]) {
	    trigSrc = 3;
	    break;
	  }
 	  else if (adcMask_4[i] & adcStat_4[i]) {
	     trigSrc = 4;
	    break;
	  }
	}
	pvPut (trigSrc);
      }
    } state next_channel
  }

  state blocked {
    entry { 
      sprintf (seq_state, "Blocked");
      pvPut (seq_state);
      printf ("PMD active\n");
      busy = FALSE;
      pvPut (busy);
    }
    when (pvConnectCount() != pvAssignCount()) { } state connect_timeout
    when (!sPMDon) {
      working = 0;
      channel = 0;
      printf ("PMD not active\n");
    } state iddle
  }

  state next_channel {
    entry {
      printf("Entered next_channel (%d)\n", channel);
      if (working)
        channel++;
      if (channel < 16) {
        working = 1;
      } else {
        working = 0;
	channel = 0;
        busy = FALSE;
        pvPut (busy);
      }
      if ((cSelChan & (1<<channel)) && working) {
        cIndx = channel;
      	pvPut(cIndx, SYNC);
      	printf("Set new channel %d\n", channel);
      	pvGet(cIndx);
      	pvGet(cSelChan);
        sprintf (seq_state, "Select channel %d", channel);
        pvPut (seq_state);
      }
    }
    when (((cSelChan & (1<<channel)) == 0) && working) {
      printf ("Channel %d skipped\n", channel);
    } state iddle
    when (pvConnectCount() != pvAssignCount()) { } state connect_timeout
    when (sPMDon || (working == 0)) { } state blocked
// !!!!!!!!! The delay is needed here, otherwise cRIO system hangs !!!!!!!!!!!!
    when ((channel == cIndx) && (working != 0) && delay(0.5))  {
      printf ("Going to get_buffer channel %d\n", cIndx);
    } state get_buffer
  }

  state get_buffer {
    entry {
      sprintf (seq_state, "Waiting for data...");
      pvPut (seq_state);
      printf("Entered get_buffer (%d)\n", channel);
      cmdGet = 1;
      pvPut(cmdGet, SYNC);
      printf("Sent cmdGet for channel %d\n", channel);
   }
    when (pvConnectCount() != pvAssignCount()) { } state connect_timeout
    when (sPMDon) { } state blocked
    when ((channel == sIndx) && (cmdGet == 0) && (working != 0))  {
      printf ("Going to copy_data channel %d\n", sIndx);
    } state copy_data
  }

  state copy_data {
    entry {
      sprintf (seq_state, "Copying chan. %d", channel);
      pvPut (seq_state);
      printf("Entered copy_data channel=%d, sIndx=%d\n", channel, sIndx);
      pvGet(pmd_buf, SYNC);
      printf("Returned form pvGet in copy_data\n");
    }
    when (pvConnectCount() != pvAssignCount()) { } state connect_timeout
    when (channel == sIndx) {
      for (i = 0; i < N; i++) { 
        pmds[channel][i] = pmd_buf[i];
	if ((i % decim) == 0) pmds_dec[channel][i/decim] = pmd_buf[i];
      }
      pvPut(pmds[channel]);
      pvPut(pmds_dec[channel]);
      printf ("Copied buffer to pmds[%d]\n", channel);
    } state next_channel
  }

}
