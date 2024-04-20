import { Controller } from '@hotwired/stimulus';
import { csrfToken } from '../utils';

// Connects to data-controller="payments"
export default class extends Controller {
  initialErrorMessage =
    "An error occurred! Don't worry, your money are safe... most likely&#129335;";
  static targets = [
    'amount',
    'iban',
    'bankAccountId',
    'warningMessage',
    'errorMessage',
  ];
  static values = { userId: Number };

  async pay(event) {
    event.preventDefault();
    this.resetForm();
    if (!this.validateForm()) return;
    const response = await fetch(
      `/users/${this.userIdValue}/bank_accounts/${this.bankAccountIdTarget.value}/transactions.json`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken(),
        },
        body: JSON.stringify({
          transaction: {
            iban: this.ibanTarget.value,
            amount: this.sanitizedAmount(),
          },
        }),
      }
    );
    this.displayWarnings(response);
  }

  displayWarnings(response) {
    if (response.status === 200) {
      this.showAlert(this.warningMessageTarget);
    } else {
      this.showAlert(this.errorMessageTarget);
    }
  }

  displayError(error) {
    this.errorMessageTarget.innerHTML = error;
    this.errorMessageTarget.hidden = false;
  }

  showAlert(element) {
    element.hidden = false;
    setTimeout(() => {
      element.hidden = true;
    }, 3000);
  }

  sanitizedAmount() {
    return parseFloat(this.amountTarget.value);
  }

  validateForm() {
    if (!this.validateIban()) {
      this.displayError(
        "You've entered an IBAN of the same bank account you are trying to send money from"
      );
      return false;
    }
    return true;
  }

  validateIban() {
    const selectedIBAN =
      this.bankAccountIdTarget.selectedOptions[0].dataset.iban;
    return selectedIBAN !== this.ibanTarget.value;
  }

  resetForm() {
    this.errorMessageTarget.hidden = true;
    this.errorMessageTarget.innerHTML = this.initialErrorMessage;
  }
}
