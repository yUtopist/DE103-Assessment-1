#
# DEPARTMENT DATA SHAPING
departmentData = open('../DATA/Department.csv', 'r').read().strip()
departmentDataList = list(filter(None, departmentData.split('\n')))

departmentList = []
departmentShapedData = ''
departmentIDCounter = 1
for index, item in enumerate(departmentDataList):
    #
    # Every row in Department data is only one value for Dapertment name
    # so we need to format it and if it is not already in the list then
    # add to a Shaped data string with line break and Unique Private Key.
    #
    # We also keep track of added departments to the shaped data by adding
    # departments to a temprory list, since it is easy to check it that way
    formatted_item = item.strip()
    if formatted_item not in departmentList:
        #
        # Preparing string of data to insert to a file. each row supposed to have a
        # line break at the end, except the very last one, but we handle it in the
        # file writing logic with ''.strip('\n') method.
        departmentShapedData += f"{departmentIDCounter},{item.strip()}\n"
        departmentIDCounter += 1
        departmentList.append(formatted_item)
#
# Writing all that to a file
file = open('../DATA/! DepartmentID + Department', 'w')
file.write(departmentShapedData.strip())
file.close()


#
# SURGEON DATA SHAPING
surgeonData = open('../DATA/Surgeon + Department.csv', 'r').read().strip()
surgeonDataList = list(filter(None, surgeonData.split('\n')))

surgeonList = []
surgeonShapedData = ''
surgeonIDCounter = 1
for index, item in enumerate(surgeonDataList):
    #
    # Surgeon Table has two attributes - first is always a name and second is always
    # a department name, but the idea is the same, all we have to do is to check if
    # the surgeon name in the list and if its not then adding it to our shaped data,
    # and then adding the name to the checker list.
    surgeonSplit = item.split(',')
    surgeonName = surgeonSplit[0].strip()
    surgeonDepartment = surgeonSplit[1].strip()
    #
    # Inserting only unique items to formatted list
    if surgeonName not in surgeonList:
        surgeonShapedData += f"{surgeonIDCounter},{surgeonName},{surgeonDepartment}\n"
        surgeonIDCounter += 1
        surgeonList.append(surgeonName)
#
# Writing all that to a file
file = open('../DATA/! SurgeonID + Surgeon + Department', 'w')
file.write(surgeonShapedData.strip('\n'))
file.close()


#
# REFERRER DATA SHAPING
referrerData = open('../DATA/Referrer + ReferrerType.csv', 'r').read().strip()
referrerDataList = list(filter(None, referrerData.split('\n')))

referrerList = []
referrerShapedData = ''
referrerIDCounter = 1
for index, item in enumerate(referrerDataList):
    #
    # Same as in the privious Data Shaping, we just split the initial data and check
    # for dublications.
    #
    # Need to make an exceptions and error catching in case Referrer
    # Type is not specified, but for this case this will work.
    referrerSplit = item.split(',')
    referrerName = referrerSplit[0].strip()
    referrerType = referrerSplit[1].strip()
    #
    # Inserting only unique items to formatted list
    if referrerName not in referrerList:
        referrerShapedData += f"{referrerIDCounter},{referrerName},{referrerType}\n"
        referrerIDCounter += 1
        referrerList.append(referrerName)
#
# Writing all that to a file
file = open('../DATA/! ReferrerID + Referrer + ReferrerType', 'w')
file.write(referrerShapedData.strip('\n'))
file.close()


#
# PATIENT DATA SHAPING
patientData = open(
    '../DATA/NHI + PatientName + DOB + Gender.csv', 'r').read().strip()
patientDataList = list(filter(None, patientData.split('\n')))

patientList = []
patientNHIList = []
patientShapedData = ''
patientNHIErrorCounter = 1
for index, item in enumerate(patientDataList):
    #
    patientSplit = item.split(',')
    patientNHI = patientSplit[0].strip()
    patientName = patientSplit[1].strip()
    patientDOB = patientSplit[2].strip()
    patientGender = patientSplit[3].strip()
    #
    # Formating Date to a SQL standart
    dateSplit = patientDOB.split('/')
    dateDay = dateSplit[0]
    dateMonth = dateSplit[1]
    dateYear = dateSplit[2]
    #
    # Creating temprory dictionary to then insert it to new list
    patientEntry = {
        'NHI': patientNHI,
        'name': patientName,
        'DOB': f'{dateYear}-{dateMonth}-{dateDay}',
        'gender': patientGender[:1],
        'errorNHI': ''
    }
    #
    # Inserting only unique items to formatted list
    if patientEntry not in patientList:
        #
        # There are cases when NHI is dublicated for multiple clients and in order to
        # fix it we are going to treat first time declared NHI as a proper one and any
        # further dublications as a misstake. In our solution we going to have an
        # attribute 'ErrorNHI' which is going to be an empty string if row is unique
        # or a dublicated NHI if error accured.
        if patientNHI not in patientNHIList:
            patientNHIList.append(patientNHI)
        else:
            #
            # So we have found a dublication of NHI, now we need to change current NHI
            # to a error unique ID (just so we can sort it in the future and fix it).
            # error looks like this: ' err001' with an empty space at the start of the
            # string, followed by three letters err in lower case and then the order
            # number of the error. It is done for spotting the error in the list.
            errorNHI = f' err{patientNHIErrorCounter:03d}'
            patientEntry['NHI'] = errorNHI
            #
            # Then we set errorNHI to a NHI that was dublicated, so we have a reference
            # in case there was an actual mistake done for the first time NHI was entered
            patientEntry['errorNHI'] = patientNHI

            patientNHIErrorCounter += 1
        patientShapedData += f"{patientEntry['NHI']},{patientName},{patientEntry['DOB']},{patientEntry['gender']}\n"
        #
        # We need to add new entry to the checking list at the end so all of the changes
        # are done prier to it.
        patientList.append(patientEntry)
#
# Writing all that to a file
file = open('../DATA/! NHI + PatientName + DOB + Gender + errorNHI', 'w')
file.write(patientShapedData.strip('\n'))
file.close()
