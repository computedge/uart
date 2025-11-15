class apb_transaction;

	rand bit write;
	rand bit [7:0] paddr;
	rand bit [7:0] pdata;


	function new (bit write = 0, bit [7:0] paddr = 0, bit [7:0] pdata = 0);
		this.write = write;
		this.paddr = paddr;
		this.pdata = pdata;
	endfunction


	function void display(string tag = "");
		$display ("[%s] APB TXN :: WRITE=%0b ADDR=0x%0h DATA=0x%0h", tag,write,paddr,pdata);
	endfunction

	function void message_display(string msg = "");
		$display ("%s", msg);
	endfunction
endclass
