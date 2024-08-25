function validateAndSubmit(event) {
        event.preventDefault(); // 폼의 기본 제출 동작을 막음

        const ssn = document.getElementById("birthdate").value; // 주민등록번호 입력값 가져오기
        const phone = document.getElementById("phone").value; // 전화번호 입력값 가져오기
        const email = document.getElementById("email").value; // 이메일 입력값 가져오기

        // 각각의 유효성 검사
        if (!validateSSN(ssn)) {
            alert("주민등록번호 형식이 잘못되었습니다. 올바른 형식: 123456-1234567");
            return;
        }

        if (!validatePhone(phone)) {
            alert("전화번호 형식이 잘못되었습니다. 올바른 형식: 010-1234-5678");
            return;
        }

        if (!validateEmail(email)) {
            alert("이메일 형식이 잘못되었습니다. 올바른 형식: example@example.com");
            return;
        }

        submitForm(); // 유효성 검사가 모두 통과된 경우 폼 제출
    }

    function validateSSN(ssn) {
        const ssnPattern = /^\d{6}-\d{7}$/; 
        return ssnPattern.test(ssn);
    }

    function validatePhone(phone) {
        const phonePattern = /^\d{3}-\d{4}-\d{4}$/;
        return phonePattern.test(phone);
    }

    function validateEmail(email) {
        const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        return emailPattern.test(email);
    }

    function submitForm() {
        const form = document.querySelector("form");
        form.submit(); // 폼 제출
    }