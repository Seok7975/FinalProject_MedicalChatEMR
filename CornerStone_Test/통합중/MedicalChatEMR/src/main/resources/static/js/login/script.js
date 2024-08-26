document.addEventListener("DOMContentLoaded", function () {
            const doctorRadio = document.getElementById('doctor');
            const nurseRadio = document.getElementById('nurse');
            const pharmacistRadio = document.getElementById('pharmacist');

            const inputBox1 = document.querySelector('.input-box-1');
            const inputBox2 = document.querySelector('.input-box-2');
            const inputBox3 = document.querySelector('.input-box-3');

            function updatePositionLevel() {
                if (doctorRadio.checked) {
                    inputBox1.classList.add('show');
                    inputBox2.classList.remove('show');
                    inputBox3.classList.remove('show');
                } else if (nurseRadio.checked) {
                    inputBox1.classList.remove('show');
                    inputBox2.classList.add('show');
                    inputBox3.classList.remove('show');
                } else if (pharmacistRadio.checked) {
                    inputBox1.classList.remove('show');
                    inputBox2.classList.remove('show');
                    inputBox3.classList.add('show');
                }
            }

            doctorRadio.addEventListener('change', updatePositionLevel);
            nurseRadio.addEventListener('change', updatePositionLevel);
            pharmacistRadio.addEventListener('change', updatePositionLevel);

            updatePositionLevel();
        });