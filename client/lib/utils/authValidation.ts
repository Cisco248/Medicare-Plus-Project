export type AuthFormErrors = {
  email?: string;
  password?: string;
  confirmPassword?: string;
  fname?: string;
  lname?: string;
  mobnum?: string;
};

export type SignUpFields = {
  fname: string;
  lname: string;
  mobnum: string;
  confirmPassword: string;
};

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MOBILE_PATTERN = /^\+?[0-9]{7,15}$/;

export function validateAuthForm(email: string, password: string): AuthFormErrors {
  const errors: AuthFormErrors = {};

  if (!email.trim()) {
    errors.email = "Email is required.";
  } else if (!EMAIL_PATTERN.test(email.trim())) {
    errors.email = "Enter a valid email address.";
  }

  if (!password.trim()) {
    errors.password = "Password is required.";
  } else if (password.length < 8) {
    errors.password = "Password must be at least 8 characters.";
  }

  return errors;
}

export function validateSignUpFields(
  fields: SignUpFields,
  password: string,
): AuthFormErrors {
  const errors: AuthFormErrors = {};

  if (!fields.fname.trim()) {
    errors.fname = "First name is required.";
  }
  if (!fields.lname.trim()) {
    errors.lname = "Last name is required.";
  }
  if (!fields.mobnum.trim()) {
    errors.mobnum = "Mobile number is required.";
  } else if (!MOBILE_PATTERN.test(fields.mobnum.trim())) {
    errors.mobnum = "Enter a valid mobile number.";
  }
  if (password && fields.confirmPassword !== password) {
    errors.confirmPassword = "Passwords do not match.";
  } else if (!fields.confirmPassword) {
    errors.confirmPassword = "Confirm your password.";
  }

  return errors;
}

export function hasAuthFormErrors(errors: AuthFormErrors): boolean {
  return Object.keys(errors).length > 0;
}
