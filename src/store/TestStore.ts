import { makeAutoObservable } from "mobx";
import { Vector3 } from "three";
import { Euler } from "three";

// domain
import Panel from "../model/Panel";

// TestStore.ts
class TestStore {
	constructor() {
		makeAutoObservable(this);
	}

	testGeometryRotate(panels: Panel[], code: any): boolean {
		switch (code) {
			case "KeyW":
				panels.forEach((panel: Panel) => {
					panel.pose++;
				});
				return true;
			default:
				break;
		}
		return false;
	}
	position(panel: Panel): Vector3 {
		switch (panel.pose % 6) {
			case 0:
				return new Vector3(panel.width / 2, panel.thick / 2, panel.height / 2);
			case 1:
				return new Vector3(panel.thick / 2, panel.width / 2, panel.height / 2);
			case 2:
				return new Vector3(panel.height / 2, panel.thick / 2, panel.width / 2);
			case 3:
				return new Vector3(panel.height / 2, panel.width / 2, panel.thick / 2);
			case 4:
				return new Vector3(panel.width / 2, panel.height / 2, panel.thick / 2);
			case 5:
				return new Vector3(panel.thick / 2, panel.height / 2, panel.width / 2);
			default:
				break;
		}

		return new Vector3(0, 0, 0);
	}
	rotation(panel: Panel): Euler {
		switch (panel.pose % 6) {
			case 0:
				return new Euler(0, 0, 0, "XYZ");
			case 1:
				return new Euler(0, 0, Math.PI / 2, "XYZ");
			case 2:
				return new Euler(0, Math.PI / 2, 0, "XYZ");
			case 3:
				return new Euler(Math.PI / 2, Math.PI / 2, 0, "XYZ");
			case 4:
				return new Euler(Math.PI / 2, 0, 0, "XYZ");
			case 5:
				return new Euler(Math.PI / 2, 0, Math.PI / 2, "XYZ");
			default:
				break;
		}

		return new Euler(0, 0, 0, "XYZ");
	}
	multiply(A: any[], B: any[]): any {
		let C: any[] = [];
		for (let cx = 0; cx < A.length; cx++) {
			let rowC: any[] = [];
			C.push(rowC);
			for (let cy = 0; cy < A[0].length; cy++) {
				let value: any = 0;
				for (let cz = 0; cz < A[0].length; cz++) {
					value += (A[cx][cy] * B[cy][cx]);
				}
				rowC.push(value);
			}
		}
		
		return C;
	}
	calculate(code: any, position: any, target: any): any {
		const dp: any = {
			x: 0,
			y: 0,
			z: 0,
		};
		const distance = Math.sqrt((position.x - target.x) * (position.x - target.x)
									+ (position.y - target.y) * (position.y - target.y)
									+ (position.z - target.z) * (position.z - target.z));
		const dradian = 0.1;
		const radian = Math.atan2(position.z - target.z, position.x - target.x);
		switch (code) {
			//	카메라
			case "ArrowDown":
				dp.x = (distance + 1) * Math.cos(radian) - (distance) * Math.cos(radian);
				dp.z = (distance + 1) * Math.sin(radian) - (distance) * Math.sin(radian);
				break;
			case "ArrowUp":
				dp.x = (distance - 1) * Math.cos(radian) - (distance) * Math.cos(radian);
				dp.z = (distance - 1) * Math.sin(radian) - (distance) * Math.sin(radian);
				break;
			case "ArrowLeft":
				dp.x = (distance) * Math.cos(radian - dradian) - (distance) * Math.cos(radian);
				dp.z = (distance) * Math.sin(radian - dradian) - (distance) * Math.sin(radian);
				break;
			case "ArrowRight":
				dp.x = (distance) * Math.cos(radian + dradian) - (distance) * Math.cos(radian);
				dp.z = (distance) * Math.sin(radian + dradian) - (distance) * Math.sin(radian);
				break;
			case "PageDown":
			case "PageUp":
				dp.x = (distance) * Math.cos(radian) - (position.x - target.x);
				dp.z = (distance) * Math.sin(radian) - (position.z - target.z);
				break;
			default:
				break;
		}

		return dp;
	}
}

const store = new TestStore();
export default store;
