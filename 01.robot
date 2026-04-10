*** Settings ***
Library    Collections

*** Variables ***
@{LIST_A}    ${1}    ${2}    ${3}    ${5}    ${6}    ${8}    ${9}
@{LIST_B}    ${3}    ${2}    ${1}    ${5}    ${6}    ${0}

*** Test Cases ***
Find Duplicate Items And Append To New List
    # 1. สร้าง List ว่างสำหรับเก็บผลลัพธ์
    ${DUPLICATE_LIST}=    Create List

    # 2. วนลูปเช็คสมาชิกใน List A
    FOR    ${item}    IN    @{LIST_A}
        # ตรวจสอบว่า item นั้นอยู่ใน List B หรือไม่
        ${is_duplicate}=    Run Keyword And Return Status    List Should Contain Value    ${LIST_B}    ${item}
        
        # 3. ถ้าซ้ำ ให้เอาไปใส่ใน DUPLICATE_LIST
        IF    ${is_duplicate}
            Append To List    ${DUPLICATE_LIST}    ${item}
        END
    END

    # 4. แสดงผลลัพธ์ที่ได้
    Log To Console    \n-----------------------------------
    Log To Console    List A: @{LIST_A}
    Log To Console    List B: @{LIST_B}
    Log To Console    Duplicate Items: ${DUPLICATE_LIST}
    Log To Console    -----------------------------------

    # ตรวจสอบความถูกต้อง (Optional)
    ${EXPECTED_LIST}=    Create List    ${1}    ${2}    ${3}    ${5}    ${6}
    Lists Should Be Equal    ${DUPLICATE_LIST}    ${EXPECTED_LIST}