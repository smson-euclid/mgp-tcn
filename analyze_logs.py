import math
import statistics
'''
lines = []
FILE = open('logs/lr_1e-2_65epochs_0_decay.txt','r')
lines = lines+FILE.readlines()
FILE.close()

EPOCHS = 150
N_HORIZONS = 14
N_SPLITS = 1

LOGS = [[[[[] for i in range(EPOCHS)] for i in range(N_HORIZONS)] for i in range(N_SPLITS)] for i in range(2)]
PERFORMANCES = [[[[[] for i in range(EPOCHS)] for i in range(N_HORIZONS)] for i in range(N_SPLITS)] for i in range(2)]

for i in range(len(lines)):
	l = lines[i]
	splitted = l.strip().split(',')

	if splitted[0]=='train_loss':
		split,horizon,epoch,_,loss = splitted[1:]
		LOGS[0][int(split)][int(horizon)][int(epoch)].append(float(loss))

	elif splitted[0]=='val_loss':
		split,horizon,epoch,loss,auprc,auroc = splitted[1:]
		LOGS[1][int(split)][int(horizon)][int(epoch)].append(float(loss))
		PERFORMANCES[0][int(split)][int(horizon)][int(epoch)].append(float(auprc))
		PERFORMANCES[1][int(split)][int(horizon)][int(epoch)].append(float(auroc))


for split in range(N_SPLITS):
	for horizon in [7]:
		for epoch in range(EPOCHS):
			if len(PERFORMANCES[0][split][horizon][epoch]) > 0:
				print('auprc {} {} {} {}'.format(split,horizon,epoch,max(PERFORMANCES[0][split][horizon][epoch])))

for split in range(N_SPLITS):
	for horizon in [7]:
		for epoch in range(EPOCHS):
			if len(PERFORMANCES[1][split][horizon][epoch]) > 0:
				print('auroc {} {} {} {}'.format(split,horizon,epoch,max(PERFORMANCES[1][split][horizon][epoch])))

'''
lines = []
# for i in range(2):
# 	# best_parameters_
# 	FILE = open('new_extend_24_'+str(i)+'.txt','r')
# 	lines = lines+FILE.readlines()
# 	FILE.close()


FILE = open('labs_and_vitals_1.txt','r')
lines = lines+FILE.readlines()
FILE.close()

EPOCHS = 15
N_HORIZONS = 7
N_SPLITS = 3
LOGS = [[[[[] for i in range(EPOCHS)] for i in range(N_HORIZONS)] for i in range(N_SPLITS)] for i in range(2)]
BESTS = [[ [] for i in range(N_HORIZONS)] for i in range(N_SPLITS)]
PERFORMANCES = [[[[[] for i in range(EPOCHS)] for i in range(N_HORIZONS)] for i in range(N_SPLITS)] for i in range(2)]

for i in range(len(lines)):
	l = lines[i]
	splitted = l.strip().split(',')

	if splitted[0]=='best':

		auprc = splitted[-2]
		auroc = splitted[-1]
		split = splitted[1]
		horizon = splitted[2]

		BESTS[int(split)][int(horizon)] = [auprc,auroc]
		# print(lines[i-1].strip())
		
	elif splitted[0]=='train_loss':
		split,horizon,epoch,loss = splitted[1:]
		LOGS[0][int(split)][int(horizon)][int(epoch)].append(float(loss))

	elif splitted[0]=='val_loss':
		split,horizon,epoch,loss,auprc,auroc = splitted[1:]
		LOGS[1][int(split)][int(horizon)][int(epoch)].append(float(loss))
		PERFORMANCES[0][int(split)][int(horizon)][int(epoch)].append(float(auprc))
		PERFORMANCES[1][int(split)][int(horizon)][int(epoch)].append(float(auroc))
		

# for split in range(N_SPLITS):
# 	for horizon in range(N_HORIZONS):
# 		print(split,horizon,' '.join(BESTS[split][horizon]))


# for split in range(N_SPLITS):
# for split in range(3):
# 	for horizon in [0,7,12]:

# 			train_loss = [sum(e)/len(e) if len(e)>0 else 0 for e in LOGS[0][split][horizon]]
# 			val_loss = [sum(e)/len(e) if len(e)>0 else 0 for e in LOGS[1][split][horizon]]

# 			print(split,horizon,'train_loss val_loss')
# 			for i in range(EPOCHS):
# 				print(train_loss[i],val_loss[i])
		
epoch = 6

print("AUPRC")
for horizon in range(25):
	res = []
	for split in range(3):
		if len(PERFORMANCES[0][split][horizon][epoch]) > 0:
			res.append(str(statistics.mean(PERFORMANCES[0][split][horizon][epoch])))
	print(' '.join(res))

print("AUROC")
for horizon in range(25):
	res = []
	for split in range(3):
		if len(PERFORMANCES[1][split][horizon][epoch]) > 0:
			res.append(str(statistics.mean(PERFORMANCES[1][split][horizon][epoch])))
	print(' '.join(res))


# for split in range(3):
# 	for horizon in range(8):
# 		for epoch in range(EPOCHS):
# 			if len(PERFORMANCES[0][split][horizon][epoch]) > 0:
# 				print('auprc {} {} {} {}'.format(split,horizon,epoch,statistics.mean(PERFORMANCES[0][split][horizon][epoch])))

for split in range(1):
	for horizon in [7]:
		for epoch in range(EPOCHS):
			if len(PERFORMANCES[1][split][horizon][epoch]) > 0:
				print('auroc {} {} {} {}'.format(split,horizon,epoch,statistics.mean(PERFORMANCES[1][split][horizon][epoch])))

# for i in range(len(lines)):
# 	l = lines[i]
# 	splitted = l.strip().split(',')
		
# 	if splitted[0]=='val_loss':
# 		split,horizon,epoch,loss,auprc,auroc = splitted[1:]
# 		if len(BESTS[int(split)][int(horizon)]) > 0:
# 			if auprc == BESTS[int(split)][int(horizon)][0]:
# 				print('auprc',split,horizon,epoch,auprc)
# 			if auroc == BESTS[int(split)][int(horizon)][1]:
# 				print('auroc',split,horizon,epoch,auroc)

# split = 0

