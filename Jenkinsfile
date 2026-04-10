pipeline {
    agent any

    environment {
        GIT_URL = 'https://github.com/MathatPongchakoa/Automate_test.git'
        RESULT_DIR = 'results'
        // กำหนด Path ของ Python ไว้เป็นตัวแปรเพื่อให้โค้ดอ่านง่าย
        PYTHON_EXE = 'C:\\Users\\adkma\\AppData\\Local\\Programs\\Python\\Python313\\python.exe'
    }

    stages {
        stage('Checkout Code From Git') {
            steps {
                echo '--- Step 1: Pulling latest code from GitHub ---'
                git branch: 'main', url: "${GIT_URL}"
            }
        }

        stage('Run Test Automate') {
            steps {
                echo '--- Step 2: Running Robot Framework Tests ---'
                script {
                    if (isUnix()) {
                        sh "mkdir -p ${RESULT_DIR}"
                        sh "python3 -m robot --outputdir ${RESULT_DIR} *.robot"
                    } else {
                        // ใช้ Path เต็มที่เราหาเจอมาสั่งรัน
                        bat "if not exist ${RESULT_DIR} mkdir ${RESULT_DIR}"
                        bat "\"${PYTHON_EXE}\" -m robot --outputdir ${RESULT_DIR} *.robot"
                    }
                }
            }
        }

        stage('Send Result To Jenkins') {
            steps {
                echo '--- Step 3: Archiving Results and Reports ---'
                archiveArtifacts artifacts: "${RESULT_DIR}/*.html", allowEmptyArchive: true
                junit testResults: "${RESULT_DIR}/*.xml", allowEmptyResults: true
            }
        }
    }

    post {
        success {
            echo 'STATUS: SUCCESS - All automated tests passed!'
        }
        failure {
            echo 'STATUS: FAILURE - Check Console Output for errors.'
        }
    }
}