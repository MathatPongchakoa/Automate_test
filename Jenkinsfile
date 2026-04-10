pipeline {
    agent any

    environment {
        // กำหนด URL ของ Git Repository ของคุณ
        GIT_URL = 'https://github.com/MathatPongchakoa/Automate_test.git'
        // กำหนดโฟลเดอร์สำหรับเก็บผลลัพธ์
        RESULT_DIR = 'results'
    }

    stages {
        // Stage 1: ดึงโค้ดจาก Git (Checkout Code From Git)
        stage('Checkout Code From Git') {
            steps {
                echo '--- Step 1: Pulling latest code from GitHub ---'
                git branch: 'main', url: "${GIT_URL}"
            }
        }

        // Stage 2: รันสคริปต์ทดสอบอัตโนมัติ (Run Test Automate)
        stage('Run Test Automate') {
            steps {
                echo '--- Step 2: Running Robot Framework Tests ---'
                // สร้างโฟลเดอร์เก็บผลลัพธ์ (ถ้ายังไม่มี)
                // และรันไฟล์ .robot ทั้งหมดในโฟลเดอร์
                // ใช้คำสั่ง bat สำหรับ Windows หรือ sh สำหรับ Linux/Mac
                script {
                    if (isUnix()) {
                        sh "mkdir -p ${RESULT_DIR}"
                        sh "robot --outputdir ${RESULT_DIR} *.robot"
                    } else {
                        bat "if not exist ${RESULT_DIR} mkdir ${RESULT_DIR}"
                        bat "robot --outputdir ${RESULT_DIR} *.robot"
                    }
                }
            }
        }

        // Stage 3: ส่งผลลัพธ์กลับไปยัง Jenkins (Send Result To Jenkins)
        stage('Send Result To Jenkins') {
            steps {
                echo '--- Step 3: Archiving Results and Reports ---'
                
                // 1. เก็บไฟล์ HTML Report ไว้ดูย้อนหลังบน Jenkins
                archiveArtifacts artifacts: "${RESULT_DIR}/*.html", allowEmptyArchive: true
                
                // 2. แสดงผลสรุป Test Result (ถ้ามีไฟล์ output.xml)
                // ปลั๊กอิน JUnit หรือ Robot จะช่วยสร้างกราฟสวยๆ ให้
                junit "${RESULT_DIR}/*.xml"
            }
        }
    }

    // ส่วนจัดการหลังจบการทำงาน (Post-action)
    post {
        always {
            echo 'Pipeline finished. Cleaning up workspace if necessary.'
        }
        success {
            echo 'SUCCESS: All tests passed!'
        }
        failure {
            echo 'FAILURE: Some tests failed. Please review the report.html'
        }
    }
}