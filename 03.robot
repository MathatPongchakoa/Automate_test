*** Settings ***
Library    RequestsLibrary
Library    Collections

# ปิดการแจ้งเตือนเรื่อง SSL (InsecureRequestWarning) เพื่อให้ Log ดูสะอาดตาขึ้น
Suite Setup    Evaluate    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)    modules=urllib3

*** Variables ***
${BASE_URL}       https://reqres.in
${API_KEY}        reqres_11b7d1a452114e68b3824f7ba95e68a5

*** Test Cases ***
Get user profile success
    [Documentation]    To verify get user profile api will return correct data when trying to get profile of existing user
    # 1. Send Get request to url
    ${headers}=    Create Dictionary    x-api-key=${API_KEY}
    Create Session    reqres    ${BASE_URL}    headers=${headers}    verify=${False}

    # Verify response status code should be '200'
    ${response}=    GET On Session    reqres    /api/users/12    expected_status=200

    # แสดงข้อมูล Response ทั้งหมดลงในหน้าจอ Console และไฟล์ log.html
    Log To Console    \n=== ข้อมูล Response ที่ได้จาก ID 12 ===
    Log To Console    ${response.json()}
    Log    ${response.json()}

    # 2. Compare the response body with expected
    ${data}=    Set Variable    ${response.json()['data']}
    
    Should Be Equal As Integers    ${data['id']}            12
    Should Be Equal As Strings     ${data['email']}         rachel.howell@reqres.in
    Should Be Equal As Strings     ${data['first_name']}    Rachel
    Should Be Equal As Strings     ${data['last_name']}     Howell
    Should Be Equal As Strings     ${data['avatar']}        https://reqres.in/img/faces/12-image.jpg

Get user profile but user not found
    [Documentation]    To verify get user profile api will return 404 not found when trying to get exist profile of not existing user
    # 1. Send Get request to url
    ${headers}=    Create Dictionary    x-api-key=${API_KEY}
    Create Session    reqres    ${BASE_URL}    headers=${headers}    verify=${False}

    # 1. Verify response status code should be '404'
    ${response}=    GET On Session    reqres    /api/users/1234    expected_status=404

    # แสดงข้อมูล Response ลงในหน้าจอ Console และไฟล์ log.html
    Log To Console    \n=== ข้อมูล Response ที่ได้จาก ID 1234 ===
    Log To Console    ${response.json()}
    Log    ${response.json()}

    # 2. Response body should be '{}'
    ${body}=    Set Variable    ${response.json()}
    Should Be Empty    ${body}