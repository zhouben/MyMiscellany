source ~/gdb_LWP2Num.py
source ~/gdb_HTag2SysTag.py
#set scheduler-locking on
#alias -a sl = set scheduler-locking
set confirm off
set auto-load safe-path /
set print pretty on

# after thread, print stack automatically
define hookpost-thread
bt
end

define sson
set scheduler-locking on
end
define ssoff
set scheduler-locking off
end

handle SIGUSR1 nostop
handle SIGUSR2 nostop


so /opt/work/victorzhang/flash.gdb

define comp_int
	set $dst = (int *)$arg0
	set $src = (int *)$arg1
	set $siz = $arg2
	set $i = 0
	set $cnt = 0
#	printf "dst %8X\n", $dst
#	printf "src %8X\n", $src
#	printf "siz %8d\n", $siz
    while $i < 8
  		if ( *(int  *)$dst != *(int *)$src)
			if $cnt == 0
			printf "%4s %10s%10s    %10s%10s\n", "Ofst", "Addr(A)", "Value(A)", "Value(B)", "Addr(B)"
			printf "----   --------  --------      --------  --------\n"
			end
			printf "%4d:%10X%10X != %10X%10X\n", $i, $dst, *(int *)$dst, *(int *)$src, $src
  			set $cnt = $cnt + 1
  		end
		set $i = $i + 1
  		set $dst = $dst + 1
  		set $src = $src + 1
  	end
  	if ($cnt == 0)
		printf "All %d 4-Byte are equal\n", $siz
	else
		printf "Total %d integer dismatched\n", $cnt
	end
	
end


define zth
	set $i = 0
	while $i < CPU_ID_MAX
		if (context_cpu.cpu[$i].running)
			printf "[%2d] thread 0x%lx, LWP %5d = cpu[%d] %-5s ", $LWP2Num(context_cpu.cpu[$i].tid), context_cpu.cpu[$i].thr, context_cpu.cpu[$i].tid, $i, context_cpu.cpu[$i].id_str
			output context_cpu.cpu[$i].id
			printf "\n"
		end
		set $i = $i + 1
	end
	if (context_encoder.thr)
		printf "[%2d] thread 0x%lx, LWP %5d = encoder\n", $LWP2Num(context_encoder.tid), context_encoder.thr, context_encoder.tid
	end
	if (context_decoder.thr)
		printf "[%2d] thread 0x%lx, LWP %5d = decoder\n", $LWP2Num(context_decoder.tid), context_decoder.thr, context_decoder.tid
	end
	if (context_hif.thr_hconn)
		printf "[%2d] thread 0x%lx, LWP %5d = hostconn\n", $LWP2Num(context_hostconn.tid), context_hif.thr_hconn, context_hostconn.tid
	end
	set $i = 0
	while $i < context_hostconn.max_connections
		if (context_hostconn.connection[$i].thr)
			printf "[%2d] thread 0x%lx, LWP %5d = hconn-recv[%d]\n", $LWP2Num(context_hostconn.connection[$i].tid), context_hostconn.connection[$i].thr, context_hostconn.connection[$i].tid, $i
		end
		set $i = $i + 1
	end
	if (context_hif.thr)
		printf "[%2d] thread 0x%lx, LWP %5d = hif\n", $LWP2Num(context_hif.tid), context_hif.thr, context_hif.tid
	end
	set $i = 0
	while $i < context_ehost.numhosts
		if (context_ehost.handle[$i].thr)
			printf "[%2d] thread 0x%lx, LWP %5d = ehost-recv[%d]\n", $LWP2Num(context_ehost.handle[$i].tid), context_ehost.handle[$i].thr, context_ehost.handle[$i].tid, $i
		end
		set $i = $i + 1
	end
	set $i = 0
	while $i < context_nandif.num_luns
		if (context_nandif.lun_ctrl[$i].thr)
			printf "[%2d] thread 0x%lx, LWP %5d = lun_ctrl[%d]\n", $LWP2Num(context_nandif.lun_ctrl[$i].tid), context_nandif.lun_ctrl[$i].thr, context_nandif.lun_ctrl[$i].tid, $i
		end
		set $i = $i + 1
	end
#	if (context_nandif.thr_xfer_mon)
#		printf "[%2d] thread 0x%lx, LWP %5d = NAND XFER monitor\n", $LWP2Num(context_nandif.tid_xfer_mon), context_nandif.thr_xfer_mon, context_nandif.tid_xfer_mon
#	end
	if (context_uart.thr)
		printf "[%2d] thread 0x%lx, LWP %5d = uart\n", $LWP2Num(context_uart.tid), context_uart.thr, context_uart.tid
	end
	if (context_ehcmd.completionThread)
		printf "[%2s] thread 0x%lx, LWP N/A   = ehcmd\n", "", context_ehcmd.completionThread
	end
	printf "[%2d] main thread      , LWP %d = main\n", $LWP2Num(context_emulator.progtid), context_emulator.progtid
end


define zhtags
	set $i = 0
	set $j = $HTag2SysTag(0, 1)
	while $i < (256+1)
		if (1 == gHdpContext.hosttagTable[$i].isAllocated)
			printf "HTAG[%3d]: QID = %2d, OpCode = %2X, ", $i, gHdpContext.hosttagTable[$i].queueId, gHdpContext.hosttagTable[$i].opCode
			printf "NLB(Done) = %4d(%4d), state = ", gHdpContext.hosttagTable[$i].noOfSystags, gHdpContext.hosttagTable[$i].totalLbCount
			output gHdpContext.hosttagTable[$i].state
			printf "\n"
			set $s = $HTag2SysTag($i)
			while $s > 0
				printf "  SYSTAG[%4d]: CURLBA = %8d, state = ", $s, gHdpContext.systagTable[$s].curLba
				output gHdpContext.systagTable[$s].state
				printf "\n"
				set $s = $HTag2SysTag($i)
			end
		end
		set $i = $i + 1
	end
end

# show global status registeR
define gs
	printf "HFC = 0x%x\n", context_globalstat.rawHfc
	if (context_globalstat.rawHfc & 0x00000001)
		printf "%-20s- %s\n", "\t HFC_MBOX_NEMPTY", "!! HFC_MBOX_0~8 might need to be handled"
#		printf "\t HFC_MBOX_NEMPTY\n"
	end
	if (context_globalstat.rawHfc & 0x00000002)
#printf "\t CMD_FTCH_Q\n"
		printf "%-20s- %s\n", "\t CMD_FETCH_Q", "   idle, enough for FW to use"
	else
		printf "%-20s- %s\n", "\t CMD_FETCH_Q", "!! NOT enough for FW to use"
	end
	if (context_globalstat.rawHfc & 0x00000004)
#printf "\t BRDG_CMD_Q\n"
		printf "%-20s- %s\n", "\t BRDG_CMD_Q", "   obsolete"
	end
	if (context_globalstat.rawHfc & 0x00000008)
#		printf "\t RD_XFER_Q\n"
		printf "%-20s- %s\n", "\t RD_XFER_Q", "   idle"
	end
	if (context_globalstat.rawHfc & 0x00000010)
#		printf "\t WR_XFER_Q\n"
		printf "%-20s- %s\n", "\t WR_XFER_Q", "   idle"
	end
	if (context_globalstat.rawHfc & 0x00000020)
#		printf "\t RD_DSCPTR_Q\n"
		printf "%-20s- %s\n", "\t RD_DSCPTR_Q", "   idle"
	end
	if (context_globalstat.rawHfc & 0x00000040)
#		printf "\t WR_DSCPTR_Q\n"
		printf "%-20s- %s\n", "\t WR_DSCPTR_Q", "   idle"
	end
	if (context_globalstat.rawHfc & 0x00000080)
#		printf "\t CMD_COMPLT_Q\n"
		printf "%-20s- %s\n", "\t CMD_COMPLT_Q", "   idle"
	end
	if (context_globalstat.rawHfc & 0x00000100)
		printf "\t NBC_MBOX_NEMPTY\n"
	end
	if (context_globalstat.rawHfc & 0x00000200)
		printf "\t NBC_MBOX_1\n"
	end
	if (context_globalstat.rawHfc & 0x00000400)
		printf "%-20s- %s\n", "\t NBC_MBOX_0", "!! FW(Hdp) Hdp_FtlStatusProcess should handle it"
# 		printf "\t NBC_MBOX_0\n"
	end
	if (context_globalstat.rawHfc & 0x00000800)
		printf "\t HFC_MBOX_8\n"
	end
	if (context_globalstat.rawHfc & 0x00001000)
		printf "\t HFC_MBOX_7\n"
	end
	if (context_globalstat.rawHfc & 0x00002000)
		printf "\t HFC_MBOX_6\n"
	end
	if (context_globalstat.rawHfc & 0x00004000)
		printf "\t HFC_MBOX_5\n"
	end
	if (context_globalstat.rawHfc & 0x00008000)
		printf "\t HFC_MBOX_4\n"
	end
	if (context_globalstat.rawHfc & 0x00010000)
		printf "%-20s- %s\n", "\t HFC_MBOX_3", "!! FW(Hdp) should handle a mail from Dxfer"
	end
	if (context_globalstat.rawHfc & 0x00020000)
		printf "\t HFC_MBOX_2\n"
	end
	if (context_globalstat.rawHfc & 0x00040000)
		printf "%-20s- %s\n", "\t HFC_MBOX_1", "!! FW(Happ) should handle a mail from Hdp"
#		printf "\t HFC_MBOX_1\n"
	end
	if (context_globalstat.rawHfc & 0x00080000)
		printf "\t HFC_MBOX_0\n"
	end
	if (context_globalstat.rawHfc & 0x00100000)
		printf "\t CQ_DOORBELL\n"
	end
	if (context_globalstat.rawHfc & 0x00200000)
		printf "%-20s- %s\n", "\t SQ_DOORBELL", "!! FW should fetch new cmd."
	end
	if (context_globalstat.rawHfc & 0x00400000)
		printf "%-20s- %s\n", "\t CMD_TAG_ACTV", "!! FW(Dxfer) should handle it"
	end
	if (context_globalstat.rawHfc & 0x00800000)
		printf "%-20s- %s\n", "\t NEW_CMD_TAG", "!! FW(Hdp) should handle it"
	end
	if (context_globalstat.rawHfc & 0x01000000)
		printf "\t BRDG_MSG_STATUS\n"
	end
	if (context_globalstat.rawHfc & 0x02000000)
		printf "\t BRDG_STATUS\n"
	end
	if (context_globalstat.rawHfc & 0x04000000)
		printf "\t CMD_FETCH_STATUS\n"
	end
	if (context_globalstat.rawHfc & 0x08000000)
		printf "\t RD_XFER_STATUS\n"
	end
	if (context_globalstat.rawHfc & 0x10000000)
		printf "\t RD_DSCPTR_DONE\n"
	end
	if (context_globalstat.rawHfc & 0x20000000)
		printf "%-20s- %s\n", "\t WR_DSCPTR_DONE", "!! FW(Dxfer) should handle it"
	end
	if (context_globalstat.rawHfc & 0x40000000)
		printf "\t BM_LO_THRESHOLD\n"
	end
	if (context_globalstat.rawHfc & 0x80000000)
		printf "\t BM_HI_THRESHOLD\n"
	end
	printf "NBC = 0x%x\n", context_globalstat.rawNbc
	if (context_globalstat.rawNbc & 0x00000001)
		printf "\t NBC_MBOX_NEMPTY\n"
	end
	if (context_globalstat.rawNbc & 0x00000020)
		printf "\t NBC_LBA_TBL_STSQ\n"
	end
	if (context_globalstat.rawNbc & 0x00000400)
		printf "\t NBC_MBOX_2\n"
	end
	if (context_globalstat.rawNbc & 0x00000800)
		printf "\t NAND_XFER_Q\n"
	end
	if (context_globalstat.rawNbc & 0x00001000)
		printf "\t DEC_RTRYQ\n"
	end
	if (context_globalstat.rawNbc & 0x00002000)
		printf "\t DEC_CMDQ\n"
	end
	if (context_globalstat.rawNbc & 0x00004000)
		printf "\t ENC_CMDQ\n"
	end
	if (context_globalstat.rawNbc & 0x00008000)
		printf "\t NBC_MBOX_12\n"
	end
	if (context_globalstat.rawNbc & 0x00010000)
		printf "\t NBC_MBOX_11\n"
	end
	if (context_globalstat.rawNbc & 0x00020000)
		printf "\t NBC_MBOX_10\n"
	end
	if (context_globalstat.rawNbc & 0x00040000)
		printf "\t NBC_MBOX_9\n"
	end
	if (context_globalstat.rawNbc & 0x00080000)
		printf "\t NBC_MBOX_8\n"
	end
	if (context_globalstat.rawNbc & 0x00100000)
		printf "\t NBC_MBOX_7\n"
	end
	if (context_globalstat.rawNbc & 0x00200000)
		printf "\t NBC_MBOX_6\n"
	end
	if (context_globalstat.rawNbc & 0x00400000)
		printf "\t NBC_MBOX_5\n"
	end
	if (context_globalstat.rawNbc & 0x00800000)
		printf "\t NBC_MBOX_4\n"
	end
	if (context_globalstat.rawNbc & 0x01000000)
		printf "\t NBC_MBOX_3\n"
	end
	if (context_globalstat.rawNbc & 0x02000000)
		printf "\t WR_XFER_STSQ\n"
	end
	if (context_globalstat.rawNbc & 0x04000000)
		printf "\t NAND_SCND_STSQ\n"
	end
	if (context_globalstat.rawNbc & 0x08000000)
		printf "\t NAND_STSQ\n"
	end
	if (context_globalstat.rawNbc & 0x10000000)
		printf "\t DEC_STSQ\n"
	end
	if (context_globalstat.rawNbc & 0x20000000)
		printf "\t ENC_STSQ\n"
	end
	if (context_globalstat.rawNbc & 0x40000000)
		printf "\t PWR_EXECPTION\n"
	end
	if (context_globalstat.rawNbc & 0x80000000)
		printf "\t ERR_EXECPTION\n"
	end
end

# show ehcmd
define showehcmd
printf "context_ehcmd\n----------------\n"
printf "sendCmdCount    : "
output  context_ehcmd.sendCmdCount
printf "\n"
printf "compCmdCount    : "
output  context_ehcmd.compCmdCount
printf "\n"
printf "pendingCmdCount : "
output  context_ehcmd.pendingCmdCount
printf "\n----------------\n"
printf "msixVectors     : "
output  msixVectors
printf "\n"
end

# context_hif.stats_cmdfetch

# parse stuff related to FIFO
#
define fifodir2str
	set $dir = $arg0
	if ($dir == 1)
		printf " F -> H "
	end
	if ($dir == 2)
		printf " H -> F "
	end
	if ($dir == 3)
		printf " H -> H "
	end
	if ($dir == 4)
		printf "   --   "
	end
end
define pfifoabbr
	set $fifoid = $arg0
	printf "%3d%10d%10d%8d", $fifoid, fifo_table[$fifoid]->npush, fifo_table[$fifoid]->npop, fifo_table[$fifoid]->nreset
	if (fifo_table[$fifoid]->pRead != fifo_table[$fifoid]->pWrite)
		printf "%8d%8d", fifo_table[$fifoid]->pWrite, fifo_table[$fifoid]->pRead
#printf " F -> H"
		fifodir2str  fifo_table[$fifoid]->direction
	else
		printf "%24s", " "
	end
	output (enum FIFO_ID)$fifoid
	printf "\n"
end


define fp
	set $i = 0
	printf "%3s%10s%10s%8s%8s%8s%5s%20s\n", "ID", "npush", "npop", "nreset", "write", "read", "dir", "fifo name"
	while $i < FIFO_ID_MAX
		if ((fifo_table[$i]) && (fifo_table[$i]->npush && (fifo_table[$i]->pWrite != fifo_table[$i]->pRead)))
			pfifoabbr $i
		end
		set $i = $i + 1
	end
end

define fs
	set $i = 0
	printf "%3s%10s%10s%8s%8s%8s%8s%20s\n", "ID", "npush", "npop", "nreset", "write", "read", "dir  ", "fifo name"
	while $i < FIFO_ID_MAX
		if ((fifo_table[$i]) && (fifo_table[$i]->npush || (fifo_table[$i]->pWrite != fifo_table[$i]->pRead)))
			pfifoabbr $i
		end
		set $i = $i + 1
	end
end

define tlp
	print/x *(PCIE_TLP*)$arg0
end
define ff
	set $fn = $arg0
	printf "%-10s = %2d ", "fifo_id", fifo_table[$fn].fifo_id
	output (enum FIFO_ID)$fn
	printf "\n"
	printf "%-10s = %d\n"  , "capacity", fifo_table[$fn].capacity
	printf "%-10s = 0x%-8X\n", "entries", fifo_table[$fn].entries
	printf "%-10s = %-3d bytes\n"   , "entry_size", fifo_table[$fn].entry_size
	printf "%-10s = 0x%-4X [ 0x%08X ]\n", "pRead"  , fifo_table[$fn].pRead, fifo_table[$fn].entries + fifo_table[$fn].pRead * fifo_table[$fn].entry_size
	printf "%-10s = 0x%-4X [ 0x%08X ]\n", "pWrite" , fifo_table[$fn].pWrite,fifo_table[$fn].entries + fifo_table[$fn].pWrite* fifo_table[$fn].entry_size
	printf "%-10s = ", "Dir"
	output (enum FIFO_DIR)fifo_table[$fn].direction
	printf "\n"
end


define zmbox
	set $i = 0

	printf "            head tail_p tail_c     sent dw/entry   Name\n" 
	printf "           [     IN UNIT OF DWORD     ]\n"
	while $i < MAILBOX_HFC_ID_UNUSED
		if (context_mailbox.hfc[$i].sent)
			printf "HFC[%2d] : %6d %6d %6d %8d %8d   ", $i, context_mailbox.hfc[$i].realhead.idx, context_mailbox.hfc[$i].realtail_p.idx, context_mailbox.hfc[$i].realtail_c.idx, context_mailbox.hfc[$i].sent, gMailboxAttribsHfc[$i].mesg_size_dw
#printf "HFC[%2d] : head=%3d, tail=%3d, sent=%8d, ", $i, context_mailbox.hfc[$i].head, context_mailbox.hfc[$i].realtail_p, context_mailbox.hfc[$i].sent
			output (enum MAILBOX_HFC_ID)$i
			printf "\n"
		end
		set $i = $i + 1
	end
	set $i = 0
	while $i < MAILBOX_NBC_ID_MAX
		if (context_mailbox.nbc[$i].sent)
			printf "NBC[%2d] : %6d %6d %6d %8d %8d   ", $i, context_mailbox.nbc[$i].realhead.idx, context_mailbox.nbc[$i].realtail_p.idx, context_mailbox.nbc[$i].realtail_c.idx, context_mailbox.nbc[$i].sent, gMailboxAttribsNbc[$i].mesg_size_dw
#			printf "NBC[%2d] : head=%3d, tail=%3d, sent=%8d, ", $i, context_mailbox.nbc[$i].head, context_mailbox.nbc[$i].tail_c, context_mailbox.nbc[$i].sent
			output (enum MAILBOX_NBC_ID)$i
			printf "\n"
		end
		set $i = $i + 1
	end
end

define showmboxhfc
	set $mboxid = $arg0
	set $i = $arg1
	set $mboxentrynum = $arg2
	set $mboxentryend = $i + $mboxentrynum
	if $mboxid >= MAILBOX_HFC_ID_UNUSED
		printf "mbox id is out of range!\n"
		return
	end
	
	while $i < $mboxentryend
		printf "Entry %3d\n------------------\n", $i
		set $addr = (gMailboxAttribsHfc[$mboxid].start_addr + ($i * gMailboxAttribsHfc[$mboxid].mesg_size_dw * 4))
		if ($mboxid == MAILBOX_HFC_DXFER2HDP_WRRDY)
			print/x *(MBOX_DXFER2HDP_WRRDY_ENTRY *)$addr
		end
		if ($mboxid == MAILBOX_HFC_HDP2DXFER_GENERAL)
			print/x *(MBOX_DXFER2HDP_WRRDY_ENTRY *)$addr
		end
		if ($mboxid == MAILBOX_HFC_DXFER2HDP_GENERAL)
			print/x *(MBOX_DXFER2HDP_GENERAL_ENTRY *)$addr
		end
		set $i = $i + 1
	end
end


define zshowhelp
	printf "zmbox       : show all mboxs with sent not 0\n"
	printf "zth         : show named thread IDs \n"
	printf "zhtags      : show all active host tags \n"
	printf "gs          : show each bit of global status\n"
	printf "fs          : show all fifo statistics\n"
	printf "fp          : show all pending fifo statistics\n"
	printf "ff <arg>    : show a fifo specified by <arg>\n"
	printf "tlp <arg>   : show a <arg> pointer to a PCIE_TLP\n"
	printf "showehcmd   : show ehcmd\n"
	printf "showmboxhfc : show mbox entry, with three param, mboxid mboxentry_idx mboxentry_num\n"
	printf "comp_int    : compare ptr1(arg0) and ptr2(arg1) with size(unit of integer) (arg2)\n"
end
