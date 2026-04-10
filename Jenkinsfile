pipeline {
    agent any

    environment {
        // URL ของ Repository บน GitHub ของคุณ
        GIT_URL = 'https://github.com/MathatPongchakoa/Automate_test.git'
        // โฟลเดอร์สำหรับเก็บไฟล์ผลลัพธ์การทดสอบ
        RESULT_DIR = 'results'
    }

    stages {
        // Stage 1: ดึงโค้ดจาก Git (Checkout Code From Git)
        stage('Checkout Code From Git') {
            steps {
                echo '--- Step 1: Pulling latest code from GitHub ---'
                // ดึงโค้ดจาก Branch main
                git branch: 'main', url: "${GIT_URL}"
            }
        }

        // Stage 2: รันสคริปต์ทดสอบอัตโนมัติ (Run Test Automate)
        stage('Run Test Automate') {
            steps {
                echo '--- Step 2: Running Robot Framework Tests ---'
                script {
                    if (isUnix()) {
                        // สำหรับ Linux/Mac
                        sh "mkdir -p ${RESULT_DIR}"
                        sh "python3 -m robot --outputdir ${RESULT_DIR} *.robot"
                    } else {
                        // สำหรับ Windows (เครื่องที่คุณใช้งานอยู่)
                        // ใช้ python -m robot เพื่อให้ระบบเรียกโมดูลได้แม่นยำขึ้น
                        bat "if not exist ${RESULT_DIR} mkdir ${RESULT_DIR}"
                        bat "python -m robot --outputdir ${RESULT_DIR} *.robot"
                    }
                }
            }
        }

        // Stage 3: ส่งผลลัพธ์กลับไปยัง Jenkins (Send Result To Jenkins)
        stage('Send Result To Jenkins') {
            steps {
                echo '--- Step 3: Archiving Results and Reports ---'
                
                // 1. เก็บไฟล์ HTML Report (report.html, log.html) ไว้ดูบน Jenkins
                archiveArtifacts artifacts: "${RESULT_DIR}/*.html", allowEmptyArchive: true
                
                // 2. ประมวลผลไฟล์ XML เพื่อแสดงกราฟสถิติในหน้าโปรเจกต์
                // หมายเหตุ: ต้องติดตั้ง JUnit Plugin ใน Jenkins ด้วย
                junit testResults: "${RESULT_DIR}/*.xml", allowEmptyResults: true
            }
        }
    }

    // ส่วนจัดการหลังรัน Pipeline เสร็จสิ้น
    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'STATUS: SUCCESS - All automated tests passed!'
        }
        failure {
            echo 'STATUS: FAILURE - Tests failed or script error. Check Console Output.'
        }
    }
}