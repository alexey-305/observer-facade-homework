import UIKit
import KeychainAccess

class SettingsViewController: UITableViewController {

    private let keychain = Keychain(service: "com.navigation.app.password")
    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Сортировка" : "Безопасность"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "Алфавитный порядок"
            let isAlphabetical = defaults.bool(forKey: "alphabeticalSort")
            cell.accessoryType = isAlphabetical ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Сменить пароль"
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            let currentValue = defaults.bool(forKey: "alphabeticalSort")
            defaults.set(!currentValue, forKey: "alphabeticalSort")
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            NotificationCenter.default.post(name: NSNotification.Name("SortingChanged"), object: nil)
        } else {
            showChangePasswordAlert()
        }
    }

    private func showChangePasswordAlert() {
        let alert = UIAlertController(title: "Сменить пароль", message: "Введите старый пароль", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Старый пароль"
            textField.isSecureTextEntry = true
        }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Далее", style: .default) { [weak self] _ in
            let oldPassword = alert.textFields?.first?.text ?? ""
            self?.verifyOldPassword(oldPassword)
        })

        present(alert, animated: true)
    }

    private func verifyOldPassword(_ oldPassword: String) {
        guard let savedPassword = try? keychain.get("userPassword") else {
            showAlert("Ошибка", "Пароль не найден")
            return
        }

        if savedPassword == oldPassword {
            showNewPasswordAlert()
        } else {
            showAlert("Ошибка", "Неверный пароль")
        }
    }

    private func showNewPasswordAlert() {
        let alert = UIAlertController(title: "Новый пароль", message: "Введите новый пароль (мин. 4 символа)", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Новый пароль"
            textField.isSecureTextEntry = true
        }

        alert.addTextField { textField in
            textField.placeholder = "Повторите пароль"
            textField.isSecureTextEntry = true
        }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            let newPassword = alert.textFields?.first?.text ?? ""
            let confirmPassword = alert.textFields?.last?.text ?? ""

            if newPassword.count < 4 {
                self?.showAlert("Ошибка", "Пароль должен содержать минимум 4 символа")
            } else if newPassword != confirmPassword {
                self?.showAlert("Ошибка", "Пароли не совпадают")
            } else {
                self?.saveNewPassword(newPassword)
            }
        })

        present(alert, animated: true)
    }

    private func saveNewPassword(_ password: String) {
        do {
            try keychain.set(password, key: "userPassword")
            showAlert("Успех", "Пароль успешно изменён")
        } catch {
            showAlert("Ошибка", "Не удалось сохранить пароль")
        }
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
