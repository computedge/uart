class driver;
	virtual uart_intf vif;

	function new(virtual uart_intf vif);
		this.vif =  vif;
	endfunction



	task reset_signals();
		vif.PSEL 	<= 0;
		vif.PENABLE 	<= 0;
		vif.PWRITE 	<= 0;
		vif.PADDR 	<= 0;
		vif.PWDATA 	<= 0;
	endtask


  	// Task write
  	task write(input logic [7:0] reg_addr, logic [7:0] wdata);
		@(vif.cb_drv);
		vif.cb_drv.PSEL 	<= 1;
		vif.cb_drv.PWRITE 	<= 1;
		vif.cb_drv.PADDR	<= reg_addr;
		vif.cb_drv.PWDATA	<= wdata;
		vif.cb_drv.PENABLE	<= 1;
		@(vif.cb_drv);
		vif.cb_drv.PSEL 	<= 0;
		vif.cb_drv.PENABLE	<= 0;
  	endtask

	// Task for reg read
	//task read(input logic [7:0] addr, output logic [7:0] rdata);
	task read(input logic [7:0] addr);
		@(vif.cb_drv);
		vif.cb_drv.PSEL 	<= 1;
		vif.cb_drv.PWRITE 	<= 0;
		vif.cb_drv.PADDR	<= addr;
		vif.cb_drv.PENABLE	<= 1;
		@(vif.cb_drv);
	//	rdata 			<= vif.PRDATA;
		vif.cb_drv.PSEL 	<= 0;
		vif.cb_drv.PENABLE	<= 0;
	endtask

endclass
