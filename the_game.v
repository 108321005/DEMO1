module func_1hz(	//除頻器1hz更新用
	input CLK,
	input pause,
	output reg time_1hz);
	reg [24:0] count;
	always @(posedge CLK) begin
		if(count > 25000000) begin
			count <= 25'b0;
			time_1hz <= ~time_1hz;
		end
		else if(~pause)
			count <= count + 1'b1;
	end
endmodule

module func_4hz(	//除頻器4hz板子更新用
	input CLK,
	input pause,
	output reg time_4hz);
	reg [24:0] count;
	always @(posedge CLK) begin
		if(count > 6250000) begin
			count <= 25'b0;
			time_4hz <= ~time_4hz;
		end
		else if(~pause)
			count <= count + 1'b1;
	end
endmodule

module func_1000hz(	//除頻器1000hz背景更新用
	input CLK,
	output reg time_1000hz);
	reg [24:0] count;
	always @(posedge CLK) begin
		if(count > 50000) begin
			count <= 25'b0;
			time_1000hz <= ~time_1000hz;
		end
		else
			count <= count + 1'b1;
	end
endmodule

module the_game(
	input CLK,
	input stage_plus,	//關卡選擇
	input shoot,	//射擊按鈕
	input pause,	//暫停
	input plate_move_r,plate_move_l,	//左右移動
	output [7:0] LightR,	//輸出RGB
	output [7:0] LightG,
	output [7:0] LightB,
	output reg [2:0] chooseCol,	//選擇哪一排
	output enable	//enable固定1
	);
	integer stage;	//關卡
	integer ball_x,ball_y,plate_xl,move_mode,shoot_confirm,lose,tmp_x;	//球跟板子座標
	integer i;	//迴圈變數
	reg [7:0] LightR_reg [7:0];
	reg [7:0] LightG_reg [7:0];
	reg [7:0] LightB_reg [7:0];	//背景顯示用
	reg	[7:0] brickandball_pos [7:0];	//磚塊+球位置	

	assign enable = 1;	//enable
	assign LightR = LightR_reg[chooseCol];	//燈輸出	
	assign LightG = LightG_reg[chooseCol];
	assign LightB = LightB_reg[chooseCol];

	func_1000hz f0(CLK,time_1000hz);	//帶入function
	func_1hz f1(CLK,pause,time_1hz);
	func_4hz f2(CLK,pause,time_4hz);	

	initial
	begin
		stage = 0;
		chooseCol = 0;
		ball_x = 4;
		ball_y = 1;
		plate_xl = 3;
		move_mode = 0;
		shoot_confirm = 0;
		lose = 0;
	end

	always @(posedge time_1hz) begin 	//亮燈位置更新主程式
		LightB_reg[tmp_x][0] = 1 ;		//清除上次的位置	
		LightB_reg[tmp_x+1][0] = 1 ;			
		LightB_reg[tmp_x+2][0] = 1 ;
		LightG_reg[ball_x][ball_y] = 1 ;
		if (~pause) begin
			if (shoot_confirm == 0) begin
				if(stage_plus) begin
					stage = stage + 1;
					if (stage > 7) begin
						stage = 0;
					end
				end
				case(stage)
				0:
				begin
					LightR_reg[0] = 8'b11111111;
					LightR_reg[1] = 8'b11001111;
					LightR_reg[2] = 8'b10001111;
					LightR_reg[3] = 8'b10011111;
					LightR_reg[4] = 8'b10011111;
					LightR_reg[5] = 8'b10001111;
					LightR_reg[6] = 8'b11001111;
					LightR_reg[7] = 8'b11111111;

				end

				1:
				begin
					LightR_reg[0] = 8'b00001111;
					LightR_reg[1] = 8'b00001111;
					LightR_reg[2] = 8'b11001111;
					LightR_reg[3] = 8'b01111111;
					LightR_reg[4] = 8'b01111111;
					LightR_reg[5] = 8'b11001111;
					LightR_reg[6] = 8'b00001111;
					LightR_reg[7] = 8'b00001111;
	
				end
	
				2:
				begin
					LightR_reg[0] = 8'b00011111;
					LightR_reg[1] = 8'b00011111;
					LightR_reg[2] = 8'b00011111;
					LightR_reg[3] = 8'b00011111;
					LightR_reg[4] = 8'b00011111;
					LightR_reg[5] = 8'b00011111;
					LightR_reg[6] = 8'b00011111;
					LightR_reg[7] = 8'b00011111;
	
				end	
	
				3:	
				begin
					LightR_reg[0] = 8'b10111111;
					LightR_reg[1] = 8'b00111111;
					LightR_reg[2] = 8'b10001111;
					LightR_reg[3] = 8'b00101111;
					LightR_reg[4] = 8'b10001111;
					LightR_reg[5] = 8'b00101111;
					LightR_reg[6] = 8'b11001111;
					LightR_reg[7] = 8'b11101111;

				end

				4:
				begin
					LightR_reg[0] = 8'b11011111;
					LightR_reg[1] = 8'b00001111;
					LightR_reg[2] = 8'b01101111;
					LightR_reg[3] = 8'b00001111;
					LightR_reg[4] = 8'b10111111;
					LightR_reg[5] = 8'b00001111;
					LightR_reg[6] = 8'b11011111;
					LightR_reg[7] = 8'b00001111;
				end

				5:
				begin
					LightR_reg[0] = 8'b00001111;
					LightR_reg[1] = 8'b00001111;
					LightR_reg[2] = 8'b00001111;
					LightR_reg[3] = 8'b10001111;
					LightR_reg[4] = 8'b11001111;
					LightR_reg[5] = 8'b11101111;
					LightR_reg[6] = 8'b11111111;
					LightR_reg[7] = 8'b11111111;

				end

				6:
				begin
					LightR_reg[0] = 8'b01001111;
					LightR_reg[1] = 8'b00001111;
					LightR_reg[2] = 8'b10011111;
					LightR_reg[3] = 8'b00001111;
					LightR_reg[4] = 8'b00001111;
					LightR_reg[5] = 8'b10011111;
					LightR_reg[6] = 8'b00001111;
					LightR_reg[7] = 8'b00101111;

				end

				7:
				begin
					LightR_reg[0] = 8'b10111111;
					LightR_reg[1] = 8'b00011111;
					LightR_reg[2] = 8'b10001111;
					LightR_reg[3] = 8'b00011111;
					LightR_reg[4] = 8'b00011111;
					LightR_reg[5] = 8'b10001111;
					LightR_reg[6] = 8'b00011111;
					LightR_reg[7] = 8'b10111111;

				end
				endcase	
				for(i=0;i<8;i=i+1) begin
					LightG_reg[i] = LightR_reg[i];
					LightB_reg[i] = LightR_reg[i];
					brickandball_pos[i] = LightR_reg[i];
				end
			end 
		end
		if (~pause) begin 	//發射
			if(shoot) begin
				if(shoot_confirm == 0) begin
					move_mode = 0;
					shoot_confirm = 1;
				end
			end
		end
		if (~pause) begin 	//
			if (shoot_confirm == 1) begin
				case(move_mode)
				0:	//正上
				begin
					if (ball_y == 7) begin 	//撞到上面
						ball_y = ball_y - 1;
						move_mode = 1;	
					end
					else if (LightR_reg[ball_x][ball_y+1] == 0) begin 	//撞到上面的方塊
						LightR_reg[ball_x][ball_y+1] = 1;
						LightG_reg[ball_x][ball_y+1] = 1;
						LightB_reg[ball_x][ball_y+1] = 1;
						ball_y = ball_y - 1;
						move_mode = 1;
					end
					else begin 	//繼續往上
						ball_y = ball_y + 1;
					end
				end
				1:	//正下
				begin
					if (ball_y == 1) begin 	//如果在板子上一層
						if (plate_xl+1 == ball_x) begin 	//打到板子中間
							ball_y = ball_y + 1;
							move_mode = 0;
						end
						else if (plate_xl == ball_x) begin 	//打到板子左邊
							ball_x = ball_x - 1;
							ball_y = ball_y + 1;
							move_mode = 2;
						end
						else if (plate_xl+2 == ball_x) begin //打到板子右邊
							ball_x = ball_x + 1;
							ball_y = ball_y + 1;
							move_mode = 3;
						end
						else begin 	//輸了
							lose = 1;
						end
					end
					else if (LightR_reg[ball_x][ball_y-1] == 0) begin 	//打到方塊
						LightR_reg[ball_x][ball_y-1] = 1;
						LightG_reg[ball_x][ball_y-1] = 1;
						LightB_reg[ball_x][ball_y-1] = 1;
						ball_y = ball_y + 1;
						move_mode = 0;
					end
					else begin
						ball_y = ball_y - 1;
					end
				end
				2: 	//左上
				begin
					if (ball_y == 7) begin 	//上方牆壁
						if (ball_x == 0) begin 	//左邊牆壁
								ball_x = ball_x + 1;
								ball_y = ball_y - 1;
								move_mode = 5;
						end
						else begin 	//左方沒牆壁
							if (LightR_reg[ball_x-1][ball_y] == 0) begin 	//左邊有方塊
								LightR_reg[ball_x-1][ball_y] = 1;
								LightG_reg[ball_x-1][ball_y] = 1;
								LightB_reg[ball_x-1][ball_y] = 1;
								ball_x = ball_x + 1;
								ball_y = ball_y - 1;
								move_mode = 5;
							end
							else begin 	//左方沒方塊
								if (LightR_reg[ball_x-1][ball_y-1] == 0) begin 	//左下有方塊
									LightR_reg[ball_x-1][ball_y-1] = 1;
									LightG_reg[ball_x-1][ball_y-1] = 1;
									LightB_reg[ball_x-1][ball_y-1] = 1;
									ball_x = ball_x + 1;
									ball_y = ball_y - 1;
									move_mode = 5;
								end
								else begin //左下沒方塊
									ball_x = ball_x - 1;	
									ball_y = ball_y - 1;
									move_mode = 4;	
								end
							end
						end
					end
					else if (LightR_reg[ball_x][ball_y+1] == 0) begin 	//上方有方塊 沒牆壁
						LightR_reg[ball_x][ball_y+1] = 1;
						LightG_reg[ball_x][ball_y+1] = 1;
						LightB_reg[ball_x][ball_y+1] = 1;
						if (LightR_reg[ball_x-1][ball_y] == 0) begin 	//左方有方塊
							LightR_reg[ball_x-1][ball_y] = 1;
							LightG_reg[ball_x-1][ball_y] = 1;
							LightB_reg[ball_x-1][ball_y] = 1;
							ball_x = ball_x + 1;
							ball_y = ball_y - 1;
							move_mode = 5;
						end
						else begin 	//左方沒方塊
							if (LightR_reg[ball_x-1][ball_y-1] == 0) begin 	//左下有方塊
								LightR_reg[ball_x-1][ball_y-1] = 1;
								LightG_reg[ball_x-1][ball_y-1] = 1;
								LightB_reg[ball_x-1][ball_y-1] = 1;
								ball_x = ball_x + 1;
								ball_y = ball_y - 1;
								move_mode = 5;
							end
							else begin //左下沒方塊
								ball_x = ball_x - 1;
								ball_y = ball_y - 1;
								move_mode = 4;
							end
						end
					end
					else begin 	//上方沒方塊
						if (LightR_reg[ball_x-1][ball_y] == 0) begin //左方有方塊
							LightR_reg[ball_x-1][ball_y] = 1;
							LightG_reg[ball_x-1][ball_y] = 1;
							LightB_reg[ball_x-1][ball_y] = 1;
	
							if (LightR_reg[ball_x+1][ball_y+1] == 0) begin //右上有方塊
								LightR_reg[ball_x+1][ball_y+1] = 1;
								LightG_reg[ball_x+1][ball_y+1] = 1;
								LightB_reg[ball_x+1][ball_y+1] = 1;
								ball_x = ball_x + 1;
								ball_y = ball_y - 1;
								move_mode = 5;
							end
							else begin 	//右上沒方塊
								ball_x = ball_x + 1;
								ball_y = ball_y + 1;
								move_mode = 3;
							end
						end
						else begin//左方沒方塊
							if (LightR_reg[ball_x-1][ball_y+1] == 0) begin 	//左上有方塊
								LightR_reg[ball_x-1][ball_y+1] = 1;
								LightG_reg[ball_x-1][ball_y+1] = 1;
								LightB_reg[ball_x-1][ball_y+1] = 1;
								ball_x = ball_x + 1;
								ball_y = ball_y - 1;
								move_mode = 5;
							end	
							else begin 	//左上沒方塊
								ball_x = ball_x - 1;
								ball_y = ball_y + 1;
							end
						end	
					end
				end
				3:  //右上
				begin
					if (ball_y == 7) begin 	//上方牆壁
						if (ball_x == 7) begin 	//右方牆壁
								ball_x = ball_x - 1;
								ball_y = ball_y - 1;
								move_mode = 4;
						end
						else begin 	//右方沒牆壁
							if (LightR_reg[ball_x+1][ball_y] == 0) begin 	//右邊有方塊
								LightR_reg[ball_x+1][ball_y] = 1;
								LightG_reg[ball_x+1][ball_y] = 1;
								LightB_reg[ball_x+1][ball_y] = 1;
								ball_x = ball_x - 1;
								ball_y = ball_y - 1;
								move_mode = 4;
							end
							else begin 	//右方沒方塊
								if (LightR_reg[ball_x+1][ball_y-1] == 0) begin 	//右下有方塊
									LightR_reg[ball_x+1][ball_y-1] = 1;
									LightG_reg[ball_x+1][ball_y-1] = 1;
									LightB_reg[ball_x+1][ball_y-1] = 1;
									ball_x = ball_x - 1;
									ball_y = ball_y - 1;
									move_mode = 4;
								end
								else begin //右下沒方塊
									ball_x = ball_x + 1;	
									ball_y = ball_y - 1;
									move_mode = 5;	
								end
							end
						end
					end
					else if (LightR_reg[ball_x][ball_y+1] == 0) begin 	//上方有方塊 沒牆壁
						LightR_reg[ball_x][ball_y+1] = 1;
						LightG_reg[ball_x][ball_y+1] = 1;
						LightB_reg[ball_x][ball_y+1] = 1;
						if (LightR_reg[ball_x+1][ball_y] == 0) begin 	//右方有方塊
							LightR_reg[ball_x+1][ball_y] = 1;
							LightG_reg[ball_x+1][ball_y] = 1;
							LightB_reg[ball_x+1][ball_y] = 1;
							ball_x = ball_x - 1;
							ball_y = ball_y - 1;
							move_mode = 4;
						end
						else begin 	//左方沒方塊
							if (LightR_reg[ball_x+1][ball_y-1] == 0) begin 	//右下有方塊
								LightR_reg[ball_x+1][ball_y-1] = 1;
								LightG_reg[ball_x+1][ball_y-1] = 1;
								LightB_reg[ball_x+1][ball_y-1] = 1;
								ball_x = ball_x - 1;
								ball_y = ball_y - 1;
								move_mode = 4;
							end
							else begin //右下沒方塊
								ball_x = ball_x + 1;
								ball_y = ball_y - 1;
								move_mode = 5;
							end
						end
					end
					else begin 	//上方沒方塊
						if (LightR_reg[ball_x+1][ball_y] == 0) begin //右方有方塊
							LightR_reg[ball_x+1][ball_y] = 1;
							LightG_reg[ball_x+1][ball_y] = 1;
							LightB_reg[ball_x+1][ball_y] = 1;
	
							if (LightR_reg[ball_x-1][ball_y+1] == 0) begin //左上有方塊
								LightR_reg[ball_x-1][ball_y+1] = 1;
								LightG_reg[ball_x-1][ball_y+1] = 1;
								LightB_reg[ball_x-1][ball_y+1] = 1;
								ball_x = ball_x - 1;
								ball_y = ball_y - 1;
								move_mode = 4;
							end
							else begin 	//左上沒方塊
								ball_x = ball_x - 1;
								ball_y = ball_y + 1;
								move_mode = 2;
							end
						end
						else begin//右方沒方塊
							if (LightR_reg[ball_x+1][ball_y+1] == 0) begin 	//右上有方塊
								LightR_reg[ball_x+1][ball_y+1] = 1;
								LightG_reg[ball_x+1][ball_y+1] = 1;
								LightB_reg[ball_x+1][ball_y+1] = 1;
								ball_x = ball_x - 1;
								ball_y = ball_y - 1;
								move_mode = 4;
							end	
							else begin 	//右上沒方塊
								ball_x = ball_x + 1;
								ball_y = ball_y + 1;
							end
						end	
					end
				end
				4:  //左下
				begin
					if (ball_x == 0)
					begin
						ball_x = ball_x +1;
						ball_y = ball_y -1;
						move_mode = 4;
					end
					else
					begin
						ball_x = ball_x -1;
						ball_y = ball_y -1;	
					end
					if (ball_y == 1) begin 	//如果在板子上一層
						if (plate_xl+1 == ball_x) begin 	//打到板子中間
							ball_y = ball_y + 1;
							move_mode = 0;
						end
						else if (plate_xl == ball_x) begin 	//打到板子左邊
							ball_x = ball_x - 1;
							ball_y = ball_y + 1;
							move_mode = 2;
						end
						else if (plate_xl+2 == ball_x) begin //打到板子右邊
							ball_x = ball_x + 1;
							ball_y = ball_y + 1;
							move_mode = 3;
						end
						else begin 	//輸了
							lose = 1;
						end
					end
				end
				5: 	//右下
				begin
					if (ball_x == 7)
					begin
						ball_x = ball_x +1;
						ball_y = ball_y -1;
						move_mode = 4;
					end
					else
					begin
						ball_x = ball_x -1;
						ball_y = ball_y -1;	
					end
					if (ball_y == 1) begin 	//如果在板子上一層
						if (plate_xl+1 == ball_x) begin 	//打到板子中間
							ball_y = ball_y + 1;
							move_mode = 0;
						end
						else if (plate_xl == ball_x) begin 	//打到板子左邊
							ball_x = ball_x - 1;
							ball_y = ball_y + 1;
							move_mode = 2;
						end
						else if (plate_xl+2 == ball_x) begin //打到板子右邊
							ball_x = ball_x + 1;
							ball_y = ball_y + 1;
							move_mode = 3;
						end
						else begin 	//輸了
							lose = 1;
						end
					end
				end
				endcase
			end
		end
		tmp_x = plate_xl;
		LightB_reg[plate_xl][0] = 0 ;			
		LightB_reg[plate_xl+1][0] = 0 ;			
		LightB_reg[plate_xl+2][0] = 0 ;
		LightG_reg[ball_x][ball_y] = 0 ;
	end

	always @(posedge time_4hz) begin //板子移動
		if (plate_move_l) begin
			if(plate_xl > 0) begin
				plate_xl = plate_xl - 1;
			end
		end
		else if (plate_move_r) begin
			if(plate_xl < 5) begin
				plate_xl = plate_xl + 1;
			end
		end
	end

	always @(posedge time_1000hz) begin //排位更改
		chooseCol = chooseCol + 1;
		if(chooseCol > 7) begin
			chooseCol = 0;
		end

	end
endmodule

	