import { NotificationPopups } from "./notificationPopups.js"

// Utils.timeout(100, () => Utils.notify({
// 	summary: "Notification Popup Example",
// 	iconName: "info-symbolic",
// 	body: "Lorem ipsum dolor sit amet, qui minim labore adipisicing "
// 		+ "minim sint cillum sint consectetur cupidatat.",
// 	actions: {
// 		"Cool": () => print("pressed Cool"),
// 	},
// }))

let style;
const theme = Utils.exec('bash -c "echo $CONFIG_THEME"');
if (theme == "dracula") {
	style = "dracula.css";
} else if (theme == "latte") {
	style = "latte.css";
} else {
	style = "frappe.css";
}

App.config({
	style: App.configDir + "/" + style,
	windows: [
		NotificationPopups(1)
	]
})
