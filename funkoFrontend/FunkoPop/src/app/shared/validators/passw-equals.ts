import { FormGroup } from "@angular/forms";
import Swal from "sweetalert2";
export function notEqualsValidator() {

    return (fg: FormGroup) => {
        const passwordNew = fg.controls['passwordNew'];
        const passwR = fg.controls['passwR'];
        if (passwR.errors && !passwR.errors['notEqual']) {
            return;
        }
        if (passwordNew.value !== passwR.value) {
            passwR.setErrors({ notEquals: true });
        } else {
            passwR.setErrors(null);
        }
    }
}