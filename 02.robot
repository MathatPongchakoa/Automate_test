*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            http://the-internet.herokuapp.com/login
${BROWSER}        chrome
${VALID_USER}     tomsmith
${VALID_PASS}     SuperSecretPassword!
${INVALID_USER}   tomholland
${INVALID_PASS}   Password!

*** Test Cases ***
Login success
    [Documentation]    ตรวจสอบการเข้าสู่ระบบสำเร็จและการออกจากระบบ
    Open Browser To Login Page
    Input Text       id:username    ${VALID_USER}
    Input Text       id:password    ${VALID_PASS}
    Click Button     class:radius
    
    # เพิ่มบรรทัดนี้: รอจนกว่าข้อความความสำเร็จจะปรากฏ
    Wait Until Page Contains    You logged into a secure area!    timeout=5s
    
    Page Should Contain    You logged into a secure area!
    
    # ทดสอบ Logout
    Click Link       xpath://a[@href="/logout"]
    
    # เพิ่มบรรทัดนี้ด้วย: รอจนกว่าจะกลับมาหน้า Logout สำเร็จ
    Wait Until Page Contains    You logged out of the secure area!    timeout=5s
    
    Page Should Contain    You logged out of the secure area!
    [Teardown]       Close Browser

Login failed - Password incorrect
    [Documentation]    ตรวจสอบกรณีรหัสผ่านผิด
    Open Browser To Login Page
    Input Text       id:username    ${VALID_USER}
    Input Text       id:password    ${INVALID_PASS}
    Click Button     class:radius
    
    # เพิ่มบรรทัดนี้: รอให้กล่อง flash ปรากฏขึ้นมาก่อน
    Wait Until Element Is Visible    id:flash    timeout=5s
    
    Element Should Contain    id:flash    Your password is invalid!
    [Teardown]       Close Browser

Login failed - Username not found
    [Documentation]    ตรวจสอบกรณีไม่พบชื่อผู้ใช้
    Open Browser To Login Page
    Input Text       id:username    ${INVALID_USER}
    Input Text       id:password    ${VALID_PASS}
    Click Button     class:radius
    
    # เพิ่มบรรทัดนี้: รอให้กล่อง flash ปรากฏขึ้นมาก่อน
    Wait Until Element Is Visible    id:flash    timeout=5s
    
    Element Should Contain    id:flash    Your username is invalid!
    [Teardown]       Close Browser

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    # ตั้งค่าให้ Selenium รอทุกคำสั่งอัตโนมัติ 2 วินาที ถ้ายังหา Element ไม่เจอ
    Set Selenium Implicit Wait    2 seconds
    Wait Until Element Is Visible    id:username