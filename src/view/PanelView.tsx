import React from "react";

import * as THREE from "three";
import { Euler, TextureLoader, Vector3 } from "three";
import { useLoader } from "@react-three/fiber";

// domain
import Panel from "../model/Panel.ts";

// store
import store from "../store/TestStore.ts";

// view

// PanelView.tsx
const PanelView = ((props: any) => {
	const panel: Panel = props.panel;
	
	const texture = useLoader(TextureLoader, "/texture/엘더.jpg");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set( 0, 0.5 );
	texture.repeat.set(1, 1);

	console.log(panel);

	return (<>
		<mesh position={store.position(panel)} rotation={store.rotation(panel)}>
			<boxGeometry args={[panel.width, panel.thick, panel.height]} />
			<meshStandardMaterial
				map={texture}
				opacity={0.8}
				transparent
			/>
		</mesh>
	</>);
});
export default PanelView;

export function PanelView0(props: any) {
	const { panel } = props;

	let p = {
		x: panel[6],
		y: panel[7],
		z: panel[8],
	};
	//p = {x: 0, y: panel[0] / 2, z: 0};
	let r = {
		x: panel[3],
		y: panel[4],
		z: panel[5],
	};
	//r = {x: Math.PI / 2, y: 0, z: 0};
	const texture = useLoader(TextureLoader, "/texture/아카시아.jpg");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set( 0, 0.5 );
	texture.repeat.set(1, 1);

	return (<>
		<mesh position={[p.x, p.y, p.z]} rotation={[r.x, r.y, r.z]}>
			<boxGeometry args={[panel[0], panel[1], panel[2]]} />
			<meshStandardMaterial
				map={texture}
				opacity={0.8}
				transparent
			/>
		</mesh>
	</>);
}
