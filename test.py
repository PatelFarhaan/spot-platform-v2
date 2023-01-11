def solution(input_string):
    res = {}
    _list = input_string.split("\n")
    for index, ele in enumerate(_list):
        if index == 0:
            continue

        row = ele.split("\t")
        print(row)
        name = row[0]
        status = row[2]
        res[name] = status
    return res


input_string = """
Name    Test    Status  Comments"""
# Pre Test 1  Test1   Pass    NA
# Pre Test 2  Test2   Fail    NA
# Pre Test 3  Test3   Pass    NA
# """

resp = solution(input_string)
# print(resp)
