from subprocess import Popen
import json

'''

for horizon in range(4):
	for split in range(3):
		config_file = open("configs/paper_configs/config_split"+str(split)+".json",'r')
		config_content = config_file.read()
		config_content = json.loads(config_content)
		config_file.close()

		config_content['training_iters'] = 15
		
		temp_config_file0 = open("configs/paper_configs/config_temp0.json",'w')
		config_content['dataset']['horizon'] = horizon*2
		config_content['dataset']['LOG_FILE'] = 'new_extend_0.txt'
		temp_config_file0.write(json.dumps(config_content))
		temp_config_file0.close()

		temp_config_file1 = open("configs/paper_configs/config_temp1.json",'w')
		config_content['dataset']['horizon'] = horizon*2+1
		config_content['dataset']['LOG_FILE'] = 'new_extend_1.txt'
		temp_config_file1.write(json.dumps(config_content))
		temp_config_file1.close() 

		commands = [ 	[{'CUDA_VISIBLE_DEVICES':'0'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp0.json'.split(' ')],
						[{'CUDA_VISIBLE_DEVICES':'1'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp1.json'.split(' ')]]

		procs = [ Popen(cmd[1], env=cmd[0]) for cmd in commands ]
		for p in procs:
			p.wait()


# FIX main_preprocessing_mgp_tcn.py and mgp_tcn_fit.py files before running below!!
'''

for horizon in range(8):
	for split in range(3):
		config_file = open("configs/paper_configs/config_split"+str(split)+".json",'r')
		config_content = config_file.read()
		config_content = json.loads(config_content)
		config_file.close()

		config_content['training_iters'] = 15
		
		temp_config_file0 = open("configs/paper_configs/config_temp0.json",'w')
		config_content['dataset']['horizon'] = horizon
		config_content['dataset']['LOG_FILE'] = 'labs_only_0.txt'
		config_content['dataset']['data_sources'] = ["covs","labs"]
		temp_config_file0.write(json.dumps(config_content))
		temp_config_file0.close()

		temp_config_file1 = open("configs/paper_configs/config_temp1.json",'w')
		config_content['dataset']['horizon'] = horizon
		config_content['dataset']['LOG_FILE'] = 'labs_and_vitals_1.txt'
		config_content['dataset']['data_sources'] = ["covs","labs", "vitals"]
		temp_config_file1.write(json.dumps(config_content))
		temp_config_file1.close() 

		commands = [ 	[{'CUDA_VISIBLE_DEVICES':'0'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp0.json'.split(' ')],
						[{'CUDA_VISIBLE_DEVICES':'1'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp1.json'.split(' ')]]

		procs = [ Popen(cmd[1], env=cmd[0]) for cmd in commands ]
		for p in procs:
			p.wait()
























































# for split in range(3):
# 	for horizon in range(13):

# 		config_file = open("configs/paper_configs/config_split"+str(split)+".json",'r')
# 		config_content = config_file.read()
# 		config_content = json.loads(config_content)
# 		config_file.close()

# 		temp_config_file0 = open("configs/paper_configs/config_temp0.json",'w')
# 		config_content['training_iters'] = 65
# 		config_content['dataset']['horizon'] = horizon*2
# 		config_content['dataset']['GPU'] = 0
# 		temp_config_file0.write(json.dumps(config_content))
# 		temp_config_file0.close()

# 		temp_config_file1 = open("configs/paper_configs/config_temp1.json",'w')
# 		config_content['dataset']['horizon'] = horizon*2+1
# 		config_content['dataset']['GPU'] = 1
# 		temp_config_file1.write(json.dumps(config_content))
# 		temp_config_file1.close() 

# 		commands = [ 	[{'CUDA_VISIBLE_DEVICES':'0'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp0.json'.split(' ')],
# 						[{'CUDA_VISIBLE_DEVICES':'1'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp1.json'.split(' ')]]

# 		procs = [ Popen(cmd[1], env=cmd[0]) for cmd in commands ]
# 		for p in procs:
# 			p.wait()


# for split in range(3):
		
# 	config_file = open("configs/paper_configs/config_split"+str(split)+".json",'r')
# 	config_content = config_file.read()
# 	config_content = json.loads(config_content)
# 	config_file.close()

# 	temp_config_file0 = open("configs/paper_configs/config_temp0.json",'w')
# 	config_content['training_iters'] = 200
# 	config_content['dataset']['horizon'] = 7
# 	config_content['dataset']['GPU'] = 0
# 	temp_config_file0.write(json.dumps(config_content))
# 	temp_config_file0.close()

# 	temp_config_file1 = open("configs/paper_configs/config_temp1.json",'w')
# 	config_content['dataset']['horizon'] = 12
# 	config_content['dataset']['GPU'] = 1
# 	temp_config_file1.write(json.dumps(config_content))
# 	temp_config_file1.close() 

# 	commands = [ 	[{'CUDA_VISIBLE_DEVICES':'0'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp0.json'.split(' ')],
# 					[{'CUDA_VISIBLE_DEVICES':'1'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp1.json'.split(' ')]]

# 	procs = [ Popen(cmd[1], env=cmd[0]) for cmd in commands ]
# 	for p in procs:
# 		p.wait()


# for split in range(1):
# 	config_file = open("configs/paper_configs/config_split"+str(split)+".json",'r')
# 	config_content = config_file.read()
# 	config_content = json.loads(config_content)
# 	config_file.close()

# 	temp_config_file0 = open("configs/paper_configs/config_temp0.json",'w')
# 	config_content['training_iters'] = 200
# 	config_content['dataset']['horizon'] = 7
# 	config_content['dataset']['GPU'] = 0
# 	temp_config_file0.write(json.dumps(config_content))
# 	temp_config_file0.close()

# 	commands = [ 	[{'CUDA_VISIBLE_DEVICES':'0'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp0.json'.split(' ')]]

# 	procs = [ Popen(cmd[1], env=cmd[0]) for cmd in commands ]
# 	for p in procs:
# 		p.wait()


# for split in range(1):
# 	for horizon in range(24):

# 		config_file = open("configs/paper_configs/config_split"+str(0)+".json",'r')
# 		config_content = config_file.read()
# 		config_content = json.loads(config_content)
# 		config_file.close()

# 		temp_config_file0 = open("configs/paper_configs/config_temp0.json",'w')
# 		config_content['dataset']['split'] = split
# 		config_content['dataset']['horizon'] = horizon
# 		temp_config_file0.write(json.dumps(config_content))
# 		temp_config_file0.close()

# 		commands = [ 	[{'CUDA_VISIBLE_DEVICES':'0'}, '/home/centos/anaconda3/envs/sm/bin/python -m src.mgp_tcn.mgp_tcn_fit with configs/paper_configs/config_temp0.json'.split(' ')]]

# 		procs = [ Popen(cmd[1], env=cmd[0]) for cmd in commands ]
# 		for p in procs:
# 			p.wait()