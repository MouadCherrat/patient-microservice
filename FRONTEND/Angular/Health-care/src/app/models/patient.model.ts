export class Patient {
  id?: number; // Optional because it's auto-generated
  firstName: string; // Patient's first name
  lastName: string; // Patient's last name
  birthDate: string; // Date of birth (format: YYYY-MM-DD)
  gender: string; // Gender (Male/Female)
  address: string; // Address
  contactPerson: string; // Emergency contact
  contactPhone: string; // Emergency contact phone
  doctorId?: number; // ID of the responsible doctor (optional)
  username: string; // Username for login
  password: string; // Password for login

  constructor(
    firstName: string,
    lastName: string,
    birthDate: string,
    gender: string,
    address: string,
    contactPerson: string,
    contactPhone: string,
    username: string,
    password: string,
    id?: number,
    doctorId?: number
  ) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.birthDate = birthDate;
    this.gender = gender;
    this.address = address;
    this.contactPerson = contactPerson;
    this.contactPhone = contactPhone;
    this.username = username;
    this.password = password;
    this.doctorId = doctorId;
  }
}
