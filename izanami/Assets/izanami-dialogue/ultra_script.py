from json import dumps, load
from copy import deepcopy

# Template
TEMPLATE: dict = {
	"info": {
		"skippable": False,
		"characters": []
	},
	"main": {
		"checks": [],
		"flags" : {},
		"rewards": {},
		"dialogue": []
	},
}

BRANCH_TEMPLATE: dict = {
    "name": {
        "flags": {},
        "rewards": {},
        "dialogue": []
    }
}

# Dialogue line indexes
SPEAKER = 0
TEXT = 1
QUESTION_ARRAY = 2
BRANCH_ARRAY = 3
UNSKIPPABLE_FLAG = 4
LOOP_OPTIONS_FLAG = 5


# GLobal variables (Ideally a better way than a global variable, but it's 2am)
characters = set()

def create_question_array(questions: list, branches: list) -> list[dict]:
    temp = []
    for i in range(len(questions)):
        temp.append({
						"name": questions[i],
						"checks": [],
						"branch": branches[i]
					},)
    return temp


def convert_section(section: list) -> list:
    converted_section = []
    for line in section:
        characters.add(line[SPEAKER])
        if len(line) < 3:
            converted_section.append(line)
        else:
            converted_line = [line[SPEAKER], line[TEXT], create_question_array(line[QUESTION_ARRAY], line[BRANCH_ARRAY])]
            try:
                converted_line + [line[UNSKIPPABLE_FLAG]]
                try:
                    converted_line + [line[LOOP_OPTIONS_FLAG]]
                except IndexError:
                    pass
            except IndexError:
                pass
            converted_section.append(converted_line)

    return converted_section

def string_slicer(file_str: str):
    return file_str.split("/")[1]


def convert(input_path: str):
    main_segment = []
    alt_sections = []
    branches = []

    # filename: str = input("Paste file name: ")
    filename: str = input_path
    OUTPUT_LOCATION = "converted/" +  string_slicer(filename)[:-5] + "-conv.json"

    with open(filename, 'r') as file:
        file_data: dict = load(file)

    for section in file_data.keys():
        if section == "main":
            main_segment = convert_section(file_data[section])
        if "alt" in section:
            alt_section = {section: deepcopy(BRANCH_TEMPLATE["name"])}
            alt_section[section]["dialogue"] = convert_section(file_data[section])
            alt_sections.append(alt_section)
        if "branch" in section:
            branch = {section: deepcopy(BRANCH_TEMPLATE["name"])}
            branch[section]["dialogue"] = convert_section(file_data[section])
            branches.append(branch)

    # Create final result cutscene from template
    result = deepcopy(TEMPLATE)

    result["info"]["characters"] = list(characters)
    result["main"]["dialogue"] = main_segment

    for branch in branches:
        print(branch)
        result.update(branch)

    for alt_section in alt_sections:
        result.update(alt_section)

    print(result)

    with open(OUTPUT_LOCATION, "w") as f:
        f.write(dumps(result))

# if __name__ == '__main__':
#   main()
