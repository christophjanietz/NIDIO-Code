/*=============================================================================* 
* RECODING - land to wregion
*==============================================================================*
 	Project: NIDIO
	Author: Christoph Janietz
	Last update: 30-10-2024
	
	Crosswalk between country codes and NIDIO world region
	
* ----------------------------------------------------------------------------*/

gen wregion=.
recast byte wregion

replace wregion = . if land == "----"	
replace wregion = . if land == "0000"	
replace wregion = 1 if land == "1234"
replace wregion = 1 if land == "5001"
replace wregion = 1 if land == "5002"
replace wregion = 1 if land == "5003"
replace wregion = 4 if land == "5004"
replace wregion = 4 if land == "5005"
replace wregion = 5 if land == "5006"
replace wregion = 5 if land == "5007"
replace wregion = 3 if land == "5008"
replace wregion = 1 if land == "5009"
replace wregion = 1 if land == "5010"
replace wregion = 4 if land == "5011"
replace wregion = 3 if land == "5012"
replace wregion = 1 if land == "5013"
replace wregion = 4 if land == "5014"
replace wregion = 1 if land == "5015"
replace wregion = 3 if land == "5016"
replace wregion = 1 if land == "5017"
replace wregion = 3 if land == "5018"
replace wregion = 4 if land == "5019"
replace wregion = 4 if land == "5020"
replace wregion = 5 if land == "5021"
replace wregion = 3 if land == "5022"
replace wregion = 4 if land == "5023"
replace wregion = 4 if land == "5024"
replace wregion = 2 if land == "5025"
replace wregion = 4 if land == "5026"
replace wregion = 2 if land == "5027"
replace wregion = 4 if land == "5028"
replace wregion = 4 if land == "5029"
replace wregion = 4 if land == "5030"
replace wregion = 2 if land == "5031"
replace wregion = 1 if land == "5032"
replace wregion = 5 if land == "5033"
replace wregion = 1 if land == "5034"
replace wregion = 4 if land == "5035"
replace wregion = 2 if land == "5036"
replace wregion = 2 if land == "5037"
replace wregion = 5 if land == "5038"
replace wregion = 1 if land == "5039"
replace wregion = 1 if land == "5040"
replace wregion = 2 if land == "5041"
replace wregion = 2 if land == "5042"
replace wregion = 3 if land == "5043"
replace wregion = 4 if land == "5044"
replace wregion = 1 if land == "5045"
replace wregion = 2 if land == "5046"
replace wregion = 2 if land == "5047"
replace wregion = 3 if land == "5048"
replace wregion = 1 if land == "5049"
replace wregion = 4 if land == "5050"
replace wregion = 1 if land == "5051"
replace wregion = 2 if land == "5052"
replace wregion = 1 if land == "5053"
replace wregion = 3 if land == "5054"
replace wregion = 4 if land == "5055"
replace wregion = 1 if land == "5056"
replace wregion = 3 if land == "5057"
replace wregion = 5 if land == "5059"
replace wregion = 4 if land == "5060"
replace wregion = 5 if land == "5061"
replace wregion = 5 if land == "5062"
replace wregion = 4 if land == "5063"
replace wregion = 2 if land == "5064"
replace wregion = 1 if land == "5065"
replace wregion = 5 if land == "5066"
replace wregion = 4 if land == "5067"
replace wregion = 2 if land == "5068"
replace wregion = 5 if land == "5069"
replace wregion = 4 if land == "5070"
replace wregion = 2 if land == "5071"
replace wregion = 4 if land == "5072"
replace wregion = 4 if land == "5073"
replace wregion = 1 if land == "5074"
replace wregion = 4 if land == "5075"
replace wregion = 2 if land == "5076"
replace wregion = 2 if land == "5077"
replace wregion = 4 if land == "5078"
replace wregion = 2 if land == "5079"
replace wregion = 2 if land == "5080"
replace wregion = 2 if land == "5081"
replace wregion = 2 if land == "5082"
replace wregion = 2 if land == "5083"
replace wregion = 4 if land == "5084"
replace wregion = 2 if land == "5085"
replace wregion = 2 if land == "5086"
replace wregion = 2 if land == "5087"
replace wregion = 2 if land == "5088"
replace wregion = 2 if land == "5089"
replace wregion = 2 if land == "5090"
replace wregion = 2 if land == "5091"
replace wregion = 5 if land == "5092"
replace wregion = 1 if land == "5093"
replace wregion = 2 if land == "5094"
replace wregion = 5 if land == "5095"
replace wregion = 4 if land == "5096"
replace wregion = 3 if land == "5097"
replace wregion = 1 if land == "5098"
replace wregion = 2 if land == "5099"
replace wregion = 1 if land == "5100"
replace wregion = 2 if land == "5101"
replace wregion = 1 if land == "5102"
replace wregion = 1 if land == "5103"
replace wregion = 1 if land == "5104"
replace wregion = 1 if land == "5105"
replace wregion = 5 if land == "5106"
replace wregion = 5 if land == "5107"
replace wregion = 5 if land == "5108"
replace wregion = 5 if land == "5109"
replace wregion = 5 if land == "5110"
replace wregion = 4 if land == "5111"
replace wregion = 3 if land == "5112"
replace wregion = 1 if land == "5113"
replace wregion = 1 if land == "6000"
replace wregion = 4 if land == "6001"
replace wregion = 1 if land == "6002"
replace wregion = 1 if land == "6003"
replace wregion = 5 if land == "6004"
replace wregion = 4 if land == "6005"
replace wregion = 3 if land == "6006"
replace wregion = 1 if land == "6007"
replace wregion = 5 if land == "6008"
replace wregion = 4 if land == "6009"
replace wregion = 5 if land == "6010"
replace wregion = 1 if land == "6011"
replace wregion = 1 if land == "6012"
replace wregion = 4 if land == "6013"
replace wregion = 1 if land == "6014"
replace wregion = 5 if land == "6015"
replace wregion = 1 if land == "6016"
replace wregion = 5 if land == "6017"
replace wregion = 1 if land == "6018"
replace wregion = 4 if land == "6019"
replace wregion = 4 if land == "6020"
replace wregion = 2 if land == "6021"
replace wregion = 2 if land == "6022"
replace wregion = 3 if land == "6023"
replace wregion = 2 if land == "6024"
replace wregion = 5 if land == "6025"
replace wregion = 2 if land == "6026"
replace wregion = 1 if land == "6027"
replace wregion = 1 if land == "6028"
replace wregion = 1 if land == "6029"
replace wregion = 1 if land == "6030"
replace wregion = 2 if land == "6031"
replace wregion = 2 if land == "6032"
replace wregion = 5 if land == "6033"
replace wregion = 3 if land == "6034"
replace wregion = 2 if land == "6035"
replace wregion = 2 if land == "6036"
replace wregion = 1 if land == "6037"
replace wregion = 1 if land == "6038"
replace wregion = 1 if land == "6039"
replace wregion = 4 if land == "6040"
replace wregion = 5 if land == "6041"
replace wregion = 3 if land == "6042"
replace wregion = 3 if land == "6043"
replace wregion = 5 if land == "6044"
replace wregion = 1 if land == "6045"
replace wregion = 4 if land == "6046"
replace wregion = 3 if land == "6047"
replace wregion = 4 if land == "6048"
replace wregion = 2 if land == "6049"
replace wregion = 2 if land == "6050"
replace wregion = 4 if land == "6051"
replace wregion = 5 if land == "6052"
replace wregion = 1 if land == "6053"
replace wregion = 2 if land == "6054"
replace wregion = 1 if land == "6055"
replace wregion = 2 if land == "6056"
replace wregion = 2 if land == "6057"
replace wregion = 2 if land == "6058"
replace wregion = 4 if land == "6059"
replace wregion = 4 if land == "6060"
replace wregion = 4 if land == "6061"
replace wregion = 2 if land == "6062"
replace wregion = 2 if land == "6063"
replace wregion = 3 if land == "6064"
replace wregion = 1 if land == "6065"
replace wregion = 1 if land == "6066"
replace wregion = 1 if land == "6067"
replace wregion = 1 if land == "6068"
replace wregion = 4 if land == "6069"
replace wregion = 4 if land == "7001"
replace wregion = 4 if land == "7002"
replace wregion = 1 if land == "7003"
replace wregion = 5 if land == "7004"
replace wregion = 1 if land == "7005"
replace wregion = 5 if land == "7006"
replace wregion = 5 if land == "7007"
replace wregion = 4 if land == "7008"
replace wregion = 3 if land == "7009"
replace wregion = 5 if land == "7011"
replace wregion = 3 if land == "7012"
replace wregion = 3 if land == "7014"
replace wregion = 5 if land == "7015"
replace wregion = 4 if land == "7016"
replace wregion = 5 if land == "7017"
replace wregion = 5 if land == "7018"
replace wregion = 3 if land == "7020"
replace wregion = 4 if land == "7021"
replace wregion = 4 if land == "7023"
replace wregion = 1 if land == "7024"
replace wregion = 2 if land == "7026"
replace wregion = 5 if land == "7027"
replace wregion = 1 if land == "7028"
replace wregion = 1 if land == "7029"
replace wregion = 5 if land == "7030"
replace wregion = 4 if land == "7031"
replace wregion = 5 if land == "7032"
replace wregion = 2 if land == "7033"
replace wregion = 4 if land == "7034"
replace wregion = 2 if land == "7035"
replace wregion = 2 if land == "7036"
replace wregion = 5 if land == "7037"
replace wregion = 5 if land == "7038"
replace wregion = 5 if land == "7039"
replace wregion = 4 if land == "7040"
replace wregion = 2 if land == "7041"
replace wregion = 2 if land == "7042"
replace wregion = 3 if land == "7043"
replace wregion = 1 if land == "7044"
replace wregion = 3 if land == "7045"
replace wregion = 2 if land == "7046"
replace wregion = 1 if land == "7047"
replace wregion = 1 if land == "7048"
replace wregion = 5 if land == "7049"
replace wregion = 1 if land == "7050"
replace wregion = 3 if land == "7051"
replace wregion = 2 if land == "7052"
replace wregion = 2 if land == "7053"
replace wregion = 3 if land == "7054"
replace wregion = 2 if land == "7055"
replace wregion = 2 if land == "7057"
replace wregion = 2 if land == "7058"
replace wregion = 4 if land == "7059"
replace wregion = 3 if land == "7060"
replace wregion = 5 if land == "7062"
replace wregion = 4 if land == "7063"
replace wregion = 1 if land == "7064"
replace wregion = 1 if land == "7065"
replace wregion = 1 if land == "7066"
replace wregion = 4 if land == "7067"
replace wregion = 4 if land == "7068"
replace wregion = 2 if land == "7070"
replace wregion = 4 if land == "7071"
replace wregion = 4 if land == "7072"
replace wregion = 1 if land == "7073"
replace wregion = 2 if land == "7074"
replace wregion = 2 if land == "7075"
replace wregion = 4 if land == "7076"
replace wregion = 3 if land == "7077"
replace wregion = 4 if land == "7079"
replace wregion = 2 if land == "7080"
replace wregion = 4 if land == "7082"
replace wregion = 2 if land == "7083"
replace wregion = 2 if land == "7084"
replace wregion = 1 if land == "7085"
replace wregion = 1 if land == "7087"
replace wregion = 5 if land == "7088"
replace wregion = 2 if land == "7089"
replace wregion = 3 if land == "7091"
replace wregion = 5 if land == "7092"
replace wregion = 5 if land == "7093"
replace wregion = 5 if land == "7094"
replace wregion = 4 if land == "7095"
replace wregion = 4 if land == "7096"
replace wregion = 2 if land == "7097"
replace wregion = 2 if land == "7098"
replace wregion = 2 if land == "7099"
replace wregion = 1 if land == "8000"
replace wregion = 2 if land == "8001"
replace wregion = 2 if land == "8002"
replace wregion = 2 if land == "8003"
replace wregion = 2 if land == "8004"
replace wregion = 2 if land == "8005"
replace wregion = 2 if land == "8006"
replace wregion = 5 if land == "8008"
replace wregion = 2 if land == "8009"
replace wregion = 4 if land == "8010"
replace wregion = 2 if land == "8011"
replace wregion = 1 if land == "8012"
replace wregion = 1 if land == "8013"
replace wregion = 1 if land == "8014"
replace wregion = 5 if land == "8015"
replace wregion = 1 if land == "8016"
replace wregion = 5 if land == "8017"
replace wregion = 1 if land == "8018"
replace wregion = 5 if land == "8019"
replace wregion = 5 if land == "8020"
replace wregion = 2 if land == "8021"
replace wregion = 2 if land == "8022"
replace wregion = 4 if land == "8023"
replace wregion = 2 if land == "8024"
replace wregion = 4 if land == "8025"
replace wregion = 4 if land == "8026"
replace wregion = 2 if land == "8027"
replace wregion = 2 if land == "8028"
replace wregion = 5 if land == "8029"
replace wregion = 5 if land == "8030"
replace wregion = 4 if land == "8031"
replace wregion = 3 if land == "8032"
replace wregion = 2 if land == "8033"
replace wregion = 1 if land == "8034"
replace wregion = 1 if land == "8035"
replace wregion = 5 if land == "8036"
replace wregion = 5 if land == "8037"
replace wregion = 5 if land == "8038"
replace wregion = 5 if land == "8039"
replace wregion = 2 if land == "8040"
replace wregion = 5 if land == "8041"
replace wregion = 5 if land == "8042"
replace wregion = 2 if land == "8043"
replace wregion = 2 if land == "8044"
replace wregion = 5 if land == "8045"
replace wregion = 1 if land == "9000"
replace wregion = 4 if land == "9001"
replace wregion = 4 if land == "9003"
replace wregion = 3 if land == "9005"
replace wregion = 4 if land == "9006"
replace wregion = 2 if land == "9007"
replace wregion = 4 if land == "9008"
replace wregion = 4 if land == "9009"
replace wregion = 4 if land == "9010"
replace wregion = 4 if land == "9013"
replace wregion = 5 if land == "9014"
replace wregion = 5 if land == "9015"
replace wregion = 4 if land == "9016"
replace wregion = 2 if land == "9017"
replace wregion = 4 if land == "9020"
replace wregion = 4 if land == "9022"
replace wregion = 4 if land == "9023"
replace wregion = 4 if land == "9027"
replace wregion = 4 if land == "9028"
replace wregion = 2 if land == "9030"
replace wregion = 5 if land == "9031"
replace wregion = 4 if land == "9036"
replace wregion = 3 if land == "9037"
replace wregion = . if land == "9038"	
replace wregion = 3 if land == "9041"
replace wregion = 3 if land == "9042"
replace wregion = 4 if land == "9043"
replace wregion = 4 if land == "9044"
replace wregion = 3 if land == "9047"
replace wregion = 1 if land == "9048"
replace wregion = 1 if land == "9049"
replace wregion = 4 if land == "9050"
replace wregion = 4 if land == "9051"
replace wregion = 2 if land == "9052"
replace wregion = 3 if land == "9053"
replace wregion = 3 if land == "9054"
replace wregion = 2 if land == "9055"
replace wregion = 2 if land == "9056"
replace wregion = 2 if land == "9057"
replace wregion = 2 if land == "9058"
replace wregion = 2 if land == "9060"
replace wregion = 3 if land == "9061"
replace wregion = 3 if land == "9062"
replace wregion = 4 if land == "9063"
replace wregion = 4 if land == "9064"
replace wregion = 3 if land == "9065"
replace wregion = 4 if land == "9066"
replace wregion = 2 if land == "9067"
replace wregion = 2 if land == "9068"
replace wregion = 2 if land == "9069"
replace wregion = 3 if land == "9070"
replace wregion = 1 if land == "9071"
replace wregion = 4 if land == "9072"
replace wregion = 4 if land == "9073"
replace wregion = 3 if land == "9074"
replace wregion = 2 if land == "9075"
replace wregion = 4 if land == "9076"
replace wregion = 4 if land == "9077"
replace wregion = 4 if land == "9078"
replace wregion = 4 if land == "9081"
replace wregion = 4 if land == "9082"
replace wregion = 2 if land == "9084"
replace wregion = 1 if land == "9085"
replace wregion = 4 if land == "9086"
replace wregion = 4 if land == "9087"
replace wregion = 3 if land == "9088"
replace wregion = 1 if land == "9089"
replace wregion = 2 if land == "9090"
replace wregion = 2 if land == "9091"
replace wregion = 4 if land == "9092"
replace wregion = 3 if land == "9093"
replace wregion = 2 if land == "9094"
replace wregion = 1 if land == "9095"
replace wregion = . if land == "9999"	
