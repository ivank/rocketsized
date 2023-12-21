/**
 * @type {import("@types/phoenix_live_view").ViewHook}
 */

export const combobox = {
  /**
   *
   * @param {KeyboardEvent} event
   */
  onGlobalKeyUp(event) {
    const list = document.getElementById(`${this.el.id}_options`);
    if (list) {
      if (event.key === 'ArrowDown' && event.target === this.el) {
        list.firstElementChild.focus();
        event.preventDefault();
        event.stopPropagation();
      }
      if (event.key === 'ArrowUp' && event.target.parentElement === list) {
        event.target.previousElementSibling.focus();
        event.preventDefault();
        event.stopPropagation();
      }
      if (event.key === 'ArrowDown' && event.target.parentElement === list) {
        event.target.nextElementSibling.focus();
        event.preventDefault();
        event.stopPropagation();
      }
      if (event.key === 'Escape') {
        this.pushEventTo(`#${this.el.id}`, 'clear');
      }
    }
  },
  mounted() {
    document.addEventListener('keydown', this.onGlobalKeyUp.bind(this));
  },
  destroyed() {
    document.removeEventListener('keydown', this.onGlobalKeyUp);
  },
};
