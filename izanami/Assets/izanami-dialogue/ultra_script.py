import json


#file here

with open('1 - yomotsu-1/1-beatrix-questions.json', 'r') as file:
    datum = json.load(file)

scripted = {
	"info": {
		"skippable": 'false',
		"characters": ["Guiding Voice", "..."]
	},
	"main": {
		"checks": [],
		"flags" : {},
		"rewards": {},
		"dialogue": 'main'
	},
}

branch = {
    "name": {
		"flags": {},
		"rewards": {},
		"dialogue": 'main'
	}
}

def createQArray(qarray, brancharray):
    temp_array = []
    for i in qarray:
        temp_array.append({
						"name": i,
						"checks": [],
						"branch": brancharray[qarray.index(i)]
					},)
    return temp_array

main_segment = []
leaf = []
branches = []
branch_segment = []
alt = []
alt_leaf = []
alt_segment = []
final_segment = []

for x in datum["main"]:
    if len(x) < 3:
        main_segment.append(x)
    else:
        if len(x) == 5:
            y = [x[0], x[1], createQArray(x[2], x[3]), x[4]]
        elif len(x) > 5:
            y = [x[0], x[1], createQArray(x[2], x[3]), x[4], x[5]]
        else:
            y = [x[0], x[1], createQArray(x[2], x[3])]
        main_segment.append(y)


if len(datum) > 1:
    counter = 1
    for x in datum:
        leaf = []
        if x == "main":
            continue
        if "alt" in x:
            continue
        for y in datum[x]:
            if len(y) < 3:
                leaf.append(y)
            else:
                if len(y) == 5:
                    y = [y[0], y[1], createQArray(y[2], y[3]), y[4]]
                elif len(y) > 5:
                    y = [y[0], y[1], createQArray(y[2], y[3]), y[4], y[5]]
                else:
                    y = [y[0], y[1], createQArray(y[2], y[3])]
                leaf.append(y)
        branch = {
                    "branch_" + str(counter): {
                        "flags": {},
                        "rewards": {},
                        "dialogue": leaf
                    }
                }
        branch_segment.append(branch)
        counter += 1
    counter = 1
    for x in datum:
        if x == "main":
            continue
        if "branch" in x:
            continue
        for y in datum[x]:
            if len(y) < 3:
                alt_leaf.append(y)
            else:
                if len(y) == 5:
                    y = [y[0], y[1], createQArray(y[2], y[3]), y[4]]
                elif len(y) > 5:
                    y = [y[0], y[1], createQArray(y[2], y[3]), y[4], y[5]]
                else:
                    y = [y[0], y[1], createQArray(y[2], y[3])]
                alt_leaf.append(y)
        alt = {
            "alt_" + str(counter): {
                "checks": [],
                "flags" : {},
                "rewards": {},
                "dialogue": alt_leaf
                },
            }
        alt_segment.append(alt)
        counter += 1





print("------")
print(branch_segment)




scripted["main"]["dialogue"] = main_segment
for x in branch_segment:
    scripted.update(x)
for y in alt_segment:
    scripted.update(y)



exit = json.dumps(scripted)
print(exit)

with open("tempname.json", "w") as f:
    f.write(exit)
    