task run_test;

        begin
        #100;
        $display("=======================================================================================");
        $display("                        COUNTER CONTROL DIV VALUE CHECK                                ");
        $display("=======================================================================================");
        end


        $display("=======================================================================================");
        $display("                               FAIL CASE                                               ");
        $display("=======================================================================================");

        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0900); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0001); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0102); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0200); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0301); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0402); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0500); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0601); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0702); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0800); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0901); //pwrite,paddr,psel,penable,tim_wdata
    


        $display("=======================================================================================");
        $display("                                   SUCCESS CASE                                        ");
        $display("=======================================================================================");

        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0003); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0103); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0203); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0303); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0403); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0503); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0603); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0703); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0803); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0903); //pwrite,paddr,psel,penable,tim_wdata
        counter_control_div_val_check(1,12'h00,1,1,32'h0000_0x03); //pwrite,paddr,psel,penable,tim_wdata


endtask
